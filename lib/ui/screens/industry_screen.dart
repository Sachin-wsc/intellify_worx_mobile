import 'package:flutter/material.dart';
import '../../core/app_theme.dart';
import '../../models/company.dart';
import '../../services/master_service.dart';

import '../widgets/custom_app_bar.dart';
import '../widgets/app_drawer.dart';

class IndustryScreen extends StatefulWidget {
  const IndustryScreen({super.key});

  @override
  State<IndustryScreen> createState() => _IndustryScreenState();
}

class _IndustryScreenState extends State<IndustryScreen> {
  final MasterService _masterService = MasterService();
  late Future<List<Company>> _companiesFuture;

  @override
  void initState() {
    super.initState();
    _companiesFuture = _masterService.getCompanies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: const CustomAppBar(title: 'Industry'),
      drawer: const AppDrawer(),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search',
                hintStyle: TextStyle(color: Color(0xFF9CA3AF), fontSize: 16),
                prefixIcon: Icon(Icons.search, color: Color(0xFF9CA3AF)),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 14),
              ),
              onChanged: (value) {
                // Implement local search on companies if needed
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Company>>(
              future: _companiesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.red)));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No Industries found', style: TextStyle(color: AppTheme.textSecondary)));
                }

                final companies = snapshot.data!;
                return ListView.builder(
                  itemCount: companies.length,
                  itemBuilder: (context, index) {
                    final company = companies[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x08000000), // very subtle shadow
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          )
                        ]
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        leading: Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                            color: Color(0xFFF0F5F9), // light subtle blue/grey
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              company.name.isNotEmpty ? company.name[0].toUpperCase() : '?',
                              style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF0F3B5D), fontSize: 20),
                            ),
                          ),
                        ),
                        title: Text(
                          company.name,
                          style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF1F2937), fontSize: 16),
                        ),
                        trailing: const Icon(Icons.chevron_right, color: Color(0xFF9CA3AF)),
                        onTap: () {
                          // Navigate to products filtered by company/industry
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
