import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/wishlist_model.dart';

class WishlistService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  Future<void> addToWishlist(WishlistModel wishlist) {
    return _firestore
        .collection('wishlists')
        .doc(wishlist.id)
        .set(wishlist.toMap());
  }

  Future<void> removeFromWishlist(String wishlistId) {
    return _firestore
        .collection('wishlists')
        .doc(wishlistId)
        .delete();
  }

  Stream<List<WishlistModel>> getWishlist(String userId) {
    return _firestore
        .collection('wishlists')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
          .map(
            (doc) => WishlistModel.fromMap(
          doc.id,
          doc.data(),
        ),
      )
          .toList(),
    );
  }
}