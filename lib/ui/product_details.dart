import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rayhanecommerce/const/appcolor.dart';

class ProductDetails extends StatefulWidget {
  var _product;
  ProductDetails(this._product);

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  @override
  var _dotposition = 0;
  Future addToCart() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;
    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection("users_cart_items");
    return _collectionRef
        .doc(currentUser!.email)
        .collection("items")
        .doc()
        .set({
      "name": widget._product["p_name"],
      "price": widget._product["p_price"],
      "image": widget._product["p_image"],
    }).then((value) => print("Add To Cart"));
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text(
          "Product Details",
          style: TextStyle(color: Colors.black),
        )),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: appcolor.mycolor,
            size: 35,
          ),
        ),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1.5,
              child: CarouselSlider(
                  items: widget._product["p_image"]
                      .map<Widget>((item) => Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                image: NetworkImage(item),
                                fit: BoxFit.fitWidth,
                              )),
                            ),
                          ))
                      .toList(),
                  options: CarouselOptions(
                      autoPlay: true,
                      enlargeCenterPage: true,
                      viewportFraction: 0.8,
                      enlargeStrategy: CenterPageEnlargeStrategy.height,
                      onPageChanged: (val, carouselPageChangedReason) {
                        setState(() {
                          _dotposition = val;
                        });
                      })),
            ),
            SizedBox(
              height: 10.h,
            ),
            Center(
              child: DotsIndicator(
                dotsCount:
                    widget._product.length == 0 ? 1 : widget._product.length,
                position: _dotposition.toDouble(),
                decorator: DotsDecorator(
                  activeColor: appcolor.mycolor,
                  spacing: EdgeInsets.all(2),
                  activeSize: Size(8, 8),
                  size: Size(6, 6),
                  color: appcolor.mycolor.withOpacity(0.5),
                ),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Row(
              children: [
                Text(
                  "\৳ ${widget._product["p_price"].toString()}",
                  style: TextStyle(fontSize: 30.sp),
                ),
                SizedBox(
                  width: 100,
                ),
                ElevatedButton(
                  onPressed: () => addToCart(),
                  child: Text("Add To Cart"),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Text(widget._product["p_name"],
                style: TextStyle(
                  fontSize: 25.sp,
                )),
            SizedBox(
              height: 10,
            ),
            Text(widget._product["p_description"]),
          ],
        ),
      )),
    );
  }
}
