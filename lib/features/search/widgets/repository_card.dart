import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/github_repository.dart';
import '../../../services/storage_service.dart';

class RepositoryCard extends ConsumerStatefulWidget {
  final GitHubRepository repository;
  final VoidCallback? onTap;

  const RepositoryCard({
    super.key,
    required this.repository,
    this.onTap,
  });

  @override
  ConsumerState<RepositoryCard> createState() => _RepositoryCardState();
}

class _RepositoryCardState extends ConsumerState<RepositoryCard>
    with TickerProviderStateMixin {
  late AnimationController _favoriteController;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _favoriteController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _checkFavoriteStatus();
  }

  @override
  void dispose() {
    _favoriteController.dispose();
    super.dispose();
  }

  Future<void> _checkFavoriteStatus() async {
    final storageService = ref.read(storageServiceProvider);
    final isFav = await storageService.isRepositoryFavorite(widget.repository.id);
    if (mounted) {
      setState(() {
        _isFavorite = isFav;
      });
    }
  }

  Future<void> _toggleFavorite() async {
    final storageService = ref.read(storageServiceProvider);
    
    if (_isFavorite) {
      await storageService.removeRepositoryFromFavorites(widget.repository.id);
      _favoriteController.reverse();
    } else {
      await storageService.addRepositoryToFavorites(widget.repository);
      _favoriteController.forward();
    }
    
    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  Future<void> _openRepository() async {
    final url = Uri.parse(widget.repository.repoUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  children: [
                    // Repository Icon
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: theme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.folder_rounded,
                        color: theme.primaryColor,
                        size: 24,
                      ),
                    ),
                    
                    const SizedBox(width: 12),
                    
                    // Repository Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.repository.name,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            widget.repository.fullName,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(0.6),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    
                    // Favorite Button
                    IconButton(
                      onPressed: _toggleFavorite,
                      icon: AnimatedBuilder(
                        animation: _favoriteController,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: 1.0 + (_favoriteController.value * 0.2),
                            child: Icon(
                              _isFavorite 
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              color: _isFavorite 
                                  ? theme.colorScheme.error
                                  : theme.colorScheme.onSurface.withOpacity(0.4),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                
                // Description
                if (widget.repository.description != null && 
                    widget.repository.description!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    widget.repository.displayDescription,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.8),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                
                const SizedBox(height: 16),
                
                // Stats Row
                Row(
                  children: [
                    _buildStatItem(
                      icon: Icons.star_rounded,
                      label: 'Stars',
                      value: widget.repository.stargazersCount,
                      theme: theme,
                    ),
                    const SizedBox(width: 16),
                    _buildStatItem(
                      icon: Icons.fork_right_rounded,
                      label: 'Forks',
                      value: widget.repository.forksCount,
                      theme: theme,
                    ),
                    const SizedBox(width: 16),
                    if (widget.repository.language != null) ...[
                      _buildLanguageChip(widget.repository.language!, theme),
                      const SizedBox(width: 16),
                    ],
                    _buildSizeChip(widget.repository.formattedSize, theme),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Owner Info
                if (widget.repository.owner != null) ...[
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: theme.primaryColor.withOpacity(0.1),
                        child: CachedNetworkImage(
                          imageUrl: widget.repository.owner!.avatarUrl ?? '',
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Icon(
                            Icons.person_rounded,
                            color: theme.primaryColor,
                            size: 16,
                          ),
                          errorWidget: (context, url, error) => Icon(
                            Icons.person_rounded,
                            color: theme.primaryColor,
                            size: 16,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.repository.owner!.login,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                      const Spacer(),
                      if (widget.repository.updatedAt != null)
                        Text(
                          _formatDate(widget.repository.updatedAt!),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.5),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
                
                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _openRepository,
                        icon: const Icon(Icons.open_in_new_rounded, size: 18),
                        label: const Text('Open'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: widget.onTap,
                        icon: const Icon(Icons.info_outline_rounded, size: 18),
                        label: const Text('Details'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 300.ms).slideX();
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required int value,
    required ThemeData theme,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: theme.primaryColor,
        ),
        const SizedBox(width: 4),
        Text(
          _formatNumber(value),
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.primaryColor,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildLanguageChip(String language, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        language,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.primaryColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildSizeChip(String size, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurface.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        size,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurface.withOpacity(0.6),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    } else {
      return number.toString();
    }
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);
      
      if (difference.inDays > 0) {
        return '${difference.inDays}d ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours}h ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes}m ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return 'Unknown';
    }
  }
}
