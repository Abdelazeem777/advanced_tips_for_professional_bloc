import 'package:bloc_example/features/Home/post_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState(status: HomeStatus.initial));

  Future<void> getPosts() async {
    emit(state.copyWith(status: HomeStatus.loading));
    try {
      final dio = Dio();
      final response =
          await dio.get('https://jsonplaceholder.typicode.com/posts');
      final posts =
          (response.data as List).map((map) => PostModel.fromMap(map)).toList();

      emit(state.copyWith(
        status: HomeStatus.loaded,
        posts: posts,
      ));
    } catch (e) {
      emit(
        state.copyWith(
          status: HomeStatus.error,
          errorMessage: 'Connection error',
        ),
      );
    }
  }

  Future<void> getPost(int index) async {
    final post = state.posts![index];

    await Future.delayed(const Duration(seconds: 1));

    emit(state.copyWith(postIndex: index));
  }

  void removePost(int index) {
    var newPosts = [...state.posts!];
    newPosts.removeAt(index);

    emit(state.copyWith(posts: newPosts));
  }
}
