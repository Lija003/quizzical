import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/category.dart';
import '../providers/category_provider.dart';
import '../widgets/category_card.dart';
import '../widgets/retry_banner.dart';
import '../widgets/skeleton_loader.dart';
import 'quiz_config_screen.dart';

class CategorySelectionScreen extends StatefulWidget {
  const CategorySelectionScreen({super.key});

  @override
  State<CategorySelectionScreen> createState() => _CategorySelectionScreenState();
}

class _CategorySelectionScreenState extends State<CategorySelectionScreen> {
  @override
  void initState() {
    super.initState();
    // Load categories once per session (cached)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CategoryProvider>().fetchCategories();
    });
  }

  void _onCategorySelected(TriviaCategory category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizConfigScreen(category: category),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Category'),
        actions: [
          IconButton(
            tooltip: 'Refresh Categories',
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () {
              context.read<CategoryProvider>().fetchCategories(forceRefresh: true);
            },
          ),
        ],
      ),
      body: Consumer<CategoryProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const CategorySkeletonGrid();
          }

          if (provider.errorMessage != null && provider.categories.isEmpty) {
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: RetryBanner(
                  message: provider.errorMessage!,
                  onRetry: () => provider.fetchCategories(forceRefresh: true),
                ),
              ),
            );
          }

          final categories = provider.categories;

          return Column(
            children: [
              if (provider.errorMessage != null)
                RetryBanner(
                  message: provider.errorMessage!,
                  onRetry: () => provider.fetchCategories(forceRefresh: true),
                ),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final width = constraints.maxWidth;
                    final crossAxisCount = width > 900 ? 4 : (width > 550 ? 3 : 2);

                    return RefreshIndicator(
                      onRefresh: () => provider.fetchCategories(forceRefresh: true),
                      child: GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                          childAspectRatio: 1.05,
                        ),
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final category = categories[index];
                          return CategoryCard(
                            category: category,
                            onTap: () => _onCategorySelected(category),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
