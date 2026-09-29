import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/listing_provider.dart';
import 'create_listing_screen.dart';
import 'listing_details_screen.dart';
import 'my_listings_screen.dart';
import 'profile_screen.dart';
import 'search_screen.dart';
import 'wishlist_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      _homeContent(),
      const WishlistScreen(),
      const MyListingsScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: screens[selectedIndex],
      bottomNavigationBar: _bottomNavigationBar(),
    );
  }

  Widget _bottomNavigationBar() {
    return Container(
      height: 78,
      decoration: const BoxDecoration(
        color: Color(0xFF1F2937),
        border: Border(
          top: BorderSide(
            color: Color(0xFF334155),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          _bottomItem(
            icon: Icons.home_outlined,
            activeIcon: Icons.home,
            label: 'Home',
            index: 0,
          ),
          _bottomItem(
            icon: Icons.favorite_border,
            activeIcon: Icons.favorite,
            label: 'Wishlist',
            index: 1,
          ),
          _sellItem(),
          _bottomItem(
            icon: Icons.inventory_2_outlined,
            activeIcon: Icons.inventory_2,
            label: 'My Listings',
            index: 2,
          ),
          _bottomItem(
            icon: Icons.person_outline,
            activeIcon: Icons.person,
            label: 'Profile',
            index: 3,
          ),
        ],
      ),
    );
  }

  Widget _bottomItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
  }) {
    final isSelected = selectedIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedIndex = index;
          });
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              size: 23,
              color: isSelected
                  ? const Color(0xFF38BDF8)
                  : const Color(0xFF94A3B8),
            ),
            const SizedBox(height: 5),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? const Color(0xFF38BDF8)
                    : const Color(0xFF94A3B8),
                fontSize: 11,
                fontWeight: isSelected
                    ? FontWeight.w600
                    : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sellItem() {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CreateListingScreen(),
            ),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Transform.translate(
              offset: const Offset(0, -5),
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF38BDF8),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF38BDF8)
                          .withValues(alpha: 0.25),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.add,
                  color: Color(0xFF0F172A),
                  size: 28,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _homeContent() {
    final listings = ref.watch(listingsProvider);
    final selectedCategory =
    ref.watch(selectedCategoryProvider);

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                20,
                20,
                20,
                0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'CampusMart',
                    style: TextStyle(
                      color: Color(0xFFF8FAFC),
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 18),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SearchScreen(),
                        ),
                      );
                    },
                    child: Container(
                      height: 52,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1F2937),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: const Color(0xFF334155),
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.search,
                            color: Color(0xFF94A3B8),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Search books, electronics, furniture...',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Color(0xFF94A3B8),
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    'Categories',
                    style: TextStyle(
                      color: Color(0xFFF8FAFC),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    height: 95,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _categoryItem(
                          'All',
                          Icons.apps,
                          selectedCategory,
                        ),
                        _categoryItem(
                          'Books & Notes',
                          Icons.menu_book,
                          selectedCategory,
                        ),
                        _categoryItem(
                          'Electronics',
                          Icons.devices,
                          selectedCategory,
                        ),
                        _categoryItem(
                          'Furniture',
                          Icons.chair,
                          selectedCategory,
                        ),
                        _categoryItem(
                          'Clothing',
                          Icons.checkroom,
                          selectedCategory,
                        ),
                        _categoryItem(
                          'Bikes & Cycles',
                          Icons.pedal_bike,
                          selectedCategory,
                        ),
                        _categoryItem(
                          'Sports & Fitness',
                          Icons.sports_soccer,
                          selectedCategory,
                        ),
                        _categoryItem(
                          'Stationery',
                          Icons.edit_note,
                          selectedCategory,
                        ),
                        _categoryItem(
                          'Other',
                          Icons.category_outlined,
                          selectedCategory,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    'Fresh Recommendations',
                    style: TextStyle(
                      color: Color(0xFFF8FAFC),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 14),
                ],
              ),
            ),
          ),
          listings.when(
            data: (items) {
              final filteredItems =
              selectedCategory == 'All'
                  ? items
                  : items
                  .where(
                    (item) =>
                item.category.toLowerCase() ==
                    selectedCategory.toLowerCase(),
              )
                  .toList();

              if (filteredItems.isEmpty) {
                return const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(40),
                    child: Center(
                      child: Text(
                        'No listings available',
                        style: TextStyle(
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                    ),
                  ),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  0,
                  20,
                  100,
                ),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      final listing = filteredItems[index];

                      return _listingCard(listing);
                    },
                    childCount: filteredItems.length,
                  ),
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.72,
                  ),
                ),
              );
            },
            loading: () => const SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF38BDF8),
                ),
              ),
            ),
            error: (error, stack) => SliverFillRemaining(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    error.toString(),
                    style: const TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _categoryItem(
      String category,
      IconData icon,
      String selectedCategory,
      ) {
    final isSelected = category == selectedCategory;

    return GestureDetector(
      onTap: () {
        ref
            .read(selectedCategoryProvider.notifier)
            .selectCategory(category);
      },
      child: Container(
        width: 95,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF38BDF8)
                    : const Color(0xFF1F2937),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF38BDF8)
                      : const Color(0xFF334155),
                ),
              ),
              child: Icon(
                icon,
                color: isSelected
                    ? const Color(0xFF0F172A)
                    : const Color(0xFF38BDF8),
                size: 28,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              category,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: isSelected
                    ? const Color(0xFF38BDF8)
                    : const Color(0xFF94A3B8),
                fontSize: 12,
                fontWeight: isSelected
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _listingCard(dynamic listing) {
    return GestureDetector(
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
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1F2937),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF334155),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: listing.imageUrl.isNotEmpty
                    ? Container(
                  width: double.infinity,
                  color: const Color(0xFF111827),
                  child: Image.network(
                    listing.imageUrl,
                    width: double.infinity,
                    fit: BoxFit.contain,
                    errorBuilder: (
                        context,
                        error,
                        stackTrace,
                        ) {
                      return const Center(
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          color: Color(0xFF94A3B8),
                          size: 40,
                        ),
                      );
                    },
                  ),
                )
                    : Container(
                  width: double.infinity,
                  color: const Color(0xFF111827),
                  child: const Center(
                    child: Icon(
                      Icons.image_outlined,
                      color: Color(0xFF94A3B8),
                      size: 40,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    listing.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFFF8FAFC),
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '₹${listing.price.toStringAsFixed(0)}',
                    style: const TextStyle(
                      color: Color(0xFF38BDF8),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    listing.category,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF94A3B8),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}