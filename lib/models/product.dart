import 'package:flutter_dotenv/flutter_dotenv.dart';
class Product {
  final String id;
  final String name;
  final String sku;
  final String? summary;
  final String? documentUrl;
  final List<String> images;
  final String? companyId;
  final String? companyName;
  final String? motorTypeName;
  final Map<String, dynamic>? specs;

  Product({
    required this.id,
    required this.name,
    required this.sku,
    this.summary,
    this.documentUrl,
    required this.images,
    this.companyId,
    this.companyName,
    this.motorTypeName,
    this.specs,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    String readString(dynamic v) => (v == null) ? '' : v.toString();
    String? readNullableString(dynamic v) {
      if (v == null) return null;
      final s = v.toString();
      return s.trim().isEmpty ? null : s;
    }

    final rawImages = json['images'] ?? json['imageUrls'] ?? json['image_urls'];
    List<String> parsedImages = [];
    if (rawImages is List) {
      for (var e in rawImages) {
        if (e is String && e.trim().isNotEmpty) {
          parsedImages.add(e.trim());
        } else if (e is Map) {
          final url = e['url'] ?? e['src'] ?? e['path'];
          if (url != null && url.toString().trim().isNotEmpty) {
            parsedImages.add(url.toString().trim());
          }
        }
      }
    }

    // Prefix images with domain if they are relative paths (e.g. /uploads/...)
    // Since dotenv is not directly imported here, we'll assume standard localhost
    // or rely on the UI to prefix it, but we can do a simple check:
    final String apiBase = dotenv.env['API_BASE_URL'] ?? 'http://localhost:3000/api/v1';
    final String defaultDomain = apiBase.replaceAll('/api/v1', '');
    parsedImages = parsedImages.map((img) {
      if (img.startsWith('/')) {
        return '$defaultDomain$img';
      }
      return img;
    }).toList();

    return Product(
      id: readString(json['id'] ?? json['_id']),
      name: readString(json['name'] ?? json['title']),
      sku: readString(json['sku'] ?? json['code']),
      summary: readNullableString(json['summary'] ?? json['description']),
      documentUrl: readNullableString(json['documentUrl'] ?? json['document_url']),
      images: parsedImages,
      companyId: readNullableString(json['companyId'] ?? json['company_id']),
      companyName: readNullableString(json['companyName']),
      motorTypeName: readNullableString(json['motorTypeName']),
      specs: json['specs'] != null ? Map<String, dynamic>.from(json['specs']) : null,
    );
  }
}
