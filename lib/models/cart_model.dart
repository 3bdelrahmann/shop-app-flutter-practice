class CartModel {
  bool? status;
  CartDataModel? data;

  CartModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? CartDataModel.fromJson(json['data']) : null;
  }
}

class CartDataModel {
  List<CartItemsModel>? cartItems;
  int? subTotal;
  int? total;

  CartDataModel.fromJson(Map<String, dynamic> json) {
    if (json['cart_items'] != null) {
      cartItems = <CartItemsModel>[];
      json['cart_items'].forEach((v) {
        cartItems!.add(CartItemsModel.fromJson(v));
      });
    }
    subTotal = json['sub_total'];
    total = json['total'];
  }
}

class CartItemsModel {
  int? id;
  int? quantity;
  CartProductModel? product;

  CartItemsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    quantity = json['quantity'];
    product = json['product'] != null
        ? CartProductModel.fromJson(json['product'])
        : null;
  }
}

class CartProductModel {
  int? id;
  int? price;
  int? oldPrice;
  int? discount;
  String? image;
  String? name;
  String? description;
  List<String>? images;
  bool? inFavorites;
  bool? inCart;

  CartProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    oldPrice = json['old_price'];
    discount = json['discount'];
    image = json['image'];
    name = json['name'];
    description = json['description'];
    images = json['images'].cast<String>();
    inFavorites = json['in_favorites'];
    inCart = json['in_cart'];
  }
}
