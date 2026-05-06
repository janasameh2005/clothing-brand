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
      create: (context) => NewArrivalsCubit()..fetchNewArrivals(),
      child: Scaffold(
        backgroundColor: Apptheme.primaryBackground,
        body: SafeArea(
          child: BlocBuilder<NewArrivalsCubit, NewArrivalsState>(
            builder: (context, state) {
              if (state is NewArrivalsLoading) {
                return const Center(child: CircularProgressIndicator(color: Apptheme.accentDark));
              } 
              
              if (state is NewArrivalsError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(state.message),
                      ElevatedButton(
                        onPressed: () => context.read<NewArrivalsCubit>().fetchNewArrivals(),
                        child: const Text("Retry"),
                      )
                    ],
                  ),
                );
              }

              if (state is NewArrivalsSuccess) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        state.title,
                        style: Apptheme.textTheme.displaySmall?.copyWith(
                          fontFamily: 'serif',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: GridView.builder(
                          itemCount: state.products.length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 15,
                            mainAxisSpacing: 20,
                            childAspectRatio: 0.55,
                          ),
                          itemBuilder: (context, index) {
                            final product = state.products[index];
                            return ItemCard(
                              title: product.name,
                              price: product.priceDisplay,
                              imagePath: product.imageUrl,
                              colors: product.colors,
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context, String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Oops! $error"),
          ElevatedButton(
            onPressed: () => context.read<NewArrivalsCubit>().fetchNewArrivals(),
            child: const Text("Retry"),
          )
        ],
      ),
    );
  }
}