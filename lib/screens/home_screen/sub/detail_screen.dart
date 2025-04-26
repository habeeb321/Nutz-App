import 'package:flutter/material.dart';
import 'package:nutz_app/screens/home_screen/model/home_model.dart';
import 'package:provider/provider.dart';
import '../controller/home_controller.dart';

class DetailScreen extends StatelessWidget {
  final Datum product;

  const DetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final homeController = Provider.of<HomeController>(context, listen: false);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          'Product Details',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: colorScheme.onSurface,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.share, color: colorScheme.onSurface),
            onPressed: () => homeController.shareProduct(product),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: product.images != null && product.images!.isNotEmpty
                  ? Image.network(
                      product.images![0],
                      height: 200,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 200,
                        width: double.infinity,
                        color: colorScheme.surfaceContainerHighest,
                        child: Icon(Icons.error_outline,
                            size: 50, color: colorScheme.onSurfaceVariant),
                      ),
                    )
                  : Container(
                      height: 200,
                      color: colorScheme.surfaceContainerHighest,
                      child: Icon(Icons.image,
                          size: 50, color: colorScheme.onSurfaceVariant),
                    ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 20),
                const SizedBox(width: 4),
                Text(
                  product.rating?.toStringAsFixed(1) ?? '4.9',
                  style: TextStyle(
                    fontSize: 16,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '₹ ${product.price?.toStringAsFixed(0) ?? '150000'}/-',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              product.name ?? 'iPhone 16 Pro',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              product.description ??
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit...',
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
                color: colorScheme.onSurface.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 50),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () =>
                    homeController.generateAndSharePdf(product, context),
                icon: Icon(Icons.picture_as_pdf, color: colorScheme.onPrimary),
                label: Text(
                  'Download as PDF',
                  style: TextStyle(color: colorScheme.onPrimary),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
