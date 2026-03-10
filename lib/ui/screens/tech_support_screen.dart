import 'package:flutter/material.dart';
import '../../core/app_theme.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/app_drawer.dart';
import '../../models/company.dart';
import '../../models/product.dart';
import '../../services/master_service.dart';
import '../../services/product_service.dart';

class TechSupportScreen extends StatefulWidget {
  const TechSupportScreen({super.key});

  @override
  State<TechSupportScreen> createState() => _TechSupportScreenState();
}

class _TechSupportScreenState extends State<TechSupportScreen> {
  bool _isAcDrive = true;
  bool _isDcDrive = false;

  final MasterService _masterService = MasterService();
  final ProductService _productService = ProductService();

  List<Company> _companies = [];
  Company? _selectedCompany;
  bool _isLoadingCompanies = true;

  List<Product> _series = [];
  Product? _selectedSeries;
  bool _isLoadingSeries = false;
  final TextEditingController _seriesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCompanies();
  }

  @override
  void dispose() {
    _seriesController.dispose();
    super.dispose();
  }

  Future<void> _loadCompanies() async {
    try {
      final companies = await _masterService.getCompanies();
      if (mounted) {
        setState(() {
          _companies = companies;
          _isLoadingCompanies = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingCompanies = false);
      }
    }
  }

  Future<void> _loadSeries(String companyId) async {
    setState(() {
      _isLoadingSeries = true;
      _series = [];
      _selectedSeries = null;
      _seriesController.clear();
    });
    try {
      final products = await _productService.getProducts(companyId: companyId);
      if (mounted) {
        setState(() {
          _series = products.where((p) {
            if (_isAcDrive && p.motorTypeName != 'AC') return false;
            if (_isDcDrive && p.motorTypeName != 'DC') return false;
            return true;
          }).toList();
          _isLoadingSeries = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingSeries = false);
      }
    }
  }

  void _selectAcDrive(bool? value) {
    setState(() {
      _isAcDrive = value ?? false;
      if (_isAcDrive) _isDcDrive = false;
      _updateSeriesFilter();
    });
  }

  void _selectDcDrive(bool? value) {
    setState(() {
      _isDcDrive = value ?? false;
      if (_isDcDrive) _isAcDrive = false;
      _updateSeriesFilter();
    });
  }

  void _updateSeriesFilter() {
    if (_selectedCompany != null) {
      _loadSeries(_selectedCompany!.id);
    }
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
                    DropdownMenu<Company>(
                      expandedInsets: EdgeInsets.zero,
                      label: const Text('Company selection'),
                      dropdownMenuEntries: _companies.map((c) {
                        return DropdownMenuEntry<Company>(
                          value: c,
                          label: c.name,
                        );
                      }).toList(),
                      onSelected: (Company? company) {
                        setState(() {
                          _selectedCompany = company;
                        });
                        if (company != null) {
                          _loadSeries(company.id);
                        }
                      },
                      enabled: !_isLoadingCompanies,
                    ),

                    const SizedBox(height: 12),

                    /// SERIES DROPDOWN
                    DropdownMenu<Product>(
                      controller: _seriesController,
                      expandedInsets: EdgeInsets.zero,
                      label: const Text('Series selection'),
                      dropdownMenuEntries: _series.map((p) {
                        return DropdownMenuEntry<Product>(
                          value: p,
                          label: p.name,
                        );
                      }).toList(),
                      onSelected: (Product? product) {
                        setState(() {
                          _selectedSeries = product;
                        });
                      },
                      enabled: !_isLoadingSeries && _selectedCompany != null,
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