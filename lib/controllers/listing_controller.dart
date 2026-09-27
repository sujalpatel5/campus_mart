import 'package:firebase_auth/firebase_auth.dart';

import '../models/listing_model.dart';
import '../services/firestore_service.dart';

class ListingController {
  final FirestoreService _firestoreService =
  FirestoreService();

  Future<void> createListing({
    required String title,
    required String description,
    required double price,
    required String category,
    required String condition,
    required String imageUrl,
  }) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception('User is not logged in');
    }

    final listing = ListingModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      price: price,
      category: category,
      condition: condition,
      imageUrl: imageUrl,
      sellerId: user.uid,
      createdAt: DateTime.now(),
      status: 'pending',
    );

    await _firestoreService.createListing(listing);
  }
}