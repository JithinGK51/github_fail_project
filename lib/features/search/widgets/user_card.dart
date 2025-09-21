import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/github_user.dart';
import '../../../services/storage_service.dart';

class UserCard extends ConsumerStatefulWidget {
  final GitHubUser user;
  final VoidCallback? onTap;

  const UserCard({super.key, required this.user, this.onTap});

  @override
  ConsumerState<UserCard> createState() => _UserCardState();
}

class _UserCardState extends ConsumerState<UserCard>
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
    final isFav = await storageService.isUserFavorite(widget.user.id);
    if (mounted) {
      setState(() {
        _isFavorite = isFav;
      });
    }
  }

  Future<void> _toggleFavorite() async {
    final storageService = ref.read(storageServiceProvider);

    if (_isFavorite) {
      await storageService.removeUserFromFavorites(widget.user.id);
      _favoriteController.reverse();
    } else {
      await storageService.addUserToFavorites(widget.user);
      _favoriteController.forward();
    }

    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  Future<void> _openProfile() async {
    final url = Uri.parse(widget.user.profileUrl);
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
                    // Avatar
                    Hero(
                      tag: 'user_avatar_${widget.user.id}',
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: theme.primaryColor.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: widget.user.avatarUrl ?? '',
                            fit: BoxFit.cover,
                            placeholder:
                                (context, url) => Container(
                                  color: theme.primaryColor.withOpacity(0.1),
                                  child: Icon(
                                    Icons.person_rounded,
                                    color: theme.primaryColor,
                                    size: 30,
                                  ),
                                ),
                            errorWidget:
                                (context, url, error) => Container(
                                  color: theme.primaryColor.withOpacity(0.1),
                                  child: Icon(
                                    Icons.person_rounded,
                                    color: theme.primaryColor,
                                    size: 30,
                                  ),
                                ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 16),

                    // User Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.user.displayName,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '@${widget.user.login}',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(
                                0.6,
                              ),
                            ),
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
                              color:
                                  _isFavorite
                                      ? theme.colorScheme.error
                                      : theme.colorScheme.onSurface.withOpacity(
                                        0.4,
                                      ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),

                // Bio
                if (widget.user.bio != null && widget.user.bio!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    widget.user.bio!,
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
                      icon: Icons.people_rounded,
                      label: 'Followers',
                      value: widget.user.followers,
                      theme: theme,
                    ),
                    const SizedBox(width: 24),
                    _buildStatItem(
                      icon: Icons.person_add_rounded,
                      label: 'Following',
                      value: widget.user.following,
                      theme: theme,
                    ),
                    const SizedBox(width: 24),
                    _buildStatItem(
                      icon: Icons.folder_rounded,
                      label: 'Repos',
                      value: widget.user.publicRepos,
                      theme: theme,
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _openProfile,
                        icon: const Icon(Icons.open_in_new_rounded, size: 18),
                        label: const Text('View Profile'),
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
        Icon(icon, size: 16, color: theme.primaryColor),
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

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    } else {
      return number.toString();
    }
  }
}
