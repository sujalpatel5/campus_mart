import 'package:firebase_auth/firebase_auth.dart';

import '../models/wishlist_model.dart';
import '../services/wishlist_service.dart';

class WishlistController {
  final WishlistService _wishlistService = WishlistService();

  Future<void> addToWishlist(String listingId) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception('User is not logged in');
    }

    final wishlist = WishlistModel(
      id: '${user.uid}_$listingId',
      userId: user.uid,
      listingId: listingId,
      createdAt: DateTime.now(),
    );

    await _wishlistService.addToWishlist(wishlist);
  }

  Future<void> removeFromWishlist(String listingId) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception('User is not logged in');
    }

    await _wishlistService.removeFromWishlist(
      '${user.uid}_$listingId',
    );
  }
}