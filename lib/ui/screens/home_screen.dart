import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import 'package:go_router/go_router.dart';
import '../../core/app_theme.dart';

import '../widgets/custom_app_bar.dart';
import '../widgets/app_drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB), // Very light grey/off-white background
      appBar: const CustomAppBar(title: 'Home', showBackButton: false),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Welcome Back', style: TextStyle(fontSize: 16, color: AppTheme.secondaryBlue, fontWeight: FontWeight.w400)),
            const SizedBox(height: 4),
            // Displaying actual logged-in user email
            Text(Provider.of<AuthProvider>(context).email ?? 'User', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF101828))),
            const SizedBox(height: 32),
            
            // Grid for Top 4 Items
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.05,
              children: [
                _buildCard(context, 'Product', 'assets/images/products.png', '/products'),
                _buildCard(context, 'Industry', 'assets/images/industry.png', '/industry'),
                _buildCard(context, 'Drive Selection\nTools', 'assets/images/driverselection.png', '/drive_selection'),
                _buildCard(context, 'Tech\nSupport', 'assets/images/techSupport.png', '/tech_support'),
              ],
            ),
            const SizedBox(height: 16),
            
            // Full width bottom card
            _buildWideCard(context, 'Commissioning Support', 'assets/images/comission.png', '/commissioning'),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, String title, String imagePath, String route) {
    return InkWell(
      onTap: () {
        if (route.isNotEmpty) context.push(route);
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ]
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.transparent, // They seem to just be icons in the mockup
                borderRadius: BorderRadius.circular(12),
              ),
              child: Image.asset(imagePath, height: 40, width: 40, fit: BoxFit.contain),
            ),
            const SizedBox(height: 12),
            Text(
              title, 
              textAlign: TextAlign.center, 
              style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF1F2937), fontSize: 13, height: 1.2),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWideCard(BuildContext context, String title, String imagePath, String route) {
    return InkWell(
      onTap: () {
        if (route.isNotEmpty) context.push(route);
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 24.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ]
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imagePath, height: 40, width: 40, fit: BoxFit.contain),
            const SizedBox(height: 16),
            Text(
              title, 
              style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF1F2937), fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
