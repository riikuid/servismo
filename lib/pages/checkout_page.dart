import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:serpismotor2/providers/cart_provider.dart';
import 'package:serpismotor2/theme.dart';
import 'package:serpismotor2/widgets/checkout_card.dart';

class CheckoutPage extends StatefulWidget {
  CheckoutPage({Key? key}) : super(key: key);

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  TextEditingController nameServiceController = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    CartProvider cartProvider = Provider.of<CartProvider>(context);

    Widget header() {
      return AppBar(
        backgroundColor: backgroundColor1,
        centerTitle: true,
        toolbarHeight: 80,
        title: Text(
          "Save Details",
          style: primaryTextStyle.copyWith(fontWeight: semibold),
        ),
        elevation: 0,
        automaticallyImplyLeading: false,
      );
    }

    Widget content() {
      return Expanded(
        child: ListView(
          padding: EdgeInsets.symmetric(
            horizontal: defaultMargin,
          ),
          children: [
            //INPUT SERVICE LIST NAME
            Container(
              margin: EdgeInsets.only(
                top: defaultMargin,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Service List Name',
                    style: primaryTextStyle.copyWith(
                      fontSize: 16,
                      fontWeight: medium,
                    ),
                  ),
                  SizedBox(
                    height: 14,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: TextField(
                        controller: nameServiceController,
                        cursorColor: primaryColor,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 20),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: primaryColor,
                              )),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          hintText: 'Enter your service list name',
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            // LIST ITEMS
            Container(
              margin: EdgeInsets.only(
                top: defaultMargin,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'List Items',
                    style: primaryTextStyle.copyWith(
                      fontSize: 16,
                      fontWeight: medium,
                    ),
                  ),
                  ...cartProvider.carts
                      .map((cart) => CheckoutCard(cart))
                      .toList()
                ],
              ),
            ),

            //note : summary
            Container(
              margin: EdgeInsets.only(
                top: defaultMargin,
              ),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Summary',
                    style: primaryTextStyle.copyWith(
                      fontSize: 16,
                      fontWeight: medium,
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Quantity',
                        style: secondaryTextStyle.copyWith(
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        '${cartProvider.totalItem()} Items',
                        style: primaryTextStyle.copyWith(
                          fontWeight: medium,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Price',
                        style: secondaryTextStyle.copyWith(
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        NumberFormat.currency(
                          locale:
                              'id', // sesuaikan dengan locale yang diinginkan
                          symbol: '',
                          decimalDigits: 0, // jumlah digit dibelakang koma
                        ).format(cartProvider.totalPrice()),
                        style: priceTextStyle.copyWith(
                          fontWeight: medium,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Divider(
                    thickness: 1,
                    color: Color(0xff2E3141),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total',
                        style: priceTextStyle.copyWith(
                          fontWeight: semibold,
                        ),
                      ),
                      Text(
                        NumberFormat.currency(
                          locale:
                              'id', // sesuaikan dengan locale yang diinginkan
                          symbol: 'Rp. ',
                          decimalDigits: 0, // jumlah digit dibelakang koma
                        ).format(cartProvider.totalPrice()),
                        style: priceTextStyle.copyWith(
                          fontWeight: semibold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Container(
              height: 50,
              width: double.infinity,
              margin: EdgeInsets.symmetric(
                vertical: defaultMargin,
              ),
              child: TextButton(
                onPressed: () {
                  if (nameServiceController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: alertColor,
                        content: Text(
                          'Service list name must not empty',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  } else {
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/checkout-success', (route) => false);
                  }
                },
                style: TextButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Save Now',
                  style: primaryTextStyle.copyWith(
                    fontSize: 16,
                    fontWeight: semibold,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor1,
      floatingActionButton: Padding(
        padding: EdgeInsets.only(top: 14),
        child: FloatingActionButton(
          heroTag: null,
          mini: true,
          onPressed: () {
            Navigator.pop(context);
          },
          child: Image.asset(
            "assets/icon_back.png",
            color: blackColor,
            height: 18,
          ),
          backgroundColor:
              primaryColor, // sesuaikan dengan warna yang diinginkan
          shape: CircleBorder(),
          elevation: 1,
          // set shape menjadi CircleBorder
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      body: Column(
        children: [header(), content()],
      ),
    );
  }
}
