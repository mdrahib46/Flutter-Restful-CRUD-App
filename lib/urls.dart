
class Urls {
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';

  static const getPost = '$_baseUrl/posts';
  static String getSinglePost(String id) => '$_baseUrl/posts/$id';
  static const createPost = '$_baseUrl/posts';
  static String updatePost(String id) => '$_baseUrl/posts/$id';
  static String deletePost(String id) => '$_baseUrl/posts/$id';
}