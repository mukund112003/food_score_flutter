class FoodHistoryModel {
  String? id;
  String? productName;
  String? productImage;
  String? foodScore;
  List<Ingredients>? ingredients;
  String? createdAt;
  String? updatedAt;

  FoodHistoryModel({
    this.id,
    this.productName,
    this.productImage,
    this.foodScore,
    this.ingredients,
    this.createdAt,
    this.updatedAt,
  });

  factory FoodHistoryModel.fromJson(Map<String, dynamic> json) {
    return FoodHistoryModel(
      id: json['_id'],
      productName: json['product_name'],
      productImage: json['image_path'],
      foodScore: json['food_score'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      ingredients: (json['ingredients'] as List<dynamic>?)
          ?.map((item) => Ingredients.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'product_name': productName,
      'image_path': productImage,
      'food_score': foodScore,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'ingredients': ingredients?.map((item) => item.toJson()).toList(),
    };
  }
}

class Ingredients {
  String? name;
  String? healthiness;

  Ingredients({this.name, this.healthiness});

  factory Ingredients.fromJson(Map<String, dynamic> json) {
    return Ingredients(
      name: json['name'],
      healthiness: json['healthiness'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'healthiness': healthiness,
    };
  }
}
