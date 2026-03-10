import 'package:flutter/material.dart';
import '../../core/app_theme.dart';

import '../widgets/custom_app_bar.dart';
import '../widgets/app_drawer.dart';
import '../../models/company.dart';
import '../../models/product.dart';
import '../../services/master_service.dart';
import '../../services/product_service.dart';

class CommissioningSupportScreen extends StatefulWidget {
  const CommissioningSupportScreen({super.key});

  @override
  State<CommissioningSupportScreen> createState() => _CommissioningSupportScreenState();
}

class _CommissioningSupportScreenState extends State<CommissioningSupportScreen> {
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

  void _updateSeriesFilter() {
    if (_selectedCompany != null) {
      _loadSeries(_selectedCompany!.id);
    }
  }

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
                                  _updateSeriesFilter();
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
                                  _updateSeriesFilter();
                                });
                              },
                            ),
                            const Text('DC Drive'),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
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
