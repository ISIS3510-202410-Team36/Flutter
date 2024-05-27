class ProductModel {
  String? id;
  String name;
  String category;
  int price;
  bool used;
  String image;
  bool sold;
  int views = 0;
  String description;
  String? sellerId;

  ProductModel(
    this.id,
    this.name,
    this.category,
    this.price,
    this.used,
    this.image,
    this.sold,
    this.views,
    this.description,
    this.sellerId,
  );

  setproductId(String id) {
    this.id = id;
  }
}
