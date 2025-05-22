import 'package:delivery_app/constants/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomDrawer extends StatefulWidget {
  final VoidCallback onClose;

  const CustomDrawer({super.key, required this.onClose});

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  int _selectedIndex = 0; // Default selected item index

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildDrawerItem(IconData icon, String title, int index, {Color color = Colors.black}) {
    bool isSelected = _selectedIndex == index;
    bool isLogout = index == 9; // Check if the item is "Log out"
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20, right: 20),
        child: Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: isLogout ? Colors.red : (isSelected ? MyColors.primaryColor : Colors.white), // Change color based on selection and if it's "Log out"
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(icon, size: 25, color: isLogout ? Colors.white : (isSelected ? Colors.white : color)), // Change icon color based on selection and if it's "Log out"
              const SizedBox(width: 40),
              Text(
                title,
                style: GoogleFonts.nunitoSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isLogout ? Colors.white : (isSelected ? Colors.white : color), // Change text color based on selection and if it's "Log out"
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        width: 250,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.horizontal(right: Radius.circular(20)),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 50, left: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: widget.onClose,
                    child: Icon(Icons.arrow_back_ios_new_outlined, size: 25),
                  ),
                  const SizedBox(width: 40),
                  Text(
                    "MENU",
                    style: GoogleFonts.nunitoSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              _buildDrawerItem(Icons.home, "Home", 0),
              _buildDrawerItem(Icons.store, "Shops", 1),
              _buildDrawerItem(Icons.category, "Categories", 2),
              _buildDrawerItem(Icons.shopping_cart, "My Orders", 3),
              _buildDrawerItem(Icons.shopping_basket, "My Basket", 4),
              Spacer(),
              _buildDrawerItem(Icons.person, "Profile", 5),
              _buildDrawerItem(Icons.settings, "Settings", 6),
              _buildDrawerItem(Icons.info, "About us", 7),
              _buildDrawerItem(Icons.help, "Help", 8),
              const SizedBox(height: 20),

              _buildDrawerItem(Icons.logout, "Log out", 9, color: Colors.red),
            ],
          ),
        ),
      ),
    );
  }
}