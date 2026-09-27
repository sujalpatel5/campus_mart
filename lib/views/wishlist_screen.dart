import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/listing_provider.dart';
import '../providers/wishlist_provider.dart';
import 'listing_details_screen.dart';

class WishlistScreen extends ConsumerWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        backgroundColor: Color(0xFF0F172A),
        body: Center(
          child: Text(
            'Please login first',
            style: TextStyle(
              color: Color(0xFFF8FAFC),
            ),
          ),
        ),
      );
    }

    final wishlist = ref.watch(wishlistProvider(user.uid));
    final listings = ref.watch(listingsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        title: const Text('Wishlist'),
      ),
      body: wishlist.when(
        data: (wishlistItems) {
          if (wishlistItems.isEmpty) {
            return const Center(
              child: Text(
                'Your wishlist is empty',
                style: TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 16,
                ),
              ),
            );
          }

          return listings.when(
            data: (items) {
              final wishlistListings = items.where((listing) {
                return wishlistItems.any(
                      (item) => item.listingId == listing.id,
                );
              }).toList();

              if (wishlistListings.isEmpty) {
                return const Center(
                  child: Text(
                    'No wishlist listings available',
                    style: TextStyle(
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(24),
                itemCount: wishlistListings.length,
                itemBuilder: (context, index) {
                  final listing = wishlistListings[index];

                  return Card(
                    color: const Color(0xFF1F2937),
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ListingDetailsScreen(
                              listing: listing,
                            ),
                          ),
                        );
                      },
                      title: Text(
                        listing.title,
                        style: const TextStyle(
                          color: Color(0xFFF8FAFC),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        listing.category,
                        style: const TextStyle(
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                      trailing: Text(
                        '₹${listing.price.toStringAsFixed(0)}',
                        style: const TextStyle(
                          color: Color(0xFF38BDF8),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF38BDF8),
              ),
            ),
            error: (error, stack) => Center(
              child: Text(
                error.toString(),
                style: const TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(
            color: Color(0xFF38BDF8),
          ),
        ),
        error: (error, stack) => Center(
          child: Text(
            error.toString(),
            style: const TextStyle(
              color: Colors.red,
            ),
          ),
        ),
      ),
    );
  }
}