import 'package:flutter/material.dart';
import 'package:nutz_app/screens/home_screen/model/home_model.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../controller/home_controller.dart';

class DetailScreen extends StatelessWidget {
  final Datum product;

  const DetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final homeController = Provider.of<HomeController>(context);
    final colorScheme = Theme.of(context).colorScheme;
    final hasImages = product.images != null && product.images!.isNotEmpty;
    Size size = MediaQuery.of(context).size;

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
            fontSize: size.height * 0.025,
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
        padding: EdgeInsets.all(size.height * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (hasImages)
              Column(
                children: [
                  CarouselSlider(
                    options: CarouselOptions(
                      height: size.height * 0.25,
                      viewportFraction: 1.0,
                      enlargeCenterPage: false,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 3),
                      autoPlayAnimationDuration:
                          const Duration(milliseconds: 800),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      onPageChanged: (index, reason) {
                        homeController.updateCurrentCarouselIndex(index);
                      },
                    ),
                    items: product.images!.map((imageUrl) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.symmetric(
                                horizontal: size.height * 0.002),
                            child: Image.network(
                              imageUrl,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                height: size.height * 0.25,
                                width: double.infinity,
                                color: colorScheme.surfaceContainerHighest,
                                child: Icon(Icons.error_outline,
                                    size: size.height * 0.06,
                                    color: colorScheme.onSurfaceVariant),
                              ),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                  SizedBox(height: size.height * 0.01),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(product.images!.length, (index) {
                      return Container(
                        width: homeController.currentCarouselIndex == index
                            ? size.height * 0.03
                            : size.height * 0.01,
                        height: size.height * 0.01,
                        margin: EdgeInsets.symmetric(
                            horizontal: size.height * 0.005),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(size.height * 0.005),
                          color: homeController.currentCarouselIndex == index
                              ? colorScheme.primary
                              : colorScheme.onSurface.withOpacity(0.3),
                        ),
                      );
                    }),
                  ),
                ],
              )
            else
              Container(
                height: size.height * 0.25,
                width: double.infinity,
                color: colorScheme.surfaceContainerHighest,
                child: Icon(Icons.image,
                    size: size.height * 0.06,
                    color: colorScheme.onSurfaceVariant),
              ),
            SizedBox(height: size.height * 0.02),
            Row(
              children: [
                Icon(Icons.star,
                    color: Colors.amber, size: size.height * 0.025),
                SizedBox(width: size.height * 0.005),
                Text(
                  product.rating?.toStringAsFixed(1) ?? '4.9',
                  style: TextStyle(
                    fontSize: size.height * 0.02,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            SizedBox(height: size.height * 0.01),
            Text(
              '₹ ${product.price?.toStringAsFixed(0) ?? '150000'}/-',
              style: TextStyle(
                fontSize: size.height * 0.03,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            SizedBox(height: size.height * 0.02),
            Text(
              product.name ?? 'iPhone 16 Pro',
              style: TextStyle(
                fontSize: size.height * 0.025,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            SizedBox(height: size.height * 0.02),
            Text(
              product.description ??
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit...',
              style: TextStyle(
                fontSize: size.height * 0.02,
                height: 1.5,
                color: colorScheme.onSurface.withOpacity(0.8),
              ),
            ),
            SizedBox(height: size.height * 0.06),
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
                  padding: EdgeInsets.symmetric(vertical: size.height * 0.012),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(size.height * 0.01),
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
