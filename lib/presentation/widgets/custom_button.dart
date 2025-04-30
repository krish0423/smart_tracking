import 'package:flutter/material.dart';

enum ButtonType { primary, secondary, outline, text }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final ButtonType type;
  final bool isLoading;
  final bool isFullWidth;
  final double height;
  final IconData? iconData;
  final bool iconLeading;
  final Color? backgroundColor;
  final Color? textColor;
  final double fontSize;
  final FontWeight fontWeight;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final bool disabled;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.type = ButtonType.primary,
    this.isLoading = false,
    this.isFullWidth = true,
    this.height = 52,
    this.iconData,
    this.iconLeading = true,
    this.backgroundColor,
    this.textColor,
    this.fontSize = 16,
    this.fontWeight = FontWeight.w600,
    this.borderRadius = 8,
    this.padding,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget buttonContent = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading)
          SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                _getContentColor(theme),
              ),
              strokeWidth: 2,
            ),
          )
        else ...[
          if (iconData != null && iconLeading) ...[
            Icon(
              iconData,
              color: _getContentColor(theme),
              size: fontSize + 4,
            ),
            const SizedBox(width: 8),
          ],
          Text(
            text,
            style: TextStyle(
              color: textColor ?? _getContentColor(theme),
              fontSize: fontSize,
              fontWeight: fontWeight,
            ),
          ),
          if (iconData != null && !iconLeading) ...[
            const SizedBox(width: 8),
            Icon(
              iconData,
              color: _getContentColor(theme),
              size: fontSize + 4,
            ),
          ],
        ],
      ],
    );

    Widget buttonWidget;

    switch (type) {
      case ButtonType.primary:
        buttonWidget = ElevatedButton(
          onPressed: (isLoading || disabled) ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ?? theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
            disabledBackgroundColor: theme.colorScheme.primary.withOpacity(0.5),
            disabledForegroundColor: theme.colorScheme.onPrimary.withOpacity(0.7),
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            elevation: 0,
            minimumSize: Size(isFullWidth ? double.infinity : 100, height),
          ),
          child: buttonContent,
        );
        break;
      case ButtonType.secondary:
        buttonWidget = ElevatedButton(
          onPressed: (isLoading || disabled) ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ?? theme.colorScheme.secondary,
            foregroundColor: theme.colorScheme.onSecondary,
            disabledBackgroundColor: theme.colorScheme.secondary.withOpacity(0.5),
            disabledForegroundColor: theme.colorScheme.onSecondary.withOpacity(0.7),
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            elevation: 0,
            minimumSize: Size(isFullWidth ? double.infinity : 100, height),
          ),
          child: buttonContent,
        );
        break;
      case ButtonType.outline:
        buttonWidget = OutlinedButton(
          onPressed: (isLoading || disabled) ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: backgroundColor ?? theme.colorScheme.primary,
            disabledForegroundColor: theme.colorScheme.primary.withOpacity(0.5),
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            side: BorderSide(
              color: (isLoading || disabled)
                  ? (backgroundColor ?? theme.colorScheme.primary).withOpacity(0.5)
                  : backgroundColor ?? theme.colorScheme.primary,
              width: 1.5,
            ),
            minimumSize: Size(isFullWidth ? double.infinity : 100, height),
          ),
          child: buttonContent,
        );
        break;
      case ButtonType.text:
        buttonWidget = TextButton(
          onPressed: (isLoading || disabled) ? null : onPressed,
          style: TextButton.styleFrom(
            foregroundColor: backgroundColor ?? theme.colorScheme.primary,
            disabledForegroundColor: theme.colorScheme.primary.withOpacity(0.5),
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            minimumSize: Size(isFullWidth ? double.infinity : 100, height),
          ),
          child: buttonContent,
        );
        break;
    }

    return buttonWidget;
  }

  Color _getContentColor(ThemeData theme) {
    switch (type) {
      case ButtonType.primary:
        return textColor ?? theme.colorScheme.onPrimary;
      case ButtonType.secondary:
        return textColor ?? theme.colorScheme.onSecondary;
      case ButtonType.outline:
      case ButtonType.text:
        return textColor ?? theme.colorScheme.primary;
    }
  }
} 