import 'package:flutter/material.dart';

class StatBar extends StatelessWidget {
  final String label;
  final int value;
  final int maxValue;
  final bool? hasPercentage;

  const StatBar({
    super.key,
    required this.label,
    required this.value,
    required this.maxValue,
    this.hasPercentage = false,
  });

  Color getColor(double percent) {
    if (percent < 0.2) return Colors.orange;
    if (percent < 0.5) return Colors.orange.shade200;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    final percent = value / maxValue;
    return Row(
      children: [
        SizedBox(
            width: 70,
            child: Text(label, style: const TextStyle(color: Colors.grey))),
        SizedBox(
            width: 40,
            child: hasPercentage!
                ? Text('${value.toString()}%')
                : Text(value.toString())),
        Expanded(
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: percent),
            duration: const Duration(seconds: 1),
            builder: (context, animatedValue, _) {
              return Stack(
                children: [
                  Container(
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: animatedValue,
                    child: Container(
                      height: 5,
                      decoration: BoxDecoration(
                        color: getColor(animatedValue),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
