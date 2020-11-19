import 'package:blog_api/repository/repository.dart';

class PostService {
  Repository _repository;
  PostService() {
    _repository = Repository();
  }
  getAllPosts() async {
    return await _repository.httpGet('get-posts');
  }
}
