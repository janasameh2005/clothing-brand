import 'dart:convert';

class ProductMockData {
  static final Map<int, Map<String, dynamic>> productsJson = {
    1: {
      "product": { "id": 1, "name": "Summer Dress", "price_display": "1400 EGP", "image_url": "https://i.ibb.co/MXgfTjG/dress3-1.png", "colors": [{"hex_code": "EEE0E0"}, {"hex_code": "1E256A"}], "sizes": [{"name": "S"}, {"name": "M"}], "description": "Summer dress designed for comfort." },
      "recommendations": []
    },
    2: {
      "product": { "id": 2, "name": "Linen Suit", "price_display": "2000 EGP", "image_url": "https://i.ibb.co/cKRsm48K/Frame-4.png", "colors": [{"hex_code": "1E256A"}, {"hex_code": "BDB6A0"}], "sizes": [{"name": "M"}, {"name": "L"}], "description": "Elegant linen suit." },
      "recommendations": []
    },
    3: {
      "product": { "id": 3, "name": "Zara Blazer", "price_display": "1120 EGP", "discount_label": "30%", "image_url": "https://i.ibb.co/Kz2GQYx0/Kate-Middleton.png", "colors": [{"hex_code": "EEE0E0"}], "sizes": [{"name": "S"}], "description": "High-waisted formal blazer." },
      "recommendations": []
    },
    4: { "product": { "id": 4, "name": "Cropped Trench", "price_display": "1500 EGP", "image_url": "https://i.ibb.co/wZ2BgJ0g/Gabardina-cropped-1.png", "colors": [{"hex_code": "BDB6A0"}], "sizes": [{"name": "M"}], "description": "Modern cropped trench." }, "recommendations": [] },
    5: { "product": { "id": 5, "name": "Pants", "price_display": "699 EGP", "image_url": "https://i.ibb.co/V0VXPm7h/pantalon-2.png", "colors": [{"hex_code": "4B0E0E"}], "sizes": [{"name": "XL"}], "description": "Comfortable daily pants." }, "recommendations": [] },
    6: { "product": { "id": 6, "name": "Black Vest", "price_display": "750 EGP", "image_url": "https://i.ibb.co/GQqDf5XC/Vest-2.png", "colors": [{"hex_code": "000000"}], "sizes": [{"name": "L"}], "description": "Stylish black vest." }, "recommendations": [] },
    7: { "product": { "id": 7, "name": "Floral Skirt", "price_display": "900 EGP", "image_url": "https://i.ibb.co/hqZFcXh/skirt-2.png", "colors": [{"hex_code": "EEE0E0"}], "sizes": [{"name": "M"}], "description": "Beautiful floral print skirt." }, "recommendations": [] },
    8: { "product": { "id": 8, "name": "Red Blouse", "price_display": "650 EGP", "image_url": "https://i.ibb.co/fz1JkgWG/blouse-2.png", "colors": [{"hex_code": "9E192D"}], "sizes": [{"name": "S"}], "description": "Elegant red blouse." }, "recommendations": [] },
    9: { "product": { "id": 9, "name": "Cool Hoodie", "price_display": "1000 EGP", "image_url": "https://i.ibb.co/1f7xL6QH/sweet-2.png", "colors": [{"hex_code": "1E256A"}], "sizes": [{"name": "S", "M": "L"}], "description": "Warm hoodie." }, "recommendations": [] },
    10: { "product": { "id": 10, "name": "Dress", "price_display": "2000 EGP", "image_url": "https://i.ibb.co/chnwcwqH/dress-4.png", "colors": [{"hex_code": "BDB6A0"}], "sizes": [{"name": "M"}], "description": "Special occasions dress." }, "recommendations": [] },
    11: { "product": { "id": 11, "name": "Puff Sleeve Shirt", "price_display": "1500 EGP", "image_url": "https://i.ibb.co/j9xDWhfw/Frame-6.png", "colors": [{"hex_code": "FFFFFF"}], "sizes": [{"name": "S"}], "description": "Trendy puff sleeve shirt." }, "recommendations": [] },
  };

  static Map<String, dynamic> getFallbackData(int id) {
    Map<String, dynamic> data = productsJson[id] ?? productsJson[1]!;

    // الحل السحري: لو الـ recommendations فاضية، هيملاها تلقائياً بمنتجين من اللستة
    if ((data['recommendations'] as List).isEmpty) {
      data['recommendations'] = [
        {
          "id": 11,
          "name": productsJson[11]!['product']['name'],
          "price_display": productsJson[11]!['product']['price_display'],
          "image_url": productsJson[11]!['product']['image_url'],
        },
        {
          "id": 6,
          "name": productsJson[6]!['product']['name'],
          "price_display": productsJson[6]!['product']['price_display'],
          "image_url": productsJson[6]!['product']['image_url'],
        }
      ];
    }
    return data;
  }
}