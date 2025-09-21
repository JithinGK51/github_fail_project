import 'package:flutter/material.dart';

class AppIcon {
  static Widget build({
    double size = 64.0,
    Color? color,
    bool withBackground = true,
  }) {
    return Container(
      width: size,
      height: size,
      decoration:
          withBackground
              ? BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    color ?? const Color(0xFF6366F1),
                    (color ?? const Color(0xFF6366F1)).withOpacity(0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(size * 0.2),
                boxShadow: [
                  BoxShadow(
                    color: (color ?? const Color(0xFF6366F1)).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              )
              : null,
      child: Icon(
        Icons.code_rounded,
        size: size * 0.6,
        color: withBackground ? Colors.white : color,
      ),
    );
  }
}
