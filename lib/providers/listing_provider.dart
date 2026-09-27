import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/listing_model.dart';
import '../services/firestore_service.dart';

final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  return FirestoreService();
});

final listingsProvider = StreamProvider<List<ListingModel>>((ref) {
  return ref
      .watch(firestoreServiceProvider)
      .getApprovedListings();
});