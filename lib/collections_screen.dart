import 'package:clothing_brand/product_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/collection_model.dart';
import '../cubit/collection_cubit.dart';
import '../cubit/collection_state.dart';
import '../custom_appbar.dart'; // تأكدي إن المسار ده صح عندك

class CollectionsScreen extends StatelessWidget {
  const CollectionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CollectionsCubit()..fetchCollections(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5EFD2),
        // 1. استخدام الـ AppBar الموحد هنا بدلاً من بنائه يدوياً في الـ body
        body: BlocBuilder<CollectionsCubit, CollectionsState>(
          builder: (context, state) {
            if (state is CollectionsLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFF4D0C0C)),
              );
            } else if (state is CollectionsSuccess) {
              return _buildCollectionContent(context, state.data);
            } else if (state is CollectionsError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Error: ${state.message}"),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () => context.read<CollectionsCubit>().fetchCollections(),
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4D0C0C)),
                      child: const Text("Retry", style: TextStyle(color: Colors.white)),
                    )
                  ],
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildCollectionContent(BuildContext context, CollectionResponse data) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Column(
        children: [
          // تم حذف الـ _buildCustomAppBar(context) من هنا لمنع التكرار

          Padding(
            padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
            child: Text(
              data.headerBar.title,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                fontFamily: 'serif',
                color: Colors.black,
              ),
            ),
          ),

          // الـ Grid بتاع الـ Collections
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: data.collectionsGrid.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 20,
                childAspectRatio: (screenWidth / 3) / (screenHeight * 0.22),
              ),
              itemBuilder: (context, index) {
                final item = data.collectionsGrid[index];

                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductsScreen(
                          categoryId: item.id,
                          categoryName: item.name,
                        ),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: _buildCategoryItem(
                    item.name,
                    item.imageUrl,
                    screenHeight,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(String title, String imageUrl, double screenHeight) {
    return Column(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: imageUrl.startsWith('http')
                ? Image.network(imageUrl, width: double.infinity, fit: BoxFit.cover)
                : Image.asset(imageUrl, width: double.infinity, fit: BoxFit.cover),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF4D0C0C),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 2),
            const Icon(
              Icons.arrow_right_alt,
              size: 16,
              color: Color(0xFF1E1E1E),
            ),
          ],
        ),
      ],
    );
  }
}