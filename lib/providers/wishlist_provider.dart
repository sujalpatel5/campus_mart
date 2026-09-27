import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/wishlist_model.dart';
import '../services/wishlist_service.dart';

final wishlistServiceProvider = Provider<WishlistService>((ref) {
  return WishlistService();
});

final wishlistProvider =
StreamProvider.family<List<WishlistModel>, String>((ref, userId) {
  return ref
      .watch(wishlistServiceProvider)
      .getWishlist(userId);
});