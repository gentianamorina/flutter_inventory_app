class Product{

  String name, brand, color;
  int id, size, qty;

  Product({this.id, this.name, this.brand, this.color, this.size, this.qty});

  Map<String, dynamic> toMap(){
    var map = <String, dynamic>{
      'id': id,
      'name': name,
      'brand': brand,
      'color': color,
      'size': size,
      'qty': qty,
    };
    return map;
  }

  Product.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    brand = map['brand'];
    color = map['color'];
    size = map['size'];
    qty = map['qty'];
  }
}

class Image{

  int id;
  String path;
  int product_id;
  Product product;

  Image({this.id, this.path, this.product_id});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic> {
      'id': id,
      'path': path,
      'product_id': product_id,
    };
    return map;
  }

  Image.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    path = map['path'];
    id = map['product_id'];
  }
}