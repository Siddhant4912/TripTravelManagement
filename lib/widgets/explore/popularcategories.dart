import 'package:flutter/material.dart';

class PopularCategoriesPage extends StatefulWidget {
  const PopularCategoriesPage({super.key});

  @override
  State<PopularCategoriesPage> createState() => _PopularCategoriesPageState();
}

class _PopularCategoriesPageState extends State<PopularCategoriesPage> {
  final List<Category> categories = [
    Category(
      title: "Sea & Beach",
      trips: 319,
      imageUrl: "https://images.unsplash.com/photo-1529122280400-9d085bc9e767",
    ),
    Category(
      title: "Road Trips",
      trips: 146,
      imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT05PPqCw01NWo55HHSmbYpb4QCHm_dTxPAtg&s",
    ),
    Category(
      title: "City Tours",
      trips: 347,
      imageUrl: "https://images.unsplash.com/photo-1526744092461-e4ca99f42a29",
    ),
    Category(
      title: "Mountains",
      trips: 224,
      imageUrl: "https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Discover"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Popular Categories",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.8,
                children: categories.map((category) {
                  return CategoryCard(category: category);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Category {
  final String title;
  final int trips;
  final String imageUrl;

  Category({required this.title, required this.trips, required this.imageUrl});
}

class CategoryCard extends StatelessWidget {
  final Category category;

  const CategoryCard({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Stack(
        children: [
          Image.network(
            category.imageUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.center,
                colors: [
                  Colors.black.withOpacity(0.8),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 15,
            left: 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  "${category.trips} Trips",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
