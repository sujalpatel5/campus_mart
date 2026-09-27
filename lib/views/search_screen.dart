import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/listing_provider.dart';
import 'listing_details_screen.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final listings = ref.watch(listingsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        title: const Text('Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              onChanged: (_) {
                setState(() {});
              },
              decoration: const InputDecoration(
                labelText: 'Search listings',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: listings.when(
                data: (items) {
                  final searchText =
                  searchController.text.toLowerCase();

                  final filteredItems = items.where((listing) {
                    return listing.title
                        .toLowerCase()
                        .contains(searchText);
                  }).toList();

                  if (filteredItems.isEmpty) {
                    return const Center(
                      child: Text(
                        'No listings found',
                        style: TextStyle(
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      final listing = filteredItems[index];

                      return Card(
                        color: const Color(0xFF1F2937),
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    ListingDetailsScreen(
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}