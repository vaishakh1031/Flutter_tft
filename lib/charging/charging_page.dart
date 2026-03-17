import 'dart:async';
import '../home/home_page.dart';
import 'package:flutter/material.dart';


class ChargingPage extends StatefulWidget {
  const ChargingPage({super.key});

  @override
  State<ChargingPage> createState() => _ChargingPageState();
}

class _ChargingPageState extends State<ChargingPage> {
  late DateTime _now;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _timeText {
    final h = _now.hour % 12 == 0 ? 12 : _now.hour % 12;
    final mm = _now.minute.toString().padLeft(2, '0');
    return '$h:$mm';
  }

  @override
  Widget build(BuildContext context) {
    // Fixed "design size" + scale-to-fit to match your other screens.
    const designSize = Size(1024, 600);

    return Scaffold(
      backgroundColor: Colors.black,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: FittedBox(
              fit: BoxFit.contain,
              child: SizedBox(
                width: designSize.width,
                height: designSize.height,
                child: Stack(
                  children: [
                    const _Bg(),
                    _TopStatusRow(timeText: _timeText),
                    const _Bike(),
                    const _ChargingPanel(),
                    const _BottomDivider(),
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

class _Bg extends StatelessWidget {
  const _Bg();

  @override
  Widget build(BuildContext context) {
    return const Positioned.fill(
      child: DecoratedBox(
        decoration: BoxDecoration(color: Colors.black),
      ),
    );
  }
}

class _TopStatusRow extends StatelessWidget {
  const _TopStatusRow({required this.timeText});

  final String timeText;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 14,
      left: 0,
      right: 0,
      child: DefaultTextStyle(
        style: TextStyle(
          fontFamily: 'Orbitron',
          color: Colors.white.withValues(alpha: 0.9),
          fontSize: 18,
          fontWeight: FontWeight.w800,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.network_cell,
              color: Colors.white.withValues(alpha: 0.7),
              size: 18,
            ),
            const SizedBox(width: 24),
            Text(timeText),
            const SizedBox(width: 24),
            const Text('R6'),
          ],
        ),
      ),
    );
  }
}

class _Bike extends StatelessWidget {
  const _Bike();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      top: 70,
      width: 520,
      height: 520,
      child: Opacity(
        opacity: 0.95,
        child: Image.asset(
          'assets/images/bike_img.png',
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
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
              'assets/images/logo.png', // 👈 HERE
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
class _ChargingPanel extends StatelessWidget {
  const _ChargingPanel();

  static const _green = Color(0xFF33FF33);
  static const _muted = Color(0xFFB8B8B8);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 460,
      right: 60,
      top: 190,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Charging',
            style: TextStyle(
              color: _green,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 12),
          _ChargingBar(progress: 0.62),
          const SizedBox(height: 22),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              _Metric(
                label: 'Battery',
                value: '86%',
                valueColor: _green,
              ),
              _Metric(
                label: 'Range',
                value: '37Km',
              ),
              _Metric(
                label: 'Current Mode',
                value: 'CRAWL',
              ),
            ],
          ),
          const SizedBox(height: 26),
          const Text(
            '4 hrs remaining',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChargingBar extends StatelessWidget {
  const _ChargingBar({required this.progress});

  final double progress;

  static const _green = Color(0xFF33FF33);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 18,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Colors.white.withValues(alpha: 0.15),
            Colors.white.withValues(alpha: 0.08),
          ],
        ),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: FractionallySizedBox(
          widthFactor: progress.clamp(0.0, 1.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  _green.withValues(alpha: 0.25),
                  _green.withValues(alpha: 0.9),
                  _green.withValues(alpha: 0.35),
                ],
                stops: const [0.0, 0.55, 1.0],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;

  static const _muted = Color(0xFFB8B8B8);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(
            color: _muted.withValues(alpha: 0.95),
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: valueColor ?? Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _BottomDivider extends StatelessWidget {
  const _BottomDivider();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 20,
      right: 20,
      bottom: 22,
      height: 2,
      child: Container(
        color: Colors.white.withValues(alpha: 0.12),
      ),
    );
  }
}

