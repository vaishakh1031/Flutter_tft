import 'package:flutter/material.dart';

import '../home/home_page.dart';

/// Shell page for the left-hand submenu (Cells / Battery / Motor / ...).
/// The left nav stays fixed; only the right side changes when you tap items.
class CellsPage extends StatefulWidget {
  const CellsPage({super.key});

  @override
  State<CellsPage> createState() => _CellsPageState();
}

class _CellsPageState extends State<CellsPage> {
  _NavItem _selected = _NavItem.cells;

  String get _title {
    switch (_selected) {
      case _NavItem.cells:
        return '<< CELLS >>';
      case _NavItem.battery:
        return '<< BATTERY >>';
      case _NavItem.motor:
        return '<< MOTOR >>';
      case _NavItem.bmsStatus:
        return '<< BMS STATUS >>';
      case _NavItem.errorInfo:
        return '<< ERROR INFO >>';
      case _NavItem.advanced:
        return '<< ADVANCED >>';
    }
  }

  Widget? get _content {
    switch (_selected) {
      case _NavItem.cells:
        return _CellsContent();
      case _NavItem.battery:
        return _BatteryContent();
      case _NavItem.motor:
        return _MotorContent();
      case _NavItem.bmsStatus:
        return _BmsStatusContent();
      case _NavItem.errorInfo:
        return _ErrorInfoContent();
      case _NavItem.advanced:
        return _AdvancedContent();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: LayoutBuilder(
        builder: (context, constraints) {
          const designSize = Size(1024, 600);
          return Center(
            child: FittedBox(
              fit: BoxFit.contain,
              child: SizedBox(
                width: designSize.width,
                height: designSize.height,
                child: Stack(
                  children: [
                    const _CellsBackground(),
                    _LeftNav(
                      selected: _selected,
                      onNavTap: (ctx, item) {
                        if (item == _selected) return;
                        setState(() => _selected = item);
                      },
                    ),
                    const _TopStrip(),
                    _TopTitle(title: _title),
                    // ignore: use_null_aware_elements
                    if (_content != null) _content!,
                    const _LogoBackButton(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

enum _NavItem { cells, battery, motor, bmsStatus, errorInfo, advanced }

class _LogoBackButton extends StatelessWidget {
  const _LogoBackButton();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 12,
      top: 12,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute<void>(builder: (_) => const HomePage()),
              (route) => false,
            );
          },
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Image.asset(
              'assets/images/logo.png',
              width: 44,
              height: 44,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}

class _TopStrip extends StatelessWidget {
  const _TopStrip();

  static const double _navWidth = 190;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _navWidth,
      right: 0,
      top: 0,
      height: 56,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: Color(0xFF2B2B2B),
        ),
      ),
    );
  }
}

class _LeftNav extends StatelessWidget {
  const _LeftNav({
    required this.selected,
    required this.onNavTap,
  });

  final _NavItem selected;
  final void Function(BuildContext context, _NavItem item) onNavTap;

  static const _text = Color(0xFFEFEFEF);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      top: 0,
      bottom: 0,
      width: 190,
      child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF2B2B2B),
                  Color(0xFF151515),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            bottom: 0,
            right: 0,
            width: 3,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFFFFFFF), Color(0xFFFFFFFF)],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 22, top: 80, right: 10, bottom: 18),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _NavLabel(
                      label: 'CELLS',
                      selected: selected == _NavItem.cells,
                      onTap: () => onNavTap(context, _NavItem.cells),
                    ),
                    const SizedBox(height: 26),
                    _NavLabel(
                      label: 'BATTERY',
                      selected: selected == _NavItem.battery,
                      onTap: () => onNavTap(context, _NavItem.battery),
                    ),
                    const SizedBox(height: 26),
                    _NavLabel(
                      label: 'MOTOR',
                      selected: selected == _NavItem.motor,
                      onTap: () => onNavTap(context, _NavItem.motor),
                    ),
                    const SizedBox(height: 26),
                    _NavLabel(
                      label: 'BMS STATUS',
                      selected: selected == _NavItem.bmsStatus,
                      onTap: () => onNavTap(context, _NavItem.bmsStatus),
                    ),
                    const SizedBox(height: 26),
                    _NavLabel(
                      label: 'ERROR INFO',
                      selected: selected == _NavItem.errorInfo,
                      onTap: () => onNavTap(context, _NavItem.errorInfo),
                    ),
                    const SizedBox(height: 26),
                    _NavLabel(
                      label: 'ADVANCED',
                      selected: selected == _NavItem.advanced,
                      onTap: () => onNavTap(context, _NavItem.advanced),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 22,
            top: 22,
            child: Text(
              '',
              style: const TextStyle(color: _text),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavLabel extends StatelessWidget {
  const _NavLabel({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final text = Text(
      label,
      style: TextStyle(
        color: Colors.white.withValues(alpha: 0.95),
        fontSize: 20,
        fontWeight: FontWeight.w900,
        letterSpacing: 1.2,
      ),
    );
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
          child: text,
        ),
      ),
    );
  }
}

class _TopTitle extends StatelessWidget {
  const _TopTitle({required this.title});

  final String title;

  static const double _navWidth = 190;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 16,
      left: _navWidth,
      right: 0,
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.9),
            fontSize: 22,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.4,
          ),
        ),
      ),
    );
  }
}

