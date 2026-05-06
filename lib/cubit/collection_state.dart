import '../models/collection_model.dart';

abstract class CollectionsState {}
class CollectionsInitial extends CollectionsState {}
class CollectionsLoading extends CollectionsState {}
class CollectionsSuccess extends CollectionsState {
  final CollectionResponse data;
  CollectionsSuccess(this.data);
}
class CollectionsError extends CollectionsState {
  final String message;
  CollectionsError(this.message);
}