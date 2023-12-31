import 'package:cloud_firestore/cloud_firestore.dart';

class ActionImage {
  final String id;
  final String imageURL;
  final String idAction;
  final String user;
  final actionImageCollection =
      FirebaseFirestore.instance.collection('action_images');

  ActionImage({
    required this.id,
    required this.imageURL,
    required this.idAction,
    required this.user,
  });

  factory ActionImage.fromJson(Map<String, dynamic> json) {
    return ActionImage(
      id: '',
      imageURL: json['imageURL'],
      idAction: json['idAction'],
      user: '',
    );
  }

  factory ActionImage.fromSnapshot(DocumentSnapshot doc) {
    return ActionImage(
      id: doc.id,
      imageURL: doc['imageURL'],
      idAction: doc['idAction'],
      user: doc['user'],
    );
  }

  Future<void> addNewActionImage(ActionImage newActionImage) async {
    await actionImageCollection.add({
      'imageURL': newActionImage.imageURL,
      'idAction': newActionImage.idAction,
      'user': newActionImage.user,
    });
  }
}
