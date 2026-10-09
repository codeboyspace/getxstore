import 'package:flutter/material.dart';

class QuantityStepper extends StatelessWidget {
  final int value;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;
  final bool isDecreaseEnabled;
  final bool isIncreaseEnabled;
  final double height;
  final double buttonSize;
  final double iconSize;
  final double valueWidth;
  final double borderRadius;
  final TextStyle? valueStyle;

  const QuantityStepper({
    super.key,
    required this.value,
    required this.onDecrease,
    required this.onIncrease,
    this.isDecreaseEnabled = true,
    this.isIncreaseEnabled = true,
    this.height = 40,
    this.buttonSize = 38,
    this.iconSize = 18,
    this.valueWidth = 34,
    this.borderRadius = 8,
    this.valueStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFD8D8D8)),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _QuantityButton(
            icon: Icons.remove,
            semanticLabel: 'Decrease quantity',
            size: buttonSize,
            iconSize: iconSize,
            onPressed: isDecreaseEnabled ? onDecrease : null,
            enabled: isDecreaseEnabled,
          ),
          SizedBox(
            width: valueWidth,
            child: Text(
              '$value',
              textAlign: TextAlign.center,
              style:
                  valueStyle ??
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
          _QuantityButton(
            icon: Icons.add,
            semanticLabel: 'Increase quantity',
            size: buttonSize,
            iconSize: iconSize,
            onPressed: isIncreaseEnabled ? onIncrease : null,
            enabled: isIncreaseEnabled,
          ),
        ],
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final String semanticLabel;
  final double size;
  final double iconSize;
  final VoidCallback? onPressed;
  final bool enabled;

  const _QuantityButton({
    required this.icon,
    required this.semanticLabel,
    required this.size,
    required this.iconSize,
    required this.onPressed,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: IconButton(
        tooltip: semanticLabel,
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        visualDensity: VisualDensity.compact,
        icon: Icon(
          icon,
          size: iconSize,
          color: enabled ? Colors.black87 : Colors.grey.shade400,
        ),
      ),
    );
  }
}
