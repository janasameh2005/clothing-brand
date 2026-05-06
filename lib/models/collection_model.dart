import 'dart:convert';

CollectionResponse collectionResponseFromJson(String str) => CollectionResponse.fromJson(json.decode(str));

class CollectionResponse {
  final HeaderBar headerBar;
  final List<CollectionsGrid> collectionsGrid;

  CollectionResponse({required this.headerBar, required this.collectionsGrid});

  factory CollectionResponse.fromJson(Map<String, dynamic> json) => CollectionResponse(
    headerBar: HeaderBar.fromJson(json["header_bar"]),
    collectionsGrid: List<CollectionsGrid>.from(json["collections_grid"].map((x) => CollectionsGrid.fromJson(x))),
  );
}

class HeaderBar {
  final String title;
  HeaderBar({required this.title});
  factory HeaderBar.fromJson(Map<String, dynamic> json) => HeaderBar(title: json["title"] ?? "");
}

class CollectionsGrid {
  final int id;
  final String name;
  final String imageUrl;

  CollectionsGrid({required this.id, required this.name, required this.imageUrl});

  factory CollectionsGrid.fromJson(Map<String, dynamic> json) => CollectionsGrid(
    id: json["id"],
    name: json["name"],
    imageUrl: json["image_url"],
  );
}
