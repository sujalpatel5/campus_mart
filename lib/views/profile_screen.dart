import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'admin_dashboard_screen.dart';
import 'my_listings_screen.dart';
import 'wishlist_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const background = Color(0xFF0F172A);
  static const card = Color(0xFF1F2937);
  static const primary = Color(0xFF38BDF8);
  static const white = Color(0xFFF8FAFC);
  static const secondary = Color(0xFF94A3B8);
  static const border = Color(0xFF334155);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    final name = user?.displayName?.isNotEmpty == true
        ? user!.displayName!
        : user?.email?.split('@').first ?? 'Campus User';

    final email = user?.email ?? '';

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        title: const Text(
          'Profile',
          style: TextStyle(
            color: white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: user == null
            ? null
            : FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          String role = 'user';

          if (snapshot.hasData && snapshot.data!.exists) {
            final data =
            snapshot.data!.data() as Map<String, dynamic>;

            role = data['role'] ?? 'user';
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              20,
              10,
              20,
              30,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _profileHeader(
                  context,
                  name,
                  email,
                ),

                const SizedBox(height: 28),

                _sectionTitle('ACCOUNT'),

                const SizedBox(height: 12),

                _menuCard(
                  children: [
                    _menuItem(
                      icon: Icons.favorite_border,
                      title: 'Wishlist',
                      subtitle: 'Your saved listings',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                            const WishlistScreen(),
                          ),
                        );
                      },
                    ),
                    _divider(),
                    _menuItem(
                      icon: Icons.inventory_2_outlined,
                      title: 'My Listings',
                      subtitle: 'Manage your listings',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                            const MyListingsScreen(),
                          ),
                        );
                      },
                    ),
                    _divider(),
                    _menuItem(
                      icon: Icons.history,
                      title: 'Recently Viewed',
                      subtitle: 'Listings you recently viewed',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Recently Viewed coming soon',
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                _sectionTitle('MORE'),

                const SizedBox(height: 12),

                _menuCard(
                  children: [
                    _menuItem(
                      icon: Icons.settings_outlined,
                      title: 'Settings',
                      subtitle: 'Account and app settings',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Settings coming soon',
                            ),
                          ),
                        );
                      },
                    ),
                    _divider(),
                    _menuItem(
                      icon: Icons.help_outline,
                      title: 'Help & Support',
                      subtitle: 'Get help with CampusMart',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Help & Support coming soon',
                            ),
                          ),
                        );
                      },
                    ),
                    _divider(),
                    _menuItem(
                      icon: Icons.info_outline,
                      title: 'About CampusMart',
                      subtitle:
                      'Buy. Sell. Connect. On Campus.',
                      onTap: () {
                        showAboutDialog(
                          context: context,
                          applicationName: 'CampusMart',
                          applicationVersion: '1.0.0',
                          applicationLegalese:
                          'Buy. Sell. Connect. On Campus.',
                        );
                      },
                    ),
                  ],
                ),

                if (role == 'admin') ...[
                  const SizedBox(height: 28),

                  _sectionTitle('ADMIN'),

                  const SizedBox(height: 12),

                  _menuCard(
                    children: [
                      _menuItem(
                        icon:
                        Icons.admin_panel_settings_outlined,
                        title: 'Admin Dashboard',
                        subtitle:
                        'Manage and approve listings',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                              const AdminDashboardScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],

                const SizedBox(height: 28),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                    },
                    icon: const Icon(
                      Icons.logout,
                      color: Colors.redAccent,
                    ),
                    label: const Text(
                      'Logout',
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      minimumSize:
                      const Size.fromHeight(52),
                      side: const BorderSide(
                        color: Colors.redAccent,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _profileHeader(
      BuildContext context,
      String name,
      String email,
      ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: border,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 34,
                backgroundColor: primary,
                child: Text(
                  name.isNotEmpty
                      ? name[0].toUpperCase()
                      : 'C',
                  style: const TextStyle(
                    color: background,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      email,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: secondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              IconButton(
                onPressed: () {
                  _showEditProfileDialog(
                    context,
                    name,
                  );
                },
                icon: const Icon(
                  Icons.edit_outlined,
                  color: primary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                _showEditProfileDialog(
                  context,
                  name,
                );
              },
              icon: const Icon(
                Icons.edit_outlined,
                size: 18,
              ),
              label: const Text(
                'Edit Profile',
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: primary,
                side: const BorderSide(
                  color: primary,
                ),
                minimumSize:
                const Size.fromHeight(46),
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditProfileDialog(
      BuildContext context,
      String currentName,
      ) {
    final controller = TextEditingController(
      text: currentName,
    );

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: card,
          title: const Text(
            'Edit Profile',
            style: TextStyle(
              color: white,
            ),
          ),
          content: TextField(
            controller: controller,
            style: const TextStyle(
              color: white,
            ),
            decoration: InputDecoration(
              labelText: 'Name',
              labelStyle: const TextStyle(
                color: secondary,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: border,
                ),
                borderRadius:
                BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: primary,
                ),
                borderRadius:
                BorderRadius.circular(12),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: secondary,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final newName =
                controller.text.trim();

                if (newName.isEmpty) {
                  return;
                }

                final user =
                    FirebaseAuth.instance.currentUser;

                if (user == null) {
                  return;
                }

                try {
                  await user.updateDisplayName(
                    newName,
                  );

                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(user.uid)
                      .update({
                    'name': newName,
                  });

                  if (dialogContext.mounted) {
                    Navigator.pop(dialogContext);
                  }

                  if (context.mounted) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Profile updated',
                        ),
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(
                      SnackBar(
                        content: Text(
                          e.toString(),
                        ),
                      ),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                foregroundColor: background,
              ),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: secondary,
        fontSize: 13,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _menuCard({
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: border,
        ),
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _menuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 15,
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: primary.withValues(
                  alpha: 0.10,
                ),
                borderRadius:
                BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: primary,
                size: 22,
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: secondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.chevron_right,
              color: secondary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _divider() {
    return const Divider(
      color: border,
      height: 1,
      indent: 72,
      endIndent: 16,
    );
  }
}