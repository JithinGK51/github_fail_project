import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SearchBarWidget extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onSearch;
  final Function(String)? onChanged;
  final VoidCallback? onClear;
  final String hintText;
  final bool enabled;

  const SearchBarWidget({
    super.key,
    required this.controller,
    required this.onSearch,
    this.onChanged,
    this.onClear,
    required this.hintText,
    this.enabled = true,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onFocusChange(bool hasFocus) {
    setState(() {
      _isFocused = hasFocus;
    });

    if (hasFocus) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  void _onSearch() {
    if (widget.controller.text.trim().isNotEmpty) {
      widget.onSearch(widget.controller.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color:
                    _isFocused
                        ? theme.primaryColor
                        : theme.colorScheme.outline.withOpacity(0.3),
                width: _isFocused ? 2 : 1,
              ),
              boxShadow:
                  _isFocused
                      ? [
                        BoxShadow(
                          color: theme.primaryColor.withOpacity(0.1),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ]
                      : null,
            ),
            child: TextField(
              controller: widget.controller,
              enabled: widget.enabled,
              onChanged: (value) {
                if (widget.onChanged != null) {
                  widget.onChanged!(value);
                }
                if (value.trim().isEmpty && widget.onClear != null) {
                  widget.onClear!();
                }
              },
              onSubmitted: (_) => _onSearch(),
              onTap: () => _onFocusChange(true),
              onTapOutside: (_) => _onFocusChange(false),
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.5),
                ),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color:
                      _isFocused
                          ? theme.primaryColor
                          : theme.colorScheme.onSurface.withOpacity(0.5),
                ),
                suffixIcon:
                    widget.controller.text.isNotEmpty
                        ? IconButton(
                          icon: Icon(
                            Icons.clear_rounded,
                            color: theme.colorScheme.onSurface.withOpacity(0.5),
                          ),
                          onPressed: () {
                            widget.controller.clear();
                            if (widget.onClear != null) {
                              widget.onClear!();
                            }
                          },
                        )
                        : IconButton(
                          icon: Icon(
                            Icons.search_rounded,
                            color: theme.primaryColor,
                          ),
                          onPressed: _onSearch,
                        ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
              style: theme.textTheme.bodyLarge,
            ),
          ),
        );
      },
    ).animate().fadeIn(duration: 300.ms).slideY(begin: -20);
  }
}
