import 'package:flutter/material.dart';
import '../../core/app_theme.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/app_drawer.dart';

class TechSupportScreen extends StatefulWidget {
  const TechSupportScreen({super.key});

  @override
  State<TechSupportScreen> createState() => _TechSupportScreenState();
}

class _TechSupportScreenState extends State<TechSupportScreen> {
  bool _isAcDrive = true;
  bool _isDcDrive = false;

  void _selectAcDrive(bool? value) {
    setState(() {
      _isAcDrive = value ?? false;
      if (_isAcDrive) _isDcDrive = false;
    });
  }

  void _selectDcDrive(bool? value) {
    setState(() {
      _isDcDrive = value ?? false;
      if (_isDcDrive) _isAcDrive = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: const CustomAppBar(title: 'Tech Support'),
      drawer: const AppDrawer(),

      /// BODY
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [

            /// DOWNLOAD BUTTON
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppTheme.borderInactive),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(AppTheme.cornerRadius),
                  ),
                  foregroundColor: AppTheme.textPrimary,
                  backgroundColor: AppTheme.surfaceWhite,
                ),
                child: const Text(
                  'Download Manual & Catalog',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// REAL TIME SUPPORT CARD
            Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const Text(
                      'Real-Time Diagnostic Support',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),

                    const SizedBox(height: 16),

                    /// DRIVE TYPE
                    Row(
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: _isAcDrive,
                              onChanged: _selectAcDrive,
                            ),
                            const Text('AC Drive'),
                          ],
                        ),
                        const SizedBox(width: 16),
                        Row(
                          children: [
                            Checkbox(
                              value: _isDcDrive,
                              onChanged: _selectDcDrive,
                            ),
                            const Text('DC Drive'),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    /// COMPARE DROPDOWN
                    DropdownMenu<String>(
                      expandedInsets: EdgeInsets.zero,
                      label: const Text('Compare selection'),
                      dropdownMenuEntries: const [],
                      onSelected: (_) {},
                    ),

                    const SizedBox(height: 12),

                    /// SERIES DROPDOWN
                    DropdownMenu<String>(
                      expandedInsets: EdgeInsets.zero,
                      label: const Text('Series selection'),
                      dropdownMenuEntries: const [],
                      onSelected: (_) {},
                    ),

                    const SizedBox(height: 12),

                    /// FAULT CODE
                    const TextField(
                      decoration: InputDecoration(
                        labelText: 'Fault Code',
                      ),
                    ),

                    const SizedBox(height: 12),

                    /// ALARM CODE
                    const TextField(
                      decoration: InputDecoration(
                        labelText: 'Alarm Code',
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// INTELLIFY INPUT CARD
            Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 18),
                child: Text(
                  'Addition input from IntellifyWORX',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),

      /// BOTTOM SUPPORT BUTTON
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            height: 50,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Connect with support guy'),
                  const SizedBox(width: 10),
                  Image.asset(
                    'assets/images/tech-support-white.png',
                    height: 20,
                    width: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}