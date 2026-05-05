import 'package:clothing_brand/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'apptheme.dart';
import 'item_card.dart';
import 'new_arrivals_cubit.dart';

class NewArrivalsScreen extends StatefulWidget {
  const NewArrivalsScreen({super.key});

  @override
  State<NewArrivalsScreen> createState() => _NewArrivalsScreenState();
}

class _NewArrivalsScreenState extends State<NewArrivalsScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NewArrivalsCubit()..getNewArrivals(),
      child: Scaffold(
        backgroundColor: Apptheme.primaryBackground,
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: BlocBuilder<NewArrivalsCubit, NewArrivalsState>(
                  builder: (context, state) {
                    if (state is NewArrivalsLoading) {
                      return const Center(child: CircularProgressIndicator(color: Apptheme.accentDark));
                    } else if (state is NewArrivalsSuccess) {
                      return _buildProductGrid(state.products);
                    } else if (state is NewArrivalsError) {
                      return _buildErrorWidget(context, state.errorMessage);
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Text(
        "New Arrivals",
        style: Apptheme.textTheme.displaySmall?.copyWith(
          fontFamily: 'serif',
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildProductGrid(List<ProductModel> products) {
    if (products.isEmpty) return const Center(child: Text("No products found."));
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        itemCount: products.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 20,
          childAspectRatio: 0.55,
        ),
        itemBuilder: (context, index) {
          final p = products[index];
          return ItemCard(
            title: p.title,
            price: "${p.price} EGP",
            imagePath: p.image,
            colors: const [Colors.black, Colors.grey],
          );
        },
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 40),
          Text(message, textAlign: TextAlign.center),
          ElevatedButton(
            onPressed: () => context.read<NewArrivalsCubit>().getNewArrivals(),
            child: const Text("Retry"),
          )
        ],
      ),
    );
  }
}