import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AppSidebar extends StatelessWidget {
  final String activeItem;
  final String userName;
  final String userEmail;
  final String tenantName;
  final Function(String) onItemTap;
  final VoidCallback onLogout;

  const AppSidebar({
    super.key,
    required this.activeItem,
    required this.userName,
    required this.userEmail,
    required this.tenantName,
    required this.onItemTap,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          // Header Section
          _buildHeader(context),
          
          // Menu Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                _buildMenuItem(
                  icon: Icons.grid_view_rounded,
                  title: 'Dashboard',
                  id: 'Dashboard',
                ),
                _buildMenuItem(
                  icon: Icons.store_rounded,
                  title: 'Outlets',
                  id: 'Users', // Using 'Users' since the home screen uses this ID
                ),
                _buildMenuItem(
                  icon: Icons.account_balance_wallet_rounded,
                  title: 'Ledgers',
                  id: 'Ledger',
                ),
                _buildMenuItem(
                  icon: Icons.shopping_cart_rounded,
                  title: 'Orders',
                  id: 'Orders',
                ),
                _buildMenuItem(
                  icon: Icons.inventory_2_rounded,
                  title: 'Products',
                  id: 'Products',
                ),
                _buildMenuItem(
                  icon: Icons.receipt_long_rounded,
                  title: 'Invoices',
                  id: 'Invoice',
                ),
                _buildMenuItem(
                  icon: Icons.payments_rounded,
                  title: 'Payments',
                  id: 'Payments',
                ),
                const Divider(height: 32),
                _buildMenuItem(
                  icon: Icons.settings_rounded,
                  title: 'Settings',
                  id: 'Settings',
                ),
              ],
            ),
          ),
          
          // Footer / Logout
          _buildLogoutButton(),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 24,
        bottom: 24,
        left: 20,
        right: 20,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF7C3AED),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // White Logo Placeholder
          Container(
            width: 120,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            tenantName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            userName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            userEmail,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String id,
  }) {
    final bool isActive = activeItem == id;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: ListTile(
        onTap: () => onItemTap(id),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        leading: Icon(
          icon,
          size: 24,
          color: isActive ? const Color(0xFF7C3AED) : Colors.grey.shade600,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isActive ? const Color(0xFF7C3AED) : Colors.grey.shade800,
            fontSize: 16,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
        selected: isActive,
        selectedTileColor: const Color(0xFF7C3AED).withOpacity(0.1),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: ListTile(
        onTap: onLogout,
        leading: const Icon(
          Icons.logout_rounded,
          color: Color(0xFFEF4444),
          size: 24,
        ),
        title: const Text(
          'Logout',
          style: TextStyle(
            color: Color(0xFFEF4444),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
