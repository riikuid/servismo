import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';
import 'package:serpismotor2/models/product_model.dart';
import 'package:serpismotor2/providers/product_provider.dart';
import 'package:serpismotor2/theme.dart';
import 'package:serpismotor2/widgets/service_card.dart';
import 'package:serpismotor2/widgets/service_card_reversed.dart';
import 'package:shimmer/shimmer.dart';

import '../../widgets/skeleton_card.dart';

class ServicePage extends StatefulWidget {
  // const ServicePage({super.key});

  @override
  State<ServicePage> createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
  String searchKeyword = '';
  late bool _isLoading = true;
  bool servis = true;
  @override
  Widget build(BuildContext context) {
    ProductProvider productProvider = Provider.of<ProductProvider>(context);

    loadProduct() async {
      setState(() {
        _isLoading = false;
      });
      await Provider.of<ProductProvider>(context, listen: false).getProducts();
      setState(() {
        _isLoading = true;
      });
    }

    Widget header() {
      return AppBar(
        backgroundColor: backgroundColor1,
        centerTitle: true,
        toolbarHeight: 80,
        title: Text(
          "View All",
          style: primaryTextStyle.copyWith(fontWeight: semibold),
        ),
        elevation: 0,
        automaticallyImplyLeading: false,
      );
    }

    Widget searchBar() {
      return Container(
        margin: EdgeInsets.only(
            right: defaultMargin, left: defaultMargin, bottom: 14),
        height: 50,
        decoration:
            BoxDecoration(borderRadius: BorderRadius.circular(100), boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 2,
              offset: Offset(0, 0))
        ]),
        child: TextField(
          style: primaryTextStyle.copyWith(fontWeight: semibold),
          onChanged: (value) {
            setState(() {
              searchKeyword = value;
            });
          },
          cursorColor: primaryColor,
          decoration: InputDecoration(
            hintText: "Cari kebutuhan kendaraanmu",
            hintStyle: subtitleTextStyle.copyWith(fontWeight: medium),
            contentPadding:
                const EdgeInsets.only(top: 10, bottom: 10, left: 25),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(100),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: whiteColor,
            suffixIcon: Container(
              margin: const EdgeInsets.all(5),
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Icon(
                Icons.search,
                size: 28,
                color: blackColor,
              ),
            ),
          ),
        ),
      );
    }

    shimmerCardLoagin() {
      return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: whiteColor),
        padding: EdgeInsets.all(10),
        child: Shimmer.fromColors(
          child: SkeletonCard(),
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
        ),
      );
    }

    Widget options() {
      return Container(
        margin: EdgeInsets.fromLTRB(defaultMargin, 0, defaultMargin, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      servis = true;
                    });
                  },
                  child: Column(
                    children: [
                      Text(
                        'Service',
                        style: primaryTextStyle.copyWith(
                          fontWeight: servis ? bold : regular,
                          fontSize: 14,
                          color: servis ? primaryColor : secondaryTextColor,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: servis ? 3 : 1.5,
                        color: servis ? primaryColor : secondaryTextColor,
                      )
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      servis = false;
                    });
                  },
                  child: Column(
                    children: [
                      Text(
                        'Spare Part',
                        style: primaryTextStyle.copyWith(
                          fontWeight: servis ? regular : semibold,
                          fontSize: 14,
                          color: servis ? secondaryTextColor : primaryColor,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: servis ? 1.5 : 3,
                        color: servis ? secondaryTextColor : primaryColor,
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      );
    }

    Widget content() {
      return Expanded(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: defaultMargin),
          child: RefreshIndicator(
            onRefresh: () {
              return Future.delayed(Duration(seconds: 1), () {
                setState(() {
                  loadProduct();
                });
              });
            },
            color: primaryColor,
            child: ResponsiveGridList(
              listViewBuilderOptions: ListViewBuilderOptions(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                physics: BouncingScrollPhysics(),
              ),
              minItemWidth: MediaQuery.of(context).size.width / 3.5,
              maxItemsPerRow: 2,
              horizontalGridSpacing: 15,
              rowMainAxisAlignment: MainAxisAlignment.start,
              verticalGridSpacing: 15,
              // verticalGridMargin: 30,
              children: [
                ...productProvider.products
                    .map(
                      (product) => ServiceCardAll(product),
                    )
                    .where((product) =>
                        product.category.id != 1 &&
                        product.category.id != 10 &&
                        product.category.id != 42)
                    .where((product) =>
                        product.product.name
                            .toLowerCase()
                            .contains(searchKeyword.toLowerCase()) ||
                        product.category.name
                            .toLowerCase()
                            .contains(searchKeyword.toLowerCase()))
                    .toList(),
              ],
            ),
          ),
        ),
      );
    }

    Widget contentSparePart() {
      return Expanded(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: defaultMargin),
          child: RefreshIndicator(
            onRefresh: () {
              return Future.delayed(Duration(seconds: 1), () {
                setState(() {
                  loadProduct();
                });
              });
            },
            color: primaryColor,
            child: ResponsiveGridList(
              listViewBuilderOptions: ListViewBuilderOptions(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                physics: BouncingScrollPhysics(),
              ),
              minItemWidth: MediaQuery.of(context).size.width / 3.5,
              maxItemsPerRow: 2,
              horizontalGridSpacing: 15,
              rowMainAxisAlignment: MainAxisAlignment.start,
              verticalGridSpacing: 15,
              // verticalGridMargin: 30,
              children: [
                ...productProvider.products
                    .map(
                      (product) => ServiceCardReversed(product),
                    )
                    .where((product) => product.category.id == 1)
                    .where((product) =>
                        product.product.name
                            .toLowerCase()
                            .contains(searchKeyword.toLowerCase()) ||
                        product.category.name
                            .toLowerCase()
                            .contains(searchKeyword.toLowerCase()))
                    .toList(),
              ],
            ),
          ),
        ),
      );
    }

    Widget loading() {
      return Expanded(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: defaultMargin),
          child: ResponsiveGridList(
            listViewBuilderOptions: ListViewBuilderOptions(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
              physics: NeverScrollableScrollPhysics(),
            ),
            minItemWidth: MediaQuery.of(context).size.width / 3.5,
            maxItemsPerRow: 2,
            horizontalGridSpacing: 15,
            rowMainAxisAlignment: MainAxisAlignment.start,
            verticalGridSpacing: 15,
            // verticalGridMargin: 30,
            children: [
              shimmerCardLoagin(),
              shimmerCardLoagin(),
              shimmerCardLoagin(),
              shimmerCardLoagin(),
              shimmerCardLoagin(),
              shimmerCardLoagin(),
              shimmerCardLoagin(),
              shimmerCardLoagin(),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        header(),
        searchBar(),
        options(),
        _isLoading
            ? servis
                ? content()
                : contentSparePart()
            : loading(),
        // SizedBox(
        //   height: 14,
        // )
      ],
    );
  }
}
