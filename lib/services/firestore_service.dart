import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/listing_model.dart';
import '../models/user_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  Future<void> createUser(UserModel user) {
    return _firestore
        .collection('users')
        .doc(user.id)
        .set(user.toMap());
  }

  Future<void> createListing(ListingModel listing) {
    return _firestore
        .collection('listings')
        .doc(listing.id)
        .set(listing.toMap());
  }

  Stream<List<ListingModel>> getApprovedListings() {
    return _firestore
        .collection('listings')
        .where('status', isEqualTo: 'approved')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
          .map(
            (doc) => ListingModel.fromMap(
          doc.id,
          doc.data(),
        ),
      )
          .toList(),
    );
  }

  Stream<List<ListingModel>> getPendingListings() {
    return _firestore
        .collection('listings')
        .where('status', isEqualTo: 'pending')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
          .map(
            (doc) => ListingModel.fromMap(
          doc.id,
          doc.data(),
        ),
      )
          .toList(),
    );
  }

  Stream<List<ListingModel>> getMyListings(String sellerId) {
    return _firestore
        .collection('listings')
        .where('sellerId', isEqualTo: sellerId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
          .map(
            (doc) => ListingModel.fromMap(
          doc.id,
          doc.data(),
        ),
      )
          .toList(),
    );
  }

  Future<void> updateListingStatus(
      String listingId,
      String status,
      ) {
    return _firestore
        .collection('listings')
        .doc(listingId)
        .update({
      'status': status,
    });
  }

  Future<void> updateListing(ListingModel listing) {
    return _firestore
        .collection('listings')
        .doc(listing.id)
        .update(listing.toMap());
  }

  Future<void> deleteListing(String listingId) {
    return _firestore
        .collection('listings')
        .doc(listingId)
        .delete();
  }
}