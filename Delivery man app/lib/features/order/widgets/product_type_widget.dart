import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resturant_delivery_boy/features/splash/providers/splash_provider.dart';
import 'package:resturant_delivery_boy/localization/language_constrants.dart';
import 'package:resturant_delivery_boy/utill/dimensions.dart';
import 'package:resturant_delivery_boy/utill/styles.dart';

class ProductTypeWidget extends StatelessWidget {
  final String? productType;
  const ProductTypeWidget({super.key, this.productType});

  @override
  Widget build(BuildContext context) {
    bool isActive = Provider.of<SplashProvider>(context, listen: false).configModel?.isVegNonVegActive ?? false;

    return (productType == null || !isActive)  ? const SizedBox() : Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        color: Theme.of(context).primaryColor,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0 ,vertical: 2),
        child: Text(getTranslated(productType, context,
        )!, style: rubikRegular.copyWith(color: Colors.white, fontSize: Dimensions.fontSizeSmall),
        ),
      ),
    );
  }
}