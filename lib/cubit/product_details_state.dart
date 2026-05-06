import '../models/product_details_model.dart';

abstract class ProductDetailsState {}

class ProductDetailsInitial extends ProductDetailsState {}

class ProductDetailsLoading extends ProductDetailsState {}

class ProductDetailsSuccess extends ProductDetailsState {
  final ProductDetailsResponse data;
  ProductDetailsSuccess(this.data);
}

class ProductDetailsError extends ProductDetailsState {
  final String message;
  ProductDetailsError(this.message);
}