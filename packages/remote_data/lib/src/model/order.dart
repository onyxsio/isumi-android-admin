import 'package:cloud_firestore/cloud_firestore.dart';

class Orders {
  String? sId;
  String? date;
  String? currency;
  List<Items>? items;
  String? total;
  String? paymetStatus;
  String? discountedPrice;
  String? delivery;
  Customer? customer;

  Orders(
      {this.items,
      this.total,
      this.sId,
      this.date,
      this.currency,
      this.delivery,
      this.paymetStatus,
      this.discountedPrice,
      this.customer});
//
  Orders.fromFirebaseJson(DocumentSnapshot snap) {
    Map<String, dynamic> json = snap.data() as Map<String, dynamic>;
    sId = json['_id'];
    date = json['date'];
    currency = json['currency'];
    delivery = json['delivery'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(Items.fromJson(v));
      });
    }
    total = json['total'];
    paymetStatus = json['paymetStatus'];
    discountedPrice = json['discountedPrice'];
    customer =
        json['customer'] != null ? Customer.fromJson(json['customer']) : null;
  }
//
  Orders.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    date = json['date'];
    currency = json['currency'];
    delivery = json['delivery'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(Items.fromJson(v));
      });
    }
    total = json['total'];
    paymetStatus = json['paymetStatus'];
    discountedPrice = json['discountedPrice'];
    customer =
        json['customer'] != null ? Customer.fromJson(json['customer']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['currency'] = currency;
    data['date'] = date;
    data['delivery'] = delivery;
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    data['total'] = total;
    data['paymetStatus'] = paymetStatus;
    data['discountedPrice'] = discountedPrice;
    if (customer != null) {
      data['customer'] = customer!.toJson();
    }
    return data;
  }
}

// ! Items
class Items {
  String? id;
  String? productId;
  String? sellerId;
  String? name;
  String? color;
  String? size;
  String? quantity;
  String? image;
  String? price;
  String? currency;
  // List<Variants>? variants;

  Items({
    this.sellerId,
    this.id,
    this.productId,
    this.name,
    this.image,
    this.price,
    this.color,
    this.quantity,
    this.size,
    this.currency,
  });
  Items copyWith({
    String? productId,
    String? sellerId,
    String? id,
    String? name,
    String? color,
    String? size,
    String? quantity,
    String? image,
    String? price,
    String? currency,
  }) =>
      Items(
        productId: productId ?? this.productId,
        id: id ?? this.id,
        sellerId: sellerId ?? this.sellerId,
        name: name ?? this.name,
        color: color ?? this.color,
        size: size ?? this.size,
        quantity: quantity ?? this.quantity,
        image: image ?? this.image,
        price: price ?? this.price,
        currency: currency ?? this.currency,
      );

  Items.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    sellerId = json['sellerId'];
    id = json['id'];
    currency = json['currency'];
    name = json['name'];
    color = json['color'];
    size = json['size'];
    quantity = json['quantity'];
    image = json['image'];
    price = json['price'];
    // if (json['variants'] != null) {
    //   variants = <Variants>[];
    //   json['variants'].forEach((v) {
    //     variants!.add(Variants.fromJson(v));
    //   });
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['productId'] = productId;
    data['id'] = id;
    data['sellerId'] = sellerId;
    data['currency'] = currency;
    data['name'] = name;
    data['color'] = color;
    data['size'] = size;
    data['quantity'] = quantity;
    data['price'] = price;
    data['image'] = image;
    // if (variants != null) {
    //   data['variants'] = variants!.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}

class Variants {
  String? color;
  List<Subvariants>? subvariants;

  Variants({this.color, this.subvariants});

  Variants.fromJson(Map<String, dynamic> json) {
    color = json['color'];
    if (json['subvariants'] != null) {
      subvariants = <Subvariants>[];
      json['subvariants'].forEach((v) {
        subvariants!.add(Subvariants.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['color'] = color;
    if (subvariants != null) {
      data['subvariants'] = subvariants!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Subvariants {
  String? size;
  String? qty;
  String? price;

  Subvariants({this.size, this.qty, this.price});

  Subvariants.fromJson(Map<String, dynamic> json) {
    size = json['size'];
    qty = json['qty'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['size'] = size;
    data['qty'] = qty;
    data['price'] = price;
    return data;
  }
}

// !
class Customer {
  String? name;
  Address? address;
  String? phoneNumber;
  String? email;

  Customer({this.name, this.address, this.phoneNumber, this.email});

  Customer.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    address =
        json['address'] != null ? Address.fromJson(json['address']) : null;
    phoneNumber = json['phoneNumber'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    if (address != null) {
      data['address'] = address!.toJson();
    }
    data['phoneNumber'] = phoneNumber;
    data['email'] = email;
    return data;
  }
}

// !
class Address {
  String? streetAddress;
  String? city;
  String? state;
  String? postalCode;
  String? name;
  Address({
    this.streetAddress,
    this.city,
    this.state,
    this.postalCode,
    this.name,
  });

  Address.fromJson(Map<String, dynamic> json) {
    streetAddress = json['streetAddress'];
    name = json['name'];
    city = json['city'];
    state = json['state'];
    postalCode = json['postalCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['streetAddress'] = streetAddress;
    data['city'] = city;
    data['name'] = name;
    data['state'] = state;
    data['postalCode'] = postalCode;
    return data;
  }
}

// Orders demoOrder = Orders(
//   sId: '12',
//   paymetStatus: 'done',
//   date: '2022/02/5',
//   total: '5000',
//   discountedPrice: '522',
//   delivery: '200',
//   currency: 'LKR',
//   items: [
//     Items(
//       name: 'kota gawma',
//       productId: 'fcdce7c0-8388-11ed-8c75-3d328ce0ad6b',
//       sellerId: '',
//       price: '',
//       size: '2XS',
//       quantity: '2',
//       color: '4281100799',
//       currency: '',
//       image: '',
//     ),
//     Items(
//       name: 'kota gawma',
//       productId: 'fcdce7c0-8388-11ed-8c75-3d328ce0ad6b',
//       sellerId: '',
//       price: '',
//       size: 'XS',
//       quantity: '1',
//       color: '4280363631',
//       currency: '',
//       image: '',
//     ),
//   ],
//   customer: Customer(
//     name: 'sudesh bandara',
//     phoneNumber: '075 000 0000',
//     email: 'sudesh@gmail.com',
//     address: Address(
//       postalCode: '22032',
//       state: 'central',
//       city: 'Hatton',
//       streetAddress: 'No 88,Kalaweldeniya road,',
//     ),
//   ),
// );
