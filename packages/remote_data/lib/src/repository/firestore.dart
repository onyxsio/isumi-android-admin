import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:components/components.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:local_database/local_db.dart';
import 'package:remote_data/src/error/failure.dart';
import 'package:remote_data/src/model/models.dart';
import 'package:uuid/uuid.dart';
import 'storage.dart';

class FireRepo {
  // Get instance of Firebase Firestore
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  // Cerate instance of products Database
  static var productsDB = firestore.collection('products');
// Cerate instance of products Database
  static var sellerDB = firestore.collection('sellers');
  // Stream<QuerySnapshot>
  static var productStream = productsDB.snapshots();
  static var offerDB = firestore.collection('offers');
  static var offerStream = offerDB.snapshots();
  static var customerDB = firestore.collection('customers');
  // Stream<QuerySnapshot>
  // static var orderStream = sellerDB.doc('order').snapshots();
  //

  static Future<bool> isAdmin(String email) async {
    try {
      return await customerDB
          .where('email', isEqualTo: email)
          .get()
          .then((QuerySnapshot snapshot) {
        if (snapshot.docs.isNotEmpty) {
          return false;
        } else {
          return true;
        }
      });
      // return true;
    } on FirebaseException catch (e) {
      throw AppFirebaseFailure.fromCode(e.code);
    } catch (_) {
      return false;
    }
  }

  static Future<void> createAccount(auth.User user) async {
    try {
      String? deviceToken = await FirebaseMessaging.instance.getToken();
      await sellerDB.doc(user.uid).set(demoSeller
          .copyWith(
            email: user.email,
            sId: user.uid,
            deviceToken: deviceToken,
          )
          .toJson());
    } on FirebaseException catch (e) {
      AppFirebaseFailure.fromCode(e.code);
    } catch (_) {}
  }

  Future<void> setupDeviceToken() async {
    try {
      final user = auth.FirebaseAuth.instance.currentUser;
      String? deviceToken = await FirebaseMessaging.instance.getToken();
      sellerDB.doc(user!.uid).get().then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          sellerDB.doc(user.uid).update({'deviceToken': deviceToken});
        }
      });
    } on FirebaseException catch (e) {
      throw AppFirebaseFailure.fromCode(e.code);
    } catch (_) {}
  }

  static Future<void> setupOffers(
      List<Product> products, Offers offers, xfile) async {
    try {
      List productDB = [];
      for (var product in products) {
        await productsDB.doc(product.sId).update({'offers': offers.toJson()});
        productDB.add(product.toJson());
      }

      String offerId = const Uuid().v1();
      String photoUrl = await StorageRepository().uploadImages('offer', xfile);
      await offerDB.doc(offerId).set({
        'banner': photoUrl,
        'valid': offers.expirationDate,
        'products': productDB
      });
    } catch (_) {}
  }

  static Future<void> deleteOffer(String id) async {
    try {
      await offerDB.doc(id).delete();
    } catch (_) {}
  }

// ***
  // static Future<void> getOffers(
  //     List<Product> products, Offers offers, xfile) async {
  //   try {
  //     List productDB = [];
  //     for (var product in products) {
  //       await productsDB.doc(product.sId).update({'offers': offers.toJson()});
  //       productDB.add(product.toJson());
  //     }
  //     // !
  //     String offerId = const Uuid().v1();
  //     String photoUrl = await StorageRepository().uploadImages('offer', xfile);
  //     await offerDB
  //         .doc(offerId)
  //         .set({'banner': photoUrl, 'products': productDB});
  //   } catch (e) {
  //     log(e.toString());
  //   }
  // }
