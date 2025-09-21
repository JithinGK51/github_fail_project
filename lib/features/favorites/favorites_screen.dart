import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../services/storage_service.dart';
import '../../shared/widgets/empty_state_widget.dart';
import '../search/widgets/user_card.dart';
import '../search/widgets/repository_card.dart';

class FavoritesScreen extends ConsumerStatefulWidget {
  const FavoritesScreen({super.key});

  @override
  ConsumerState<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends ConsumerState<FavoritesScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  List<dynamic> _favoriteUsers = [];
  List<dynamic> _favoriteRepositories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadFavorites();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadFavorites() async {
    final storageService = ref.read(storageServiceProvider);
    
    try {
      final users = await storageService.getFavoriteUsers();
      final repositories = await storageService.getFavoriteRepositories();
      
      if (mounted) {
        setState(() {
          _favoriteUsers = users;
          _favoriteRepositories = repositories;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: theme.shadowColor.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Favorites',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your saved users and repositories',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Tab Bar
                  Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(
                        color: theme.primaryColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      labelColor: theme.colorScheme.onPrimary,
                      unselectedLabelColor: theme.colorScheme.onSurface.withOpacity(0.6),
                      labelStyle: const TextStyle(fontWeight: FontWeight.w600),
                      tabs: [
                        Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.people_rounded, size: 18),
                              const SizedBox(width: 8),
                              Text('Users (${_favoriteUsers.length})'),
                            ],
                          ),
                        ),
                        Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.folder_rounded, size: 18),
                              const SizedBox(width: 8),
                              Text('Repos (${_favoriteRepositories.length})'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Content
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : TabBarView(
                      controller: _tabController,
                      children: [
                        _buildUsersTab(),
                        _buildRepositoriesTab(),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUsersTab() {
    if (_favoriteUsers.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.people_outline_rounded,
        title: 'No Favorite Users',
        subtitle: 'Users you favorite will appear here',
        actionText: 'Explore Users',
        onAction: () {
          // Navigate to search tab
          // This would be handled by the parent widget
        },
      );
    }

    return RefreshIndicator(
      onRefresh: _loadFavorites,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _favoriteUsers.length,
        itemBuilder: (context, index) {
          final user = _favoriteUsers[index];
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 375),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: UserCard(
                    user: user,
                    onTap: () => _showUserDetails(user),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRepositoriesTab() {
    if (_favoriteRepositories.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.folder_outlined,
        title: 'No Favorite Repositories',
        subtitle: 'Repositories you favorite will appear here',
        actionText: 'Explore Repos',
        onAction: () {
          // Navigate to search tab
          // This would be handled by the parent widget
        },
      );
    }

    return RefreshIndicator(
      onRefresh: _loadFavorites,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _favoriteRepositories.length,
        itemBuilder: (context, index) {
          final repository = _favoriteRepositories[index];
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 375),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: RepositoryCard(
                    repository: repository,
                    onTap: () => _showRepositoryDetails(repository),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showUserDetails(user) {
    // TODO: Implement user details screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('User details: ${user.login}')),
    );
  }

  void _showRepositoryDetails(repository) {
    // TODO: Implement repository details screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Repository details: ${repository.name}')),
    );
  }
}
