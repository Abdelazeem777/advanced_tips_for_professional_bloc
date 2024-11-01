import 'package:flutter/foundation.dart';

import 'package:bloc_example/features/Home/post_model.dart';

enum HomeStatus {
  initial,
  loading,
  loaded,
  error,
}

extension HomeStatusX on HomeState {
  bool get isInitial => status == HomeStatus.initial;
  bool get isLoading => status == HomeStatus.loading;
  bool get isLoaded => status == HomeStatus.loaded;
  bool get isError => status == HomeStatus.error;
}

@immutable
class HomeState {
  final HomeStatus status;
  final List<PostModel>? posts;
  final String? errorMessage;
  final int? postIndex;

  HomeState({
    required this.status,
    this.posts,
    this.errorMessage,
    this.postIndex,
  });

  HomeState copyWith({
    HomeStatus? status,
    List<PostModel>? posts,
    String? errorMessage,
    int? postIndex,
  }) {
    return HomeState(
      status: status ?? this.status,
      posts: posts ?? this.posts,
      errorMessage: errorMessage ?? this.errorMessage,
      postIndex: postIndex ?? this.postIndex,
    );
  }

  @override
  String toString() =>
      'HomeState(status: $status, posts: $posts, errorMessage: $errorMessage, postIndex: $postIndex)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is HomeState &&
        other.status == status &&
        listEquals(other.posts, posts) &&
        other.errorMessage == errorMessage &&
        other.postIndex == postIndex;
  }

  @override
  int get hashCode =>
      status.hashCode ^
      posts.hashCode ^
      errorMessage.hashCode ^
      postIndex.hashCode;
}
