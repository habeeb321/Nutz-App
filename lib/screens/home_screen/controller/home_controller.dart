import 'package:flutter/material.dart';
import 'package:nutz_app/screens/home_screen/model/home_model.dart';
import 'package:nutz_app/screens/home_screen/service/home_service.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';
import 'package:http/http.dart' as http;

class HomeController with ChangeNotifier {
  bool isLoading = false;
  bool hasError = false;
  String errorMessage = '';
  HomeModel? homeData;
  List<Datum> filteredProducts = [];
  String searchQuery = '';

  Future<void> fetchIphoneData() async {
    try {
      isLoading = true;
      hasError = false;
      errorMessage = '';
      notifyListeners();

      final data = await HomeService.getIphoneData();
      if (data != null) {
        homeData = data;
        filteredProducts = data.data ?? [];
      } else {
        hasError = true;
        errorMessage = 'Failed to load data';
      }
    } catch (e) {
      hasError = true;
      errorMessage = e.toString();
      debugPrint('Error in controller: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void searchProducts(String query) {
    searchQuery = query;
    if (query.isEmpty) {
      filteredProducts = homeData?.data ?? [];
    } else {
      filteredProducts = homeData?.data
              ?.where((product) =>
                  (product.name?.toLowerCase().contains(query.toLowerCase()) ??
                      false) ||
                  (product.description
                          ?.toLowerCase()
                          .contains(query.toLowerCase()) ??
                      false))
              .toList() ??
          [];
    }
    notifyListeners();
  }

  Future<void> generateAndSharePdf(Datum product, BuildContext context) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      final pdf = pw.Document();

      pw.MemoryImage? productImage;
      if (product.images![0].isNotEmpty) {
        try {
          final response = await http.get(Uri.parse(product.images![0]));
          if (response.statusCode == 200) {
            productImage = pw.MemoryImage(response.bodyBytes);
          }
        } catch (e) {
          debugPrint('Error downloading image: $e');
        }
      }

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(product.name ?? 'Product Details',
                  style: pw.TextStyle(
                      fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              if (productImage != null) ...[
                pw.Center(
                  child: pw.Image(productImage, height: 200),
                ),
                pw.SizedBox(height: 15),
              ],
              pw.Text('Price: ₹ ${product.price?.toStringAsFixed(0) ?? 'N/A'}',
                  style: const pw.TextStyle(fontSize: 18)),
              pw.SizedBox(height: 10),
              pw.Text('Rating: ${product.rating?.toStringAsFixed(1) ?? 'N/A'}',
                  style: const pw.TextStyle(fontSize: 18)),
              pw.SizedBox(height: 20),
              pw.Text('Description:',
                  style: pw.TextStyle(
                      fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.Text(product.description ?? 'No description available',
                  style: const pw.TextStyle(fontSize: 14)),
            ],
          ),
        ),
      );

      final output = await getTemporaryDirectory();
      final file = File("${output.path}/${product.name ?? 'product'}.pdf");
      await file.writeAsBytes(await pdf.save());

      Navigator.of(context).pop();

      await Share.shareXFiles([XFile(file.path)],
          text: 'Check out this product: ${product.name}');
    } catch (e) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to generate PDF: $e')));
    }
  }

  Future<void> shareProduct(Datum product) async {
    try {
      if (product.images![0].isNotEmpty) {
        final response = await http.get(Uri.parse(product.images![0]));
        if (response.statusCode == 200) {
          final tempDir = await getTemporaryDirectory();
          final imageFile = File('${tempDir.path}/product_image.jpg');
          await imageFile.writeAsBytes(response.bodyBytes);

          await Share.shareXFiles(
            [XFile(imageFile.path)],
            text: 'Check out this product: ${product.name}\n'
                'Price: ${product.price?.toStringAsFixed(0) ?? 'N/A'}\n'
                'Rating: ${product.rating?.toStringAsFixed(1) ?? 'N/A'}\n\n'
                '${product.description ?? ''}',
          );
        } else {
          _shareTextOnly(product);
        }
      } else {
        _shareTextOnly(product);
      }
    } catch (e) {
      debugPrint('Error sharing product with image: $e');

      _shareTextOnly(product);
    }
  }

  void _shareTextOnly(Datum product) {
    Share.share(
      'Check out this product: ${product.name}\n'
      'Price: ₹ ${product.price?.toStringAsFixed(0) ?? 'N/A'}\n'
      'Rating: ${product.rating?.toStringAsFixed(1) ?? 'N/A'}\n\n'
      '${product.description ?? ''}',
    );
  }
}
