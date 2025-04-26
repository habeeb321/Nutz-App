import 'package:flutter/material.dart';
import 'package:nutz_app/screens/home_screen/controller/home_controller.dart';
import 'package:nutz_app/screens/home_screen/model/home_model.dart';
import 'package:nutz_app/screens/home_screen/sub/detail_screen.dart';
import 'package:nutz_app/screens/auth/login_screen/controller/login_controller.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool hasFetchedData = false;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData();
    searchController.addListener(onSearchChanged);
  }

  @override
  void dispose() {
    searchController.removeListener(onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  void onSearchChanged() {
    Provider.of<HomeController>(context, listen: false)
        .searchProducts(searchController.text);
  }

  Future<void> fetchData() async {
    if (!hasFetchedData) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await Provider.of<HomeController>(context, listen: false)
            .fetchIphoneData();
        hasFetchedData = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<LoginController>(context).auth.currentUser;
    final homeController = Provider.of<HomeController>(context);
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hey, ${user?.displayName ?? 'User'} 👋',
          style: TextStyle(
            fontSize: size.height * 0.022,
            fontWeight: FontWeight.w400,
          ),
        ),
        actions: const [
          Icon(Icons.notifications_outlined),
          SizedBox(width: 16),
        ],
      ),
      body: homeController.isLoading && !hasFetchedData
          ? const Center(child: CircularProgressIndicator())
          : homeController.hasError
              ? Center(child: Text(homeController.errorMessage))
              : RefreshIndicator(
                  onRefresh: homeController.fetchIphoneData,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(size.height * 0.02),
                        child: TextField(
                          controller: searchController,
                          decoration: InputDecoration(
                            hintText: 'Search for Products',
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(size.height * 0.01),
                            ),
                            suffixIcon: searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear),
                                    onPressed: () {
                                      searchController.clear();
                                    },
                                  )
                                : null,
                          ),
                        ),
                      ),
                      Expanded(
                        child: homeController.filteredProducts.isEmpty
                            ? const Center(
                                child: Text('No products found'),
                              )
                            : GridView.builder(
                                padding: EdgeInsets.all(size.height * 0.02),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: size.height * 0.012,
                                  mainAxisSpacing: size.height * 0.012,
                                  childAspectRatio: 0.6,
                                ),
                                itemCount:
                                    homeController.filteredProducts.length,
                                itemBuilder: (context, index) {
                                  final product =
                                      homeController.filteredProducts[index];
                                  return buildProductCard(
                                      product, context, size);
                                },
                              ),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget buildProductCard(Datum product, BuildContext context, Size size) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailScreen(product: product),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(size.height * 0.015),
        ),
        elevation: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(size.height * 0.015),
                    topRight: Radius.circular(size.height * 0.015),
                  ),
                  child: product.images != null && product.images!.isNotEmpty
                      ? Image.network(
                          product.images![0],
                          height: size.height * 0.15,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                            height: size.height * 0.15,
                            width: double.infinity,
                            color: Colors.grey[200],
                            child: Icon(Icons.error_outline,
                                size: size.height * 0.06),
                          ),
                        )
                      : Container(
                          height: size.height * 0.15,
                          color: Colors.grey[200],
                          width: double.infinity,
                          child: const Icon(Icons.image),
                        ),
                ),
                Positioned(
                  top: size.height * 0.01,
                  right: size.height * 0.01,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardTheme.color,
                      shape: BoxShape.circle,
                    ),
                    padding: EdgeInsets.all(size.height * 0.005),
                    child: Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: size.height * 0.022,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(size.height * 0.015),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name ?? 'iPhone 14 Pro',
                    style: TextStyle(
                      fontSize: size.height * 0.017,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: size.height * 0.005),
                  Text(
                    '₹ ${product.price?.toStringAsFixed(0) ?? '150000'}/-',
                    style: TextStyle(
                      fontSize: size.height * 0.02,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: size.height * 0.005),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: size.height * 0.017,
                      ),
                      SizedBox(width: size.height * 0.005),
                      Text(
                        product.rating?.toStringAsFixed(1) ?? '4.5',
                        style: TextStyle(
                          fontSize: size.height * 0.015,
                          color: Colors.grey,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: size.height * 0.01,
                          vertical: size.height * 0.002,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius:
                              BorderRadius.circular(size.height * 0.005),
                        ),
                        child: Text(
                          'New',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: size.height * 0.012,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.01),
                  Text(
                    product.description ?? 'Lorem ipsum dolor sit amet',
                    style: TextStyle(
                      fontSize: size.height * 0.015,
                      color: Colors.grey,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
