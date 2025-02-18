class FoodDetails {
  String? foodScore;
  String? productName;
  List<Ingredients>? ingredients;

  FoodDetails({this.foodScore, this.productName, this.ingredients});

  FoodDetails.fromJson(Map<String, dynamic> json) {
    foodScore = json['food_score'];
    productName = json['product_name'];
    if (json['ingredients'] != null) {
      ingredients = <Ingredients>[];
      json['ingredients'].forEach((v) {
        ingredients!.add(Ingredients.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['food_score'] = foodScore;
    data['product_name'] = productName;
    if (ingredients != null) {
      data['ingredients'] = ingredients!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Ingredients {
  String? name;
  String? healthiness;

  Ingredients({this.name, this.healthiness});

  Ingredients.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    healthiness = json['healthiness'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['healthiness'] = healthiness;
    return data;
  }
}
