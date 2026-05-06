
import 'package:http/http.dart' as http;
import '../models/collection_model.dart';

class CollectionApiService {
  final String apiUrl = "https://10cxyvxk6z8u.shares.zrok.io/api/collections/";

  Future<CollectionResponse?> fetchCollectionsData() async {
    try {
      final response = await http.get(Uri.parse(apiUrl)).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        return collectionResponseFromJson(response.body);
      } else {
        return _loadLocalData();
      }
    } catch (e) {
      return _loadLocalData();
    }
  }

  // الـ JSON اللي إنتِ بعتيه حطيتهولك هنا كـ "طوق نجاة"
  CollectionResponse _loadLocalData() {
    String jsonRaw = '''
    {
      "header_bar": { "title": "Collections" },
      "collections_grid": [
          { "id": 1, "name": "Shirts", "image_url": "https://i.ibb.co/j9xDWhfw/Frame-6.png" },
          { "id": 2, "name": "Pants", "image_url": "https://i.ibb.co/CKmSXz7G/Frame-8.png" },
          { "id": 3, "name": "Dresses", "image_url": "https://i.ibb.co/7N6NdNrd/Frame-7.png" },
          { "id": 4, "name": "Suits", "image_url": "https://i.ibb.co/cKRsm48K/Frame-4.png" },
          { "id": 5, "name": "Blouses", "image_url": "https://i.ibb.co/fz1JkgWG/blouse-2.png" },
          { "id": 6, "name": "Hoodies", "image_url": "https://i.ibb.co/1f7xL6QH/sweet-2.png" },
          { "id": 7, "name": "Vests", "image_url": "https://i.ibb.co/GQqDf5XC/Vest-2.png" },
          { "id": 8, "name": "Skirts", "image_url": "https://i.ibb.co/hqZFcXh/skirt-2.png" },
          { "id": 9, "name": "Jackets", "image_url": "https://i.ibb.co/wZ2BgJ0g/Gabardina-cropped-1.png" }
      ]
    }
    ''';
    return collectionResponseFromJson(jsonRaw);
  }
}