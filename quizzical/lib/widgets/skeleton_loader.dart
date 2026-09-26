import 'package:flutter/material.dart';

class SkeletonLoader extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;

  const SkeletonLoader({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 12,
  });

  @override
  State<SkeletonLoader> createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<SkeletonLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.3, end: 0.8).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: Colors.grey.shade300.withOpacity(_animation.value),
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
        );
      },
    );
  }
}

class CategorySkeletonGrid extends StatelessWidget {
  const CategorySkeletonGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.1,
          ),
          itemCount: 8,
          itemBuilder: (context, index) {
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SkeletonLoader(width: 48, height: 48, borderRadius: 24),
                  SizedBox(height: 12),
                  SkeletonLoader(width: 100, height: 16, borderRadius: 6),
                  SizedBox(height: 6),
                  SkeletonLoader(width: 60, height: 12, borderRadius: 6),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class QuestionSkeleton extends StatelessWidget {
  const QuestionSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          const SkeletonLoader(width: 120, height: 18, borderRadius: 6),
          const SizedBox(height: 24),
          const SkeletonLoader(width: double.infinity, height: 28, borderRadius: 8),
          const SizedBox(height: 12),
          const SkeletonLoader(width: 250, height: 28, borderRadius: 8),
          const SizedBox(height: 40),
          ...List.generate(
            4,
            (index) => const Padding(
              padding: EdgeInsets.only(bottom: 14),
              child: SkeletonLoader(
                width: double.infinity,
                height: 56,
                borderRadius: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