class _CellsContent extends StatelessWidget {
  _CellsContent();

  final _labelStyle = TextStyle(
    color: Colors.white.withValues(alpha: 0.85),
    fontSize: 22,
    fontWeight: FontWeight.w900,
    letterSpacing: 1.1,
  );

  final _valueStyle = const TextStyle(
    color: Colors.white,
    fontSize: 22,
    fontWeight: FontWeight.w800,
  );

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      left: 190,
      child: Padding(
        padding: const EdgeInsets.only(top: 88),
        child: Stack(
          children: [
            Positioned(
              left: 350,
              top: 20,
              child: Text('Cell Index', style: _labelStyle),
            ),
            Positioned(
              left: 150,
              top: 92,
              child: _VoltagePill(text: '3.68V'),
            ),
            Positioned(
              left: 170,
              top: 190,
              child: Text('MAX: 3.78 V', style: _valueStyle),
            ),
            Positioned(
              left: 170,
              top: 250,
              child: Text('MIN: 3.63 V', style: _valueStyle),
            ),
            Positioned(
              left: 520,
              top: 190,
              child: RichText(
                text: TextSpan(
                  style: _valueStyle,
                  children: [
                    const TextSpan(text: 'Cell Temperature: '),
                    TextSpan(
                      text: '33.1 °C',
                      style: _valueStyle.copyWith(color: const Color(0xFF33FF33)),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 520,
              top: 250,
              child: Text('Dynamic Voltage: 74.2 V', style: _valueStyle),
            ),
          ],
        ),
      ),
    );
  }
}

class _BatteryContent extends StatelessWidget {
  const _BatteryContent();

  static const _labelColor = Colors.white;
  static const _green = Color(0xFF33FF33);
  static const _orange = Color(0xFFFFA726);
  static const _red = Color(0xFFFF5252);

  TextStyle get _labelStyle => const TextStyle(
        color: _labelColor,
        fontSize: 22,
        fontWeight: FontWeight.w800,
      );

  TextStyle get _valueStyle => const TextStyle(
        color: _labelColor,
        fontSize: 22,
        fontWeight: FontWeight.w800,
      );

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      left: 190,
      child: Padding(
        padding: const EdgeInsets.only(top: 180),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Spacer above the two columns
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // LEFT COLUMN
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: _labelStyle,
                        children: const [
                          TextSpan(text: 'Battery Percentage (SOC): '),
                          TextSpan(
                            text: '78%',
                            style: TextStyle(color: _green),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Battery Current: 16.4 A',
                      style: _valueStyle,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Initial Battery Capacity: 4.8 kWh',
                      style: _valueStyle,
                    ),
                  ],
                ),

                const SizedBox(width: 120),

                // RIGHT COLUMN
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Battery Voltage: 74.6V',
                      style: _valueStyle,
                    ),
                    const SizedBox(height: 24),
                    RichText(
                      text: TextSpan(
                        style: _labelStyle,
                        children: [
                          const TextSpan(text: 'Battery Temperature: '),
                          TextSpan(
                            text: '34.2°C',
                            style: const TextStyle(color: _orange),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    RichText(
                      text: TextSpan(
                        style: _labelStyle,
                        children: [
                          const TextSpan(text: 'BMS Temperature: '),
                          TextSpan(
                            text: '38.6°C',
                            style: const TextStyle(color: _red),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 60),

            Text(
              'Total Charge Cycles : 112',
              style: _valueStyle.copyWith(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}

class _MotorContent extends StatelessWidget {
  const _MotorContent();

  static const _labelColor = Colors.white;
  static const _orange = Color(0xFFFFA726);
  static const _red = Color(0xFFFF5252);

  TextStyle get _valueStyle => const TextStyle(
        color: _labelColor,
        fontSize: 20,
        fontWeight: FontWeight.w800,
      );

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      left: 190,
      child: Padding(
        padding: const EdgeInsets.only(top: 110),
        child: Column(
          children: [
            const Text(
              'ERPM / Mechanical RPM: 4,860 RPM',
              style: TextStyle(
                color: _labelColor,
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // LEFT COLUMN
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Motor Current: 810 RPM', style: _valueStyle),
                    const SizedBox(height: 18),
                    Text('Duty Cycle: 69%', style: _valueStyle),
                    const SizedBox(height: 18),
                    Text('Wh charged: 1,512 Wh', style: _valueStyle),
                    const SizedBox(height: 18),
                    Text('Wh used: 1,438 Wh', style: _valueStyle),
                    const SizedBox(height: 18),
                    Text('Ah used: 19.9 Ah', style: _valueStyle),
                    const SizedBox(height: 18),
                    Text('Ah hours charged: 20.7 Ah', style: _valueStyle),
                  ],
                ),
                const SizedBox(width: 140),
                // RIGHT COLUMN
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Input Current: 84.7 A', style: _valueStyle),
                    const SizedBox(height: 18),
                    RichText(
                      text: TextSpan(
                        style: _valueStyle,
                        children: [
                          const TextSpan(text: 'Motor Temperature: '),
                          TextSpan(
                            text: '57.6 °C',
                            style: const TextStyle(color: _orange),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    RichText(
                      text: TextSpan(
                        style: _valueStyle,
                        children: [
                          const TextSpan(text: 'FET Temperature: '),
                          TextSpan(
                            text: '64.8 °C',
                            style: const TextStyle(color: _red),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text('Tachometer value: 800 RPM', style: _valueStyle),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _BmsStatusContent extends StatelessWidget {
  const _BmsStatusContent();

  static const _green = Color(0xFF33FF33);
  static const _red = Color(0xFFFF5252);

  TextStyle get _baseStyle => const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w800,
      );

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      left: 190,
      child: Padding(
        padding: const EdgeInsets.only(top: 110, left: 80, right: 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              'Power Channel Pre-charge State ON',
              style: _baseStyle.copyWith(color: _green),
            ),
            const SizedBox(height: 10),
            Text(
              'Power Channel Discharge State ON',
              style: _baseStyle.copyWith(color: _green),
            ),
            const SizedBox(height: 10),
            Text(
              'Power Channel Charge State OFF',
              style: _baseStyle.copyWith(color: _red),
            ),
            const SizedBox(height: 10),
            Text(
              'Power Channel Emergency State OFF',
              style: _baseStyle.copyWith(color: _red),
            ),
            const SizedBox(height: 30),
            Text('Battery Running State', style: _baseStyle),
            const SizedBox(height: 6),
            Text('-Idle', style: _baseStyle),
            Text('-Discharging', style: _baseStyle),
            Text('-Charging', style: _baseStyle),
            Text('-Regen', style: _baseStyle),
            const SizedBox(height: 30),
            Text('State of Overload Running Threshold', style: _baseStyle),
            const SizedBox(height: 10),
            Text('State of Overload Values', style: _baseStyle),
            const SizedBox(height: 10),
            Text('PDU Temp Data', style: _baseStyle),
          ],
        ),
      ),
    );
  }
}

class _ErrorInfoContent extends StatelessWidget {
  const _ErrorInfoContent();

  static const _red = Color(0xFFFF5252);

  TextStyle get _itemStyle => const TextStyle(
        color: _red,
        fontSize: 18,
        fontWeight: FontWeight.w800,
      );

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      left: 190,
      child: Padding(
        padding: const EdgeInsets.only(top: 110, left: 60, right: 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // LEFT COLUMN
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Overvoltage', style: _itemStyle),
                      Text('Undervoltage', style: _itemStyle),
                      Text('Over temp', style: _itemStyle),
                      Text('Under temp', style: _itemStyle),
                      Text('Overload', style: _itemStyle),
                      Text('Current Short - Circuit', style: _itemStyle),
                      Text('Free SB Shutdown', style: _itemStyle),
                      Text('Open connection', style: _itemStyle),
                      Text('PDU Over temperature', style: _itemStyle),
                      Text('Precharge error', style: _itemStyle),
                      Text('BMS Authentication', style: _itemStyle),
                      Text('Interlock', style: _itemStyle),
                    ],
                  ),
                ),
                const SizedBox(width: 40),
                // RIGHT COLUMN
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Precharge load not detected', style: _itemStyle),
                      Text('Unauthorized Charger Detected', style: _itemStyle),
                      Text('Charger authentication failure', style: _itemStyle),
                      Text('Precharge Incompleted', style: _itemStyle),
                      Text('Encryption Key Not Valid', style: _itemStyle),
                    ],
                  ),
                ),
              ],
            ),
            const Spacer(),
            const Align(
              alignment: Alignment.bottomRight,
              child: Text(
                'ref. document',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _AdvancedContent extends StatelessWidget {
  const _AdvancedContent();

  TextStyle get _itemStyle => const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w800,
      );

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      left: 190,
      child: Padding(
        padding: const EdgeInsets.only(top: 140, left: 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Firmware Build Number', style: _itemStyle),
            const SizedBox(height: 24),
            Text('Configuration Version Number', style: _itemStyle),
            const SizedBox(height: 24),
            Text('Battery Version String', style: _itemStyle),
            const SizedBox(height: 24),
            Text('BMS MAC Address', style: _itemStyle),
          ],
        ),
      ),
    );
  }
}

class _VoltagePill extends StatelessWidget {
  const _VoltagePill({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      height: 56,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF2D2D2D), Color(0xFF0C0C0C)],
        ),
        border: Border.all(color: Colors.black, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.8),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            fontFamily: 'Orbitron',
            color: Color(0xFF33FF33),
            fontSize: 26,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

class _CellsBackground extends StatelessWidget {
  const _CellsBackground();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: CustomPaint(
        painter: _CellsBackgroundPainter(),
      ),
    );
  }
}

class _CellsBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    // Pure black background
    canvas.drawRect(
      rect,
      Paint()..color = Colors.black,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