// !
  // static void testqry() async {
  //   try {
  //     for (var item in demoOrder.items!) {
  //       List<Variant> variants = [];
  //       var product = await productsDB
  //           .doc(item.productId)
  //           .get()
  //           .then((snapshot) => Product.fromSnap(snapshot));

  //       for (var v in product.variant!) {
  //         variants.add(v);
  //         if (v.color! == (item.color!)) {
  //           List<Subvariant> subs = [];
  //           for (var s in v.subvariant!) {
  //             subs.add(s);
  //             if (s.size! == (item.size!)) {
  //               variants.remove(v);
  //               subs.remove(s);
  //               var stock = (int.parse(s.stock!) - int.parse(item.quantity!));
  //               subs.add(s.copyWith(stock: stock.toString()));
  //             }
  //           }
  //           variants.add(v.copyWith(subvariant: subs));
  //         }
  //       }

  //       await productsDB
  //           .doc(item.productId)
  //           .update(product.copyWith(variant: variants).toJson());
  //     }
  //   } catch (e) {
  //     log(e.toString());
  //   }
  // }

  static Future<void> orderMoveToDelivered(Orders orders, String id) async {
    try {
      // List<Variant> variants = [];

      await sellerDB.doc(id).collection('orders').doc(orders.sId).delete();
      //
      await sellerDB
          .doc(id)
          .collection('delivered')
          .doc(orders.sId)
          .set(orders.toJson());
      //
      // for (var item in orders.items!) {
      //   List<Variant> variants = [];
      //   var product = await productsDB
      //       .doc(item.productId)
      //       .get()
      //       .then((snapshot) => Product.fromSnap(snapshot));

      //   for (var v in product.variant!) {
      //     variants.add(v);
      //     if (v.color! == (item.color!)) {
      //       List<Subvariant> subs = [];
      //       for (var s in v.subvariant!) {
      //         subs.add(s);
      //         if (s.size! == (item.size!)) {
      //           variants.remove(v);
      //           subs.remove(s);
      //           var stock = (int.parse(s.stock!) - int.parse(item.quantity!));
      //           subs.add(s.copyWith(stock: stock.toString()));
      //         }
      //       }
      //       variants.add(v.copyWith(subvariant: subs));
      //     }
      //   }

      //   await productsDB
      //       .doc(item.productId)
      //       .update(product.copyWith(variant: variants).toJson());
      // }
    } on FirebaseException catch (e) {
      throw AppFirebaseFailure.fromCode(e.code);
    } catch (_) {}
  }

  static Future<Seller> getSeller(String id) async {
    try {
      var seller = await sellerDB.doc(id).get();
      return Seller.fromJsonFirebase(seller);
    } on FirebaseException catch (e) {
      throw AppFirebaseFailure.fromCode(e.code);
    } catch (_) {
      return Seller();
    }
  }

  static Future<void> deleteDelivery(String pId, String uId) async {
    try {
      await sellerDB.doc(uId).collection('delivered').doc(pId).delete();
    } on FirebaseException catch (e) {
      throw AppFirebaseFailure.fromCode(e.code);
    } catch (_) {
      throw const AppFirebaseFailure();
    }
  }

  // Future<void> setupDashboard(Seller dashboard, String id) async {
  //   try {
  //     sellerDB.doc(id).get().then((DocumentSnapshot documentSnapshot) {
  //       if (!documentSnapshot.exists) {
  //         sellerDB.doc(id).set(dashboard.toJson());
  //       }
  //     });
  //   } catch (_) {}
  // }

  //
  // Upload a new Product to products Database
  //
  static Future<void> addProduct(BuildContext context, Product product,
      List<XFile>? images, List<Variant> variants) async {
    // Store Multiple Images urls
    List<String> photoUrls = [];
    final user = auth.FirebaseAuth.instance.currentUser;
    // Set<String> subv = <String>{};
    List minPrice = [];
    // Store sinlgel Images urls
    // String photoUrl = "";
    try {
      // creates unique id based on time
      String productId = const Uuid().v1();
      // Find a minimum price in list
      for (var variant in variants) {
        for (var subvariant in variant.subvariant!) {
          minPrice.add(double.parse(subvariant.price!));
        }
      }
      var minimumPrice = minPrice
          .reduce((value, element) => value < element ? value : element);

      Price price =
          Price(value: minimumPrice.toString(), currency: HiveDB.getCurrency);

      // upload Singel Image to Firestore, and get Url
      // photoUrl = await StorageRepository().uploadImages(productId, xfile);
      Rivews rivews = Rivews(ratingValue: '0', reviewCount: '0');
      // upload Multiple Images to Firestore, and get Urls
      photoUrls = await StorageRepository().uploadFiles(images!, productId);
      var modifiyProduct = product.copyWith(
        sId: productId,
        sellerId: user!.uid,
        thumbnail: photoUrls[0],
        price: price,
        rivews: rivews,
        images: photoUrls,
      );
      await productsDB.doc(productId).set(modifiyProduct.toJson());
      // await sellerDB
      //     .doc(user.uid)
      //     .collection('products')
      //     .doc(productId)
      //     .set(modifiyProduct.toJson());
      // .then((value) =>
      // DialogBoxes.showAutoCloseDialog(context,
      //     type: InfoDialog.successful,
      //     message: 'It was successfully uploaded !'));
    } on FirebaseException catch (e) {
      var msg = AppFirebaseFailure.fromCode(e.code);
      // DialogBoxes.showAutoCloseDialog(context,
      //     type: InfoDialog.error, message: msg.message);
      //  DialogBoxes.showAutoCloseDialog(context);

    } catch (_) {}
  }

//
  static Future<void> updateProduct(
    BuildContext context,
    Product product,
    List<XFile>? images,
    // List<Variant> variant,
    // String discount,
  ) async {
    List photoUrls = [];
    // Set<String> subv = <String>{};
    List minPrice = [];

    try {
      if (images!.isNotEmpty) {
        photoUrls = await StorageRepository().uploadFiles(images, product.sId!);
      }
      for (var image in product.images!) {
        photoUrls.add(image);
      }

      // Find a minimum price in list
      for (var variant in product.variant!) {
        for (var subvariant in variant.subvariant!) {
          minPrice.add(double.parse(subvariant.price!));
        }
      }
      var minimumPrice = minPrice
          .reduce((value, element) => value < element ? value : element);
      Price price =
          Price(value: minimumPrice.toString(), currency: HiveDB.getCurrency);

      var newProduct = product.copyWith(
        thumbnail: photoUrls[0],
        price: price,
        images: photoUrls,
      );

      productsDB.doc(product.sId).update(newProduct.toJson());
      // .then((value) =>
      //     DialogBoxes.showAutoCloseDialog(context,
      //         type: InfoDialog.successful,
      //         message: 'It was successfully updated !'));
    } on FirebaseException catch (e) {
      var msg = AppFirebaseFailure.fromCode(e.code);
      // DialogBoxes.showAutoCloseDialog(context,
      //     type: InfoDialog.error, message: msg.message);
    } catch (_) {
      DBox.autoClose(context,
          type: InfoDialog.error, message: 'An unknown exception occurred.');
    }
  }

  // Delete Product
  static Future<void> deleteProduct(String pId) async {
    try {
      await productsDB.doc(pId).delete();
    } on FirebaseException catch (e) {
      throw AppFirebaseFailure.fromCode(e.code);
    } catch (_) {
      throw const AppFirebaseFailure();
    }
  }
}

// class MyOrder {
//   final List orders;
//   MyOrder({required this.orders});

//   static MyOrder formJson(data) {
//     return MyOrder(orders: data['newOrder']);
//   }

//   Map<String, dynamic> toJson() => {"newOrder": orders};
// }
//
