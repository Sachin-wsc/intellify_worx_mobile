import 'package:flutter/material.dart';
import '../../core/app_theme.dart';
import '../../models/product.dart';
import '../../services/product_service.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/custom_app_bar.dart';
import '../widgets/app_drawer.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _currentImageIndex = 0;
  bool _isLoading = true;
  Product? _detailedProduct;
  final ProductService _productService = ProductService();

  @override
  void initState() {
    super.initState();
    _fetchDetails();
  }

  Future<void> _fetchDetails() async {
    try {
      final details = await _productService.getProductDetails(widget.product.id);
      if (mounted) {
        setState(() {
          _detailedProduct = details;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _launchUrl(String? urlString) async {
    if (urlString == null || urlString.isEmpty) return;
    
    // Check if the URL is relative, assume it's hosted on API_BASE_URL (removing /api/v1)
    String finalUrl = urlString;
    if (urlString.startsWith('/')) {
        // Construct full URL using the same logic as the images or a hardcoded fallback for now
        // This should ideally pull from dotenv, but we can manage a basic fallback
        finalUrl = 'http://192.168.1.27:3000$urlString';
    }

    final Uri url = Uri.parse(finalUrl);
    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Could not launch $finalUrl')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch $finalUrl: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final hasImages = p.images.isNotEmpty;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: CustomAppBar(title: p.name),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image Carousel section
            if (hasImages)
              Container(
                color: Colors.white,
                height: 250,
                child: Stack(
                  children: [
                    PageView.builder(
                      itemCount: p.images.length,
                      onPageChanged: (index) {
                        setState(() {
                          _currentImageIndex = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        return Image.network(
                          p.images[index],
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => 
                            const Center(child: Icon(Icons.broken_image, size: 50, color: Colors.grey)),
                        );
                      },
                    ),
                    if (p.images.length > 1)
                      Positioned(
                        bottom: 10,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            p.images.length,
                            (index) => Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _currentImageIndex == index
                                    ? AppTheme.primaryBlue
                                    : Colors.grey.withOpacity(0.5),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              )
            else
              Container(
                color: Colors.white,
                height: 200,
                child: const Center(
                  child: Icon(Icons.inventory_2, size: 80, color: Colors.grey),
                ),
              ),
            
            const SizedBox(height: 16),

            if (_isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: CircularProgressIndicator(),
                ),
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Basic Info Header
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _detailedProduct?.name ?? p.name,
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1F2937)),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEFF6FF),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                "SKU: ${_detailedProduct?.sku ?? p.sku}",
                                style: const TextStyle(color: Color(0xFF2563EB), fontWeight: FontWeight.w600, fontSize: 13),
                              ),
                            ),
                            if (_detailedProduct?.motorTypeName != null) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF3F4F6),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  _detailedProduct!.motorTypeName!,
                                  style: const TextStyle(color: Color(0xFF4B5563), fontWeight: FontWeight.w600, fontSize: 13),
                                ),
                              ),
                            ],
                          ],
                        ),
                        if (_detailedProduct?.summary != null && _detailedProduct!.summary!.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          Text(
                            _detailedProduct!.summary!,
                            style: const TextStyle(color: Color(0xFF4B5563), fontSize: 15, height: 1.5),
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Technical Specifications
                  if (_detailedProduct?.specs != null)
                    _buildTechnicalSpecs(_detailedProduct!.specs!),

                  if (_detailedProduct?.documentUrl != null && _detailedProduct!.documentUrl!.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    // Documents Section
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Documents",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF1F2937)),
                          ),
                          const SizedBox(height: 12),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF3F4F6),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.description, color: Color(0xFF4B5563)),
                            ),
                            title: const Text("Product Manual / Catalog", style: TextStyle(fontWeight: FontWeight.w600)),
                            subtitle: const Text("Tap to view document", style: TextStyle(fontSize: 12)),
                            trailing: const Icon(Icons.download, color: AppTheme.primaryBlue),
                            onTap: () => _launchUrl(_detailedProduct!.documentUrl),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildTechnicalSpecs(Map<String, dynamic> specs) {
    final isAC = specs['isAC'] == true;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Technical Specifications",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF1F2937)),
          ),
          const SizedBox(height: 16),
          if (isAC) ...[
            _buildSpecRow("AC Power (kW)", "${specs['acKw'] ?? '-'} kW"),
            _buildSpecRow("Poles", "${specs['poleNumber'] ?? '-'}"),
            _buildSpecRow("Voltage", "${specs['voltageValue'] ?? '-'} ${specs['voltageUnit'] ?? 'V'}"),
            _buildSpecRow("Frequency", "${specs['frequencyValue'] ?? '-'} ${specs['frequencyUnit'] ?? 'Hz'}"),
            _buildSpecRow("Application", specs['acApplicationName']?.toString() ?? '-'),
            _buildSpecRow("Total Motors", "${specs['totalMotors'] ?? '-'}"),
            _buildSpecRow("Motors Per Group", "${specs['motorsPerGroup'] ?? '-'}"),
          ] else ...[
            _buildSpecRow("DC Armature Voltage", "${specs['dcArmatureVoltage'] ?? '-'} V"),
            _buildSpecRow("DC Power (kW)", "${specs['dcKw'] ?? '-'} kW"),
            _buildSpecRow("DC Field Voltage", "${specs['dcFieldVoltage'] ?? '-'} V"),
            _buildSpecRow("DC Field Current", "${specs['dcFieldCurrent'] ?? '-'} A"),
            _buildSpecRow("Application", specs['dcApplicationName']?.toString() ?? '-'),
          ],
        ],
      ),
    );
  }

  Widget _buildSpecRow(String label, String value) {
    if (value == '-' || value == '- kW' || value == '- V' || value == '- Hz' || value == '- A') return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(color: Color(0xFF6B7280), fontSize: 15),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(color: Color(0xFF1F2937), fontWeight: FontWeight.w500, fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}
