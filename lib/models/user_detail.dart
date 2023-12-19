import 'package:cloud_firestore/cloud_firestore.dart';

class UserDetail {
  final String id;
  final String username;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String profilePicURL;
  final userCollection = FirebaseFirestore.instance.collection('users');
  final saldoCollection = FirebaseFirestore.instance.collection('saldo');

  UserDetail({
    required this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.profilePicURL,
  });

  factory UserDetail.fromJson(Map<String, dynamic> json) {
    return UserDetail(
      id: json['id'],
      username: json['username'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      profilePicURL: json['profilePicURL'],
    );
  }

  factory UserDetail.fromSnapshot(DocumentSnapshot doc) {
    return UserDetail(
      id: doc.id,
      username: doc['username'],
      firstName: doc['firstName'],
      lastName: doc['lastName'],
      email: doc['email'],
      phoneNumber: doc['phoneNumber'],
      profilePicURL: doc['profilePicURL'],
    );
  }

  Future<void> addNewUser(UserDetail user) async {
    await userCollection.add({
      'username': user.username,
      'firstName': user.firstName,
      'lastName': user.lastName,
      'email': user.email,
      'phoneNumber': user.phoneNumber,
      'profilePicURL': user.profilePicURL,
    });
    await saldoCollection.add({
      'amount': 0,
      'user': user.email,
    });
  }

  // get user by email
  static Future<UserDetail> getUserByEmail(String email) async {
    final user = await FirebaseFirestore.instance.collection('users').where('email', isEqualTo: email).get();
    final userDetail = user.docs.first;
    return UserDetail.fromSnapshot(userDetail);
  }

}
