import 'package:flutter_bloc/flutter_bloc.dart';
import '../api_service/collection_service.dart';
import 'collection_state.dart';


class CollectionsCubit extends Cubit<CollectionsState> {
  final CollectionApiService apiService = CollectionApiService();

  CollectionsCubit() : super(CollectionsInitial());

  Future<void> fetchCollections() async {
    emit(CollectionsLoading());
    try {
      final data = await apiService.fetchCollectionsData();
      if (data != null) {
        emit(CollectionsSuccess(data));
      } else {
        emit(CollectionsError("عفواً، فشل في تحميل المجموعات"));
      }
    } catch (e) {
      emit(CollectionsError("حدث خطأ: $e"));
    }
  }
}