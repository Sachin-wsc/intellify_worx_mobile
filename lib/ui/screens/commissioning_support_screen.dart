import 'package:flutter/material.dart';
import '../../core/app_theme.dart';

import '../widgets/custom_app_bar.dart';
import '../widgets/app_drawer.dart';

class CommissioningSupportScreen extends StatefulWidget {
  const CommissioningSupportScreen({super.key});

  @override
  State<CommissioningSupportScreen> createState() => _CommissioningSupportScreenState();
}

class _CommissioningSupportScreenState extends State<CommissioningSupportScreen> {
  bool _isAcDrive = true;
  bool _isDcDrive = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: const CustomAppBar(title: 'Commissioning Support'),
      drawer: const AppDrawer(),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          children: [
            Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Checkbox(
                              value: _isAcDrive,
                              onChanged: (v) {
                                setState(() {
                                  _isAcDrive = v ?? false;
                                  if (_isAcDrive) _isDcDrive = false;
                                });
                              },
                            ),
                            const Text('AC Drive'),
                          ],
                        ),
                        const SizedBox(width: 12),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Checkbox(
                              value: _isDcDrive,
                              onChanged: (v) {
                                setState(() {
                                  _isDcDrive = v ?? false;
                                  if (_isDcDrive) _isAcDrive = false;
                                });
                              },
                            ),
                            const Text('DC Drive'),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    DropdownMenu<String>(
                      expandedInsets: EdgeInsets.zero,
                      label: const Text('Compare selection'),
                      dropdownMenuEntries: const [],
                      onSelected: (_) {},
                    ),
                    const SizedBox(height: 12),
                    DropdownMenu<String>(
                      expandedInsets: EdgeInsets.zero,
                      label: const Text('Series selection'),
                      dropdownMenuEntries: const [],
                      onSelected: (_) {},
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
