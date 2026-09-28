import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/wishlist_controller.dart';
import '../models/listing_model.dart';
import '../providers/wishlist_provider.dart';

class ListingDetailsScreen extends ConsumerWidget {
  final ListingModel listing;

  const ListingDetailsScreen({
    super.key,
    required this.listing,
  });

  static const background = Color(0xFF0F172A);
  static const card = Color(0xFF1F2937);
  static const primary = Color(0xFF38BDF8);
  static const white = Color(0xFFF8FAFC);
  static const secondary = Color(0xFF94A3B8);
  static const border = Color(0xFF334155);

  String get postedDate {
    final day = listing.createdAt.day
        .toString()
        .padLeft(2, '0');

    final monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    final month = monthNames[listing.createdAt.month - 1];

    return '$day $month ${listing.createdAt.year}';
  }

  String get phoneNumber {
    return listing.sellerPhone
        .replaceAll(' ', '')
        .replaceAll('-', '')
        .replaceAll('(', '')
        .replaceAll(')', '');
  }

  Future<void> callSeller(BuildContext context) async {
    if (phoneNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Seller phone number is not available'),
        ),
      );
      return;
    }

    final uri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );

    final launched = await launchUrl(uri);

    if (!launched && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to open phone app'),
        ),
      );
    }
  }

  Future<void> chatWithSeller(BuildContext context) async {
    if (phoneNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Seller phone number is not available'),
        ),
      );
      return;
    }

    final message = Uri.encodeComponent(
      'Hi, I am interested in your "${listing.title}" listing on CampusMart.',
    );

    final uri = Uri.parse(
      'https://wa.me/$phoneNumber?text=$message',
    );

    final launched = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );

    if (!launched && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to open WhatsApp'),
        ),
      );
    }
  }

  Future<void> toggleWishlist(
      BuildContext context,
      bool isWishlisted,
      ) async {
    try {
      if (isWishlisted) {
        await WishlistController()
            .removeFromWishlist(listing.id);
      } else {
        await WishlistController()
            .addToWishlist(listing.id);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
          ),
        );
      }
    }
  }

  @override
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ) {
    final user = FirebaseAuth.instance.currentUser;

    final wishlist = user == null
        ? null
        : ref.watch(
      wishlistProvider(user.uid),
    );

    final isWishlisted = wishlist?.maybeWhen(
      data: (items) => items.any(
            (item) => item.listingId == listing.id,
      ),
      orElse: () => false,
    ) ??
        false;

    return Scaffold(
      backgroundColor: background,

      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        title: Text(
          listing.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Share feature coming soon'),
                ),
              );
            },
            icon: const Icon(
              Icons.share_outlined,
              color: white,
            ),
          ),
        ],
      ),

      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(
              bottom: 100,
            ),
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                _imageSection(),

                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              listing.title,
                              style: const TextStyle(
                                color: white,
                                fontSize: 24,
                                fontWeight:
                                FontWeight.bold,
                                height: 1.2,
                              ),
                            ),
                          ),

                          const SizedBox(width: 12),

                          Container(
                            decoration:
                            BoxDecoration(
                              color: card,
                              borderRadius:
                              BorderRadius.circular(
                                12,
                              ),
                              border: Border.all(
                                color: border,
                              ),
                            ),
                            child: IconButton(
                              onPressed: () {
                                toggleWishlist(
                                  context,
                                  isWishlisted,
                                );
                              },
                              icon: Icon(
                                isWishlisted
                                    ? Icons.favorite
                                    : Icons
                                    .favorite_border,
                                color: isWishlisted
                                    ? Colors.redAccent
                                    : white,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      Text(
                        '₹${listing.price.toStringAsFixed(0)}',
                        style: const TextStyle(
                          color: primary,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 16),

                      Row(
                        children: [
                          const Icon(
                            Icons.access_time_outlined,
                            color: secondary,
                            size: 18,
                          ),
                          const SizedBox(width: 7),
                          const Text(
                            'Posted on ',
                            style: TextStyle(
                              color: secondary,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            postedDate,
                            style: const TextStyle(
                              color: white,
                              fontSize: 14,
                              fontWeight:
                              FontWeight.w600,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      Row(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            color: secondary,
                            size: 19,
                          ),
                          const SizedBox(width: 7),
                          Expanded(
                            child: Text(
                              listing.location.isEmpty
                                  ? 'Location not provided'
                                  : listing.location,
                              style: const TextStyle(
                                color: white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 28),

                      _sectionTitle(
                        'Description',
                      ),

                      const SizedBox(height: 12),

                      _card(
                        child: Text(
                          listing.description,
                          style: const TextStyle(
                            color: white,
                            fontSize: 15,
                            height: 1.6,
                          ),
                        ),
                      ),

                      const SizedBox(height: 28),

                      _sectionTitle(
                        'Key Highlights',
                      ),

                      const SizedBox(height: 12),

                      _highlightsCard(),

                      const SizedBox(height: 28),

                      _sectionTitle(
                        'Seller Information',
                      ),

                      const SizedBox(height: 12),

                      _sellerCard(),

                      const SizedBox(height: 28),

                      _sectionTitle(
                        'Listing Status',
                      ),

                      const SizedBox(height: 12),

                      _card(
                        child: Row(
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration:
                              BoxDecoration(
                                color: listing.status ==
                                    'approved'
                                    ? Colors.green
                                    : Colors.orange,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              listing.status
                                  .toUpperCase(),
                              style: const TextStyle(
                                color: white,
                                fontSize: 14,
                                fontWeight:
                                FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _bottomActions(context),
          ),
        ],
      ),
    );
  }

  Widget _imageSection() {
    return Container(
      width: double.infinity,
      height: 330,
      color: const Color(0xFF111827),
      child: listing.imageUrl.isNotEmpty
          ? Image.network(
        listing.imageUrl,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.contain,
        errorBuilder:
            (context, error, stackTrace) {
          return const Center(
            child: Icon(
              Icons
                  .image_not_supported_outlined,
              color: secondary,
              size: 60,
            ),
          );
        },
      )
          : const Center(
        child: Icon(
          Icons.image_outlined,
          color: secondary,
          size: 60,
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _card({
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: border,
        ),
      ),
      child: child,
    );
  }

  Widget _highlightsCard() {
    return _card(
      child: Column(
        children: [
          _highlightRow(
            Icons.category_outlined,
            'Category',
            listing.category,
          ),
          _divider(),
          _highlightRow(
            Icons.verified_outlined,
            'Condition',
            listing.condition,
          ),
          _divider(),
          _highlightRow(
            Icons.location_on_outlined,
            'Location',
            listing.location.isEmpty
                ? 'Not provided'
                : listing.location,
          ),
          _divider(),
          _highlightRow(
            Icons.person_outline,
            'Seller',
            listing.sellerName.isEmpty
                ? 'Campus User'
                : listing.sellerName,
          ),
        ],
      ),
    );
  }

  Widget _highlightRow(
      IconData icon,
      String title,
      String value,
      ) {
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: primary.withValues(
              alpha: 0.10,
            ),
            borderRadius:
            BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: primary,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: secondary,
              fontSize: 14,
            ),
          ),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _divider() {
    return const Padding(
      padding: EdgeInsets.symmetric(
        vertical: 14,
      ),
      child: Divider(
        color: border,
        height: 1,
      ),
    );
  }

  Widget _sellerCard() {
    return _card(
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
              color: primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person,
              color: background,
              size: 28,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  listing.sellerName.isEmpty
                      ? 'Campus User'
                      : listing.sellerName,
                  style: const TextStyle(
                    color: white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  listing.sellerPhone.isEmpty
                      ? 'Phone number not provided'
                      : listing.sellerPhone,
                  style: const TextStyle(
                    color: secondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomActions(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          16,
          12,
          16,
          12,
        ),
        decoration: BoxDecoration(
          color: background,
          border: const Border(
            top: BorderSide(
              color: border,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(
                alpha: 0.25,
              ),
              blurRadius: 12,
              offset: const Offset(
                0,
                -4,
              ),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  chatWithSeller(context);
                },
                icon: const Icon(
                  Icons.chat_bubble_outline,
                ),
                label: const Text('Chat'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: primary,
                  side: const BorderSide(
                    color: primary,
                    width: 1.5,
                  ),
                  minimumSize:
                  const Size.fromHeight(52),
                  shape:
                  RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  callSeller(context);
                },
                icon: const Icon(
                  Icons.phone_outlined,
                ),
                label: const Text('Call'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  foregroundColor: background,
                  minimumSize:
                  const Size.fromHeight(52),
                  shape:
                  RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}