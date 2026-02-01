import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/widgets/custom_button_widget.dart';
import 'package:flutter_restaurant/features/auth/providers/auth_provider.dart';
import 'package:flutter_restaurant/features/cart/widgets/free_delivery_progressbar_widget.dart';
import 'package:flutter_restaurant/features/cart/widgets/guest_checkout_widget.dart';
import 'package:flutter_restaurant/features/checkout/providers/checkout_provider.dart';
import 'package:flutter_restaurant/features/coupon/providers/coupon_provider.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/helper/custom_snackbar_helper.dart';
import 'package:flutter_restaurant/helper/price_converter_helper.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CheckOutButtonWidget extends StatelessWidget {
  const CheckOutButtonWidget({
    super.key,
    required this.orderAmount,
    required this.totalWithoutDeliveryFee,
    required this.isFreeDelivery,
  });

  final double orderAmount;
  final double totalWithoutDeliveryFee;
  final bool isFreeDelivery;

  @override
  Widget build(BuildContext context) {
    final splashProvider = Provider.of<SplashProvider>(context, listen: false);

    return ((splashProvider.configModel?.selfPickup ?? false) || (splashProvider.configModel?.homeDelivery ?? false)) ? Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(Dimensions.radiusDefault),
          topRight: Radius.circular(Dimensions.radiusDefault),
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor,
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [

          FreeDeliveryProgressBarWidget(subTotal: totalWithoutDeliveryFee),

          Container(
            width: Dimensions.webScreenWidth,
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            child: CustomButtonWidget(
              btnTxt: getTranslated('proceed_to_checkout', context), 
              onTap: () => _handleCheckout(context),
            ),
          ),
        ],
      ),
    ) : const SizedBox();
  }

  /// Handles the checkout process based on authentication status
  void _handleCheckout(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    if (authProvider.isLoggedIn()) {
      _proceedToCheckout(context);
    } else {
      _showGuestCheckoutDialog(context);
    }
  }

  /// Validates minimum order and navigates to checkout
  void _proceedToCheckout(BuildContext context) {
    if (!_validateMinimumOrder(context)) return;
    
    final couponProvider = Provider.of<CouponProvider>(context, listen: false);
    final checkoutProvider = Provider.of<CheckoutProvider>(context, listen: false);
    
    RouterHelper.getCheckoutRoute(
      totalWithoutDeliveryFee, 
      'cart',
      couponProvider.code, 
      checkoutProvider.isCutlerySelected,
      isFreeDelivery ? "free_delivery" : ""
    );
  }

  /// Shows guest checkout dialog with login/signup options
  void _showGuestCheckoutDialog(BuildContext context) {
    final couponProvider = Provider.of<CouponProvider>(context, listen: false);
    final checkoutProvider = Provider.of<CheckoutProvider>(context, listen: false);
    
    final checkoutRouteUrl = _buildCheckoutUrl(
      totalWithoutDeliveryFee,
      couponProvider.code,
      checkoutProvider.isCutlerySelected,
      isFreeDelivery,
    );
    
    ResponsiveHelper.showDialogOrBottomSheet(
      context, 
      GuestCheckoutWidget(
        checkoutRoute: checkoutRouteUrl,
        onGuestTap: () => _handleGuestCheckout(context),
      ),
    );
  }

  /// Handles guest checkout after choosing "Continue as Guest"
  void _handleGuestCheckout(BuildContext context) {
    if (!_validateMinimumOrder(context)) return;
    
    context.pop();
    _proceedToCheckout(context);
  }

  /// Validates if order meets minimum order value requirement
  bool _validateMinimumOrder(BuildContext context) {
    final splashProvider = Provider.of<SplashProvider>(context, listen: false);
    final minimumOrderValue = splashProvider.configModel?.minimumOrderValue ?? 0;
    
    if (orderAmount < minimumOrderValue) {
      showCustomSnackBarHelper(
        '${getTranslated('minimum_order_is', context)} '
        '${PriceConverterHelper.convertPrice(minimumOrderValue)}, '
        '${getTranslated('you_have', context)} '
        '${PriceConverterHelper.convertPrice(orderAmount)} '
        '${getTranslated('in_your_cart_please_add_more', context)}'
      );
      return false;
    }
    return true;
  }

  /// Builds checkout route URL with all parameters (without navigating)
  String _buildCheckoutUrl(
    double amount,
    String? couponCode,
    bool isCutlery,
    bool isFreeDelivery,
  ) {
    final encodedAmount = base64Url.encode(utf8.encode(amount.toString()));
    final encodedDeliveryType = base64Url.encode(
      utf8.encode(isFreeDelivery ? "free_delivery" : "")
    );
    
    return '${RouterHelper.checkoutScreen}'
           '?amount=$encodedAmount'
           '&delivery_type=$encodedDeliveryType'
           '&page=cart'
           '&&code=$couponCode'
           '${isCutlery ? '&cutlery=1' : ''}';
  }
}