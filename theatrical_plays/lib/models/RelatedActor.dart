import 'package:theatrical_plays/models/Actor.dart';

class RelatedActor extends Actor {
  String? role;

  RelatedActor(this.role, String image, int id, String fullName)
      : super(image, id, fullName);
}
