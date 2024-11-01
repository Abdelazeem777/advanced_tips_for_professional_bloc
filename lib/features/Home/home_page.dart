import 'package:bloc_example/features/Home/home_cubit.dart';
import 'package:bloc_example/features/Home/post_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'home_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit()..getPosts(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Bloc Demo'),
        ),
        body: Builder(builder: (context) => _buildBody(context)),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final cubit = context.read<HomeCubit>();

    return RefreshIndicator(
      onRefresh: cubit.getPosts,
      child: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {
          if (state.isError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                duration: const Duration(seconds: 2),
              ),
            );
          }

          // if (state.postIndex != null) {
          //   _goToPostPage(context, state.postIndex);
          // }
        },
        builder: (context, state) {
          if (state.isInitial || state.isLoading)
            return const Center(child: CircularProgressIndicator());

          final posts = state.posts ?? [];

          if (posts.isEmpty)
            return const SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: const Center(
                child: Text('No posts found'),
              ),
            );

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return PostCard(
                post: post,
                onLongPress: () => cubit.removePost(index),
              );
            },
          );
        },
      ),
    );
  }

  void _goToPostPage(BuildContext context, int? postIndex) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<HomeCubit>(),
          child: Center(child: Text('Post page $postIndex')),
        ),
      ),
    );
  }
}

class PostCard extends StatelessWidget {
  const PostCard({
    super.key,
    required this.post,
    required this.onLongPress,
  });

  final VoidCallback onLongPress;
  final PostModel post;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HomeCubit>();
    return ListTile(
      title: Text(post.title),
      subtitle: Text(post.body),
      onLongPress: onLongPress,
      // onTap: () => cubit.getPost(index),
    );
  }
}
