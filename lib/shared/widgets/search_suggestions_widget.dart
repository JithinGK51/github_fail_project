import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../services/search_suggestions_service.dart';

class SearchSuggestionsWidget extends ConsumerStatefulWidget {
  final String query;
  final Function(String) onSuggestionTap;
  final VoidCallback? onClear;

  const SearchSuggestionsWidget({
    super.key,
    required this.query,
    required this.onSuggestionTap,
    this.onClear,
  });

  @override
  ConsumerState<SearchSuggestionsWidget> createState() =>
      _SearchSuggestionsWidgetState();
}

class _SearchSuggestionsWidgetState
    extends ConsumerState<SearchSuggestionsWidget> {
  List<String> _suggestions = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadSuggestions();
  }

  @override
  void didUpdateWidget(SearchSuggestionsWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.query != widget.query) {
      _loadSuggestions();
    }
  }

  Future<void> _loadSuggestions() async {
    if (widget.query.trim().isEmpty) {
      setState(() {
        _suggestions = [];
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final suggestionsService = ref.read(searchSuggestionsServiceProvider);
      final suggestions = await suggestionsService.getSuggestions(widget.query);

      if (mounted) {
        setState(() {
          _suggestions = suggestions;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _suggestions = [];
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _onSuggestionTap(String suggestion) async {
    // Add to suggestions history
    final suggestionsService = ref.read(searchSuggestionsServiceProvider);
    await suggestionsService.addSuggestion(suggestion);

    widget.onSuggestionTap(suggestion);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (widget.query.trim().isEmpty || _suggestions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  Icons.history_rounded,
                  color: theme.primaryColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Suggestions',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.primaryColor,
                  ),
                ),
                const Spacer(),
                if (widget.onClear != null)
                  GestureDetector(
                    onTap: widget.onClear,
                    child: Icon(
                      Icons.clear_rounded,
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                      size: 18,
                    ),
                  ),
              ],
            ),
          ),

          // Suggestions List
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _suggestions.length,
              itemBuilder: (context, index) {
                final suggestion = _suggestions[index];
                return _buildSuggestionItem(suggestion, theme);
              },
            ),
        ],
      ),
    ).animate().fadeIn(duration: 200.ms).slideY(begin: -10);
  }

  Widget _buildSuggestionItem(String suggestion, ThemeData theme) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _onSuggestionTap(suggestion),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(
                Icons.search_rounded,
                color: theme.colorScheme.onSurface.withOpacity(0.5),
                size: 18,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  suggestion,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.8),
                  ),
                ),
              ),
              Icon(
                Icons.north_west_rounded,
                color: theme.colorScheme.onSurface.withOpacity(0.3),
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
