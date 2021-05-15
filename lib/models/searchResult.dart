import 'package:weasel_social_media_app/models/post_info.dart';
import 'package:weasel_social_media_app/models/userclass.dart';

class UserSearchResult {
  final List<UserClass> resultList;

  const UserSearchResult({
    this.resultList,
  });
}

class PostSearchResult {
  final List<PostInfo> postList;

  const PostSearchResult({
    this.postList,
  });
}
