import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/enums/html_type_enum.dart';
import 'package:flutter_restaurant/common/models/config_model.dart';
import 'package:flutter_restaurant/common/models/qr_code_mode.dart';
import 'package:flutter_restaurant/common/widgets/custom_alert_dialog_widget.dart';
import 'package:flutter_restaurant/common/widgets/map_widget.dart';
import 'package:flutter_restaurant/features/address/domain/models/address_model.dart';
import 'package:flutter_restaurant/features/address/enum/route_tyep_enum.dart';
import 'package:flutter_restaurant/features/address/screens/add_new_address_screen.dart';
import 'package:flutter_restaurant/features/address/screens/address_screen.dart';
import 'package:flutter_restaurant/features/auth/providers/auth_provider.dart';
import 'package:flutter_restaurant/features/auth/screens/create_account_screen.dart';
import 'package:flutter_restaurant/features/auth/screens/login_screen.dart';
import 'package:flutter_restaurant/features/auth/screens/otp_registration_screen.dart';
import 'package:flutter_restaurant/features/auth/screens/send_otp_screen.dart';
import 'package:flutter_restaurant/features/branch/providers/branch_provider.dart';
import 'package:flutter_restaurant/features/branch/screens/branch_list_screen.dart';
import 'package:flutter_restaurant/features/category/domain/category_model.dart';
import 'package:flutter_restaurant/features/category/screens/all_category_screen.dart';
import 'package:flutter_restaurant/features/category/screens/branch_category_screen.dart';
import 'package:flutter_restaurant/features/category/screens/branch_screen.dart';
import 'package:flutter_restaurant/features/category/screens/category_screen.dart';
import 'package:flutter_restaurant/features/chat/screens/chat_screen.dart';
import 'package:flutter_restaurant/features/checkout/screens/checkout_screen.dart';
import 'package:flutter_restaurant/features/checkout/screens/order_successful_screen.dart';
import 'package:flutter_restaurant/features/coupon/screens/coupon_screen.dart';
import 'package:flutter_restaurant/features/dashboard/screens/dashboard_screen.dart';
import 'package:flutter_restaurant/features/force_update/screens/force_update_screen.dart';
import 'package:flutter_restaurant/features/forgot_password/screens/create_new_password_screen.dart';
import 'package:flutter_restaurant/features/forgot_password/screens/forgot_password_screen.dart';
import 'package:flutter_restaurant/features/forgot_password/screens/verification_screen.dart';
import 'package:flutter_restaurant/features/home/enums/product_type_enum.dart';
import 'package:flutter_restaurant/features/home/screens/home_item_screen.dart';
import 'package:flutter_restaurant/features/home/screens/product_image_screen.dart';
import 'package:flutter_restaurant/features/html/screens/html_viewer_screen.dart';
import 'package:flutter_restaurant/features/language/screens/choose_language_screen.dart';
import 'package:flutter_restaurant/features/loyalty_screen/screens/loyalty_screen.dart';
import 'package:flutter_restaurant/features/maintenance/screens/maintenance_screen.dart';
import 'package:flutter_restaurant/features/notification/screens/notification_screen.dart';
import 'package:flutter_restaurant/features/onboarding/screens/onboarding_screen.dart';
import 'package:flutter_restaurant/features/order/domain/models/order_model.dart';
import 'package:flutter_restaurant/features/order/screens/order_details_screen.dart';
import 'package:flutter_restaurant/features/order/screens/order_search_screen.dart';
import 'package:flutter_restaurant/features/order_track/screens/order_tracking_screen.dart';
import 'package:flutter_restaurant/features/order_track/screens/track_map_screen.dart';
import 'package:flutter_restaurant/features/page_not_found/screens/page_not_found_screen.dart';
import 'package:flutter_restaurant/features/payment/screens/order_web_payment.dart';
import 'package:flutter_restaurant/features/payment/screens/payment_screen.dart';
import 'package:flutter_restaurant/features/profile/screens/profile_screen.dart';
import 'package:flutter_restaurant/features/rate_review/screens/rate_review_screen.dart';
import 'package:flutter_restaurant/features/refer_and_earn/screens/refer_and_earn_screen.dart';
import 'package:flutter_restaurant/features/search/screens/search_result_screen.dart';
import 'package:flutter_restaurant/features/search/screens/search_screen.dart';
import 'package:flutter_restaurant/features/setmenu/screens/set_menu_screen.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/features/splash/screens/splash_screen.dart';
import 'package:flutter_restaurant/features/support/screens/support_screen.dart';
import 'package:flutter_restaurant/features/wallet/screens/wallet_screen.dart';
import 'package:flutter_restaurant/features/welcome/screens/welcome_screen.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/main.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:flutter_restaurant/helper/route_guards.dart';
import 'package:flutter_restaurant/helper/route_observer.dart';



enum RouteAction{push, pushReplacement, popAndPush, pushNamedAndRemoveUntil}

class RouterHelper {

  static const String splashScreen = '/splash';
  static const String languageScreen = '/select-language';
  static const String onBoardingScreen = '/on_boarding';
  static const String welcomeScreen = '/welcome';
  static const String loginScreen = '/login';
  static const String verify = '/verify';
  static const String forgotPassScreen = '/forgot-password';
  static const String createNewPassScreen = '/create-new-password';
  static const String createAccountScreen = '/create-account';
  static const String dashboard = '/';
  static const String maintain = '/maintain';
  static const String update = '/update';
  static const String dashboardScreen = '/main';
  static const String searchScreen = '/search';
  static const String searchResultScreen = '/search-result';
  static const String setMenuScreen = '/set-menu';
  static const String allCategoryScreen = '/categories';
  static const String categoryScreen = '/category';
  static const String notificationScreen = '/notification';
  static const String checkoutScreen = '/checkout';
  static const String paymentScreen = '/payment';
  static const String orderSuccessScreen = '/order-completed';
  static const String orderDetailsScreen = '/order-details';
  static const String rateScreen = '/rate-review';
  static const String orderTrackingScreen = '/order-tracking';
  static const String trackMapScreen = '/track-map';
  static const String profileScreen = '/profile';
  static const String addressScreen = '/address';
  static const String mapScreen = '/map';
  static const String addAddressScreen = '/add-address';
  static const String selectLocationScreen = '/select-location';
  static const String chatScreen = '/messages';
  static const String couponScreen = '/coupons';
  static const String supportScreen = '/support';
  static const String termsScreen = '/terms';
  static const String policyScreen = '/privacy-policy';
  static const String aboutUsScreen = '/about-us';
  static const String imageDialog = '/image-dialog';
  static const String menuScreenWeb = '/menu_screen_web';
  static const String homeScreen = '/home';
  static const String orderWebPayment = '/order-web-payment';
  static const String popularItemRoute = '/POPULAR_ITEM_ROUTE';
  static const String returnPolicyScreen = '/return-policy';
  static const String refundPolicyScreen = '/refund-policy';
  static const String cancellationPolicyScreen = '/cancellation-policy';
  static const String wallet = '/wallet-screen';
  static const String referAndEarn = '/refer_and_earn';
  static const String branchListScreen = '/branch-list';
  static const String productImageScreen = '/image-screen';
  static const String qrCategoryScreen = '/qr-category-screen';
  static const String loyaltyScreen = '/loyalty-screen';
  static const String orderSearchScreen = '/order-search';
  static const String branchScreen = '/branch-screen';
  static const String homeItem = '/home-item';
  static const String otpVerification = '/send-otp-verification';
  static const String otpRegistration = '/otp-registration';



  static HistoryUrlStrategy historyUrlStrategy = HistoryUrlStrategy();

  static String getSplashRoute({RouteAction? action}) => _navigateRoute(splashScreen, route: action);
  // static String getSplashAnimationRoute({RouteAction? action}) => _navigateRoute(splashAnimationScreen, route: action);
  static String getLanguageRoute(bool isFromMenu, {RouteAction? action}) => _navigateRoute('$languageScreen?page=${isFromMenu ? 'menu' : 'splash'}', route: action);
  static String getOnBoardingRoute({RouteAction? action}) => _navigateRoute(onBoardingScreen, route: action);
  static String getWelcomeRoute() => _navigateRoute(welcomeScreen, route: RouteAction.pushReplacement);
  static String getLoginRoute({RouteAction? action, String? redirectRoute}) {
    String route = loginScreen;
    final encoded = RedirectValidator.encodeToQueryParam(redirectRoute);
    if (encoded != null) {
      route = '$loginScreen?redirect=$encoded';
    }
    return _navigateRoute(route, route: action);
  }
  static String getForgetPassRoute({String? redirectRoute}) {
    String route = forgotPassScreen;
    final encoded = RedirectValidator.encodeToQueryParam(redirectRoute);
    if (encoded != null) {
      route = '$forgotPassScreen?redirect=$encoded';
    }
    return _navigateRoute(route);
  }
  static String getNewPassRoute(String emailOrPhone, String token, {String? redirectRoute}) {
    final encoded = RedirectValidator.encodeToQueryParam(redirectRoute) ?? '';
    return _navigateRoute('$createNewPassScreen?email_or_phone=${Uri.encodeComponent(emailOrPhone)}&token=$token&redirect=$encoded');
  }
  static String getVerifyRoute(String page, String email,  {String? session, RouteAction? action, String? redirectRoute}) {
    String data = Uri.encodeComponent(jsonEncode(email));
    String authSession = base64Url.encode(utf8.encode(session ?? ''));
    final encoded = RedirectValidator.encodeToQueryParam(redirectRoute) ?? '';
    return _navigateRoute('$verify?page=$page&email=$data&data=$authSession&redirect=$encoded', route: action);
  }

  static String getCreateAccountRoute({String? redirectRoute}) {
    final encoded = RedirectValidator.encodeToQueryParam(redirectRoute) ?? '';
    return _navigateRoute('$createAccountScreen?redirect=$encoded');
  }
  static String getMainRoute({RouteAction? action}) => _navigateRoute(dashboard, route: action);
  static String getMaintainRoute({RouteAction? action}) => _navigateRoute(maintain, route: RouteAction.pushNamedAndRemoveUntil);
  static String getUpdateRoute({RouteAction? action}) => _navigateRoute(update, route: action);
  static String getHomeRoute({RouteAction? action})=> _navigateRoute(homeScreen, route: action);
  static String getDashboardRoute(String page, {RouteAction? action}) => _navigateRoute('$dashboardScreen?page=$page', route: action, requiresAuth: page == 'order' || page == 'favourite');
  static String getSearchRoute() => _navigateRoute(searchScreen);
  static String getSearchResultRoute(String text) {
    return _navigateRoute('$searchResultScreen?text=${Uri.encodeComponent(jsonEncode(text))}');
  }
  static String getSetMenuRoute() => _navigateRoute(setMenuScreen);
  static String getNotificationRoute({bool fromSplash = false, RouteAction? action}) => _navigateRoute('$notificationScreen?from_splash=$fromSplash', route: action);
  static String getCategoryRoute(CategoryModel categoryModel ,{RouteAction? action} ) {
    String imageUrl = base64Url.encode(utf8.encode(categoryModel.bannerImage ?? ''));
    return _navigateRoute('$categoryScreen?id=${categoryModel.id}&name=${categoryModel.name}&img=$imageUrl', route: action);  }

  static String getAllCategoryRoute() => _navigateRoute(allCategoryScreen);

  static String getCheckoutRoute(double? amount, String page, String? code, bool isCutlery, String deliveryType) {
    String amount0= base64Url.encode(utf8.encode(amount.toString()));
    String deliveryTpe = base64Url.encode(utf8.encode(deliveryType));
    return _navigateRoute('$checkoutScreen?amount=$amount0&delivery_type=$deliveryTpe&page=$page&&code=$code${isCutlery ? '&cutlery=1' : ''}');
  }

  static String getPaymentRoute(String url, {bool fromCheckout = true}) {
    return _navigateRoute('$paymentScreen?url=${Uri.encodeComponent(url)}&from_checkout=$fromCheckout');
  }
  static String getOrderDetailsRoute(String? id, {String? phoneNumber, bool fromSplash = false, RouteAction? action}) => _navigateRoute('$orderDetailsScreen?id=$id&phone=${Uri.encodeComponent('$phoneNumber')}&from_splash=$fromSplash', route: action);
  static String getRateReviewRoute({required String orderId, String? phoneNumber}) => _navigateRoute('$rateScreen?id=$orderId&phone=${Uri.encodeComponent('$phoneNumber')}');
  static String getOrderTrackingRoute(int? id, {String? phoneNumber}) => _navigateRoute('$orderTrackingScreen?id=$id&phone=${Uri.encodeComponent('$phoneNumber')}');
  static String getTrackMapScreen({Order? order, int? orderId, int? deliverymanId,}){
    String address= "";
    try{
     if( order != null ){
       List<int> encoded = utf8.encode(jsonEncode(order.toJson()));
       address = base64Encode(encoded);
     }
    }catch(e){
      if (kDebugMode) {
        print(e);
      }
    }
    return _navigateRoute("$trackMapScreen?address=$address&deliveryman=$deliverymanId&order=$orderId");
  }
  static String getProfileRoute({RouteAction action = RouteAction.push}) => _navigateRoute(profileScreen, route: action, requiresAuth: true);
  static String getAddressRoute() => _navigateRoute(addressScreen, requiresAuth: true);
  static String getMapRoute(AddressModel addressModel, {DeliveryAddress? deliveryAddress}) {
    List<int> encoded = utf8.encode(jsonEncode(deliveryAddress != null ? deliveryAddress.toJson() : addressModel.toJson()));
    String data = base64Encode(encoded);
    return _navigateRoute('$mapScreen?address=$data');
  }
  static String getAddAddressRoute({
    required String page,
    required String action,
    required AddressModel addressModel,
    bool? isCurrentLocation = false,
    required RouteTypeEnum routeType,
  }) {
    String data = base64Url.encode(utf8.encode(jsonEncode(addressModel.toJson())));
    return _navigateRoute('$addAddressScreen?page=$page&action=$action&address=$data&is_current_location=$isCurrentLocation&route_type=${routeType.name}', requiresAuthOrGuest: true);
  }
  static String getSelectLocationRoute() => _navigateRoute(selectLocationScreen);
  static String getChatRoute({int? orderId, DeliveryMan? deliveryMan, RouteAction? action, bool fromSplash = false}) {

    String deliveryManData = base64Url.encode(utf8.encode(jsonEncode(deliveryMan?.toJson())));

    return _navigateRoute('$chatScreen?order=$orderId&deliveryman=$deliveryManData&from_splash=$fromSplash', route: action, requiresAuth: true);
  }
  static String getCouponRoute() => _navigateRoute(couponScreen, requiresAuthOrGuest: true);
  static String getSupportRoute() => _navigateRoute(supportScreen);
  static String getTermsRoute() => _navigateRoute(termsScreen);
  static String getPolicyRoute() => _navigateRoute(policyScreen);
  static String getAboutUsRoute() => _navigateRoute(aboutUsScreen);
  static String getPopularItemScreen() => _navigateRoute(popularItemRoute);
  static String getReturnPolicyRoute() => _navigateRoute(returnPolicyScreen);
  static String getCancellationPolicyRoute() => _navigateRoute(cancellationPolicyScreen);
  static String getRefundPolicyRoute() => _navigateRoute(refundPolicyScreen);
  static String getWalletRoute({String? token, String? flag, RouteAction? action}) => _navigateRoute('$wallet?token=$token&&flag=$flag', route: action, requiresAuth: true);
  static String getReferAndEarnRoute() => _navigateRoute(referAndEarn, requiresAuth: true);
  static String getBranchListScreen({RouteAction action = RouteAction.push}) => _navigateRoute(branchListScreen, route: action);
  static String getProductImageScreen({required String image, required String title})  {
   // String productJson = base64Encode(utf8.encode(jsonEncode(product)));
    return _navigateRoute('$productImageScreen?image=$image&title=$title');
  }

  static String getOtpVerificationScreen({String? redirectRoute}) {
    String route = otpVerification;
    final encoded = RedirectValidator.encodeToQueryParam(redirectRoute);
    if (encoded != null) {
      route = '$otpVerification?redirect=$encoded';
    }
    return _navigateRoute(route);
  }
  static String getOtpRegistrationScreen(String? tempToken, String userInput, {String? userName, RouteAction action = RouteAction.pushNamedAndRemoveUntil, String? redirectRoute}){
    String data = '';
    if(tempToken != null && tempToken.isNotEmpty){
      data = Uri.encodeComponent(jsonEncode(tempToken));
    }
    String input = Uri.encodeComponent(jsonEncode(userInput));
    String name = '';
    name = Uri.encodeComponent(jsonEncode(userName ?? ''));
    String redirect = RedirectValidator.encodeToQueryParam(redirectRoute) ?? '';
    return _navigateRoute('$otpRegistration?tempToken=$data&input=$input&userName=$name&redirect=$redirect', route: action);

  }

  static String getQrCategoryScreen({String? qrData}) => _navigateRoute('$qrCategoryScreen?qrcode=$qrData');
  static String getLoyaltyScreen() => _navigateRoute(loyaltyScreen, requiresAuth: true);
  static String getOrderSearchScreen() => _navigateRoute(orderSearchScreen);
  static String getOrderSuccessScreen(String orderId, String statusMessage) => _navigateRoute('$orderSuccessScreen?order_id=$orderId&status=$statusMessage', route: RouteAction.pushReplacement);
  static String getBranchScreen() => _navigateRoute(branchScreen);
  static String getHomeItem({required ProductType productType}) => _navigateRoute('$homeItem?type=${productType.name}');

  static String _navigateRoute(String path, {RouteAction? route = RouteAction.push, bool requiresAuth = false, bool requiresAuthOrGuest = false}) {
    // Show auth dialog for menu clicks if not logged in
    if(requiresAuth && !_isAuthenticated()) {
      _showAuthDialog(path);
      return path;
    }
    
    // Check guest checkout for conditional auth requirement
    if(requiresAuthOrGuest && !_isAuthenticated()) {
      if(_handleGuestCheckoutAuth(path)) {
        return path;
      }
    }

    if(route == RouteAction.pushNamedAndRemoveUntil){
      Get.context?.go(path);

      if(kIsWeb) {
        historyUrlStrategy.replaceState(null, '', '/');
      }

    }else if(route == RouteAction.pushReplacement){
      Get.context?.pushReplacement(path);

    }else{
      Get.context?.push(path);
    }
    return path;
  }

  /// Check if user is authenticated
  static bool _isAuthenticated() {
    final BuildContext? context = Get.context;
    if(context == null) return true;
    
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return authProvider.isLoggedIn();
  }

  /// Handle guest checkout authentication
  /// Returns true if auth dialog was shown, false if guest access is allowed
  static bool _handleGuestCheckoutAuth(String path) {
    final BuildContext? context = Get.context;
    if(context == null) return false;
    
    final splashProvider = Provider.of<SplashProvider>(context, listen: false);
    final isGuestCheckoutEnabled = splashProvider.configModel?.isGuestCheckout == true;
    
    // Show auth dialog only if guest checkout is disabled
    if(!isGuestCheckoutEnabled) {
      _showAuthDialog(path);
      return true;
    }
    
    return false; // Guest checkout enabled, allow access
  }

  /// Get subtitle translation key based on route
  static String _getSubtitleKeyFromRoute(String route) {
    if (route.contains(profileScreen)) {
      return 'login_to_manage_account';
    } else if (route.contains(dashboardScreen) && route.contains('favourite')) {
      return 'login_to_save_favorites';
    } else if (route.contains(dashboardScreen) && route.contains('order')) {
      return 'login_to_track_orders';
    } else if (route.contains(wallet)) {
      return 'login_to_manage_wallet';
    } else if (route.contains(loyaltyScreen)) {
      return 'login_to_view_loyalty_points';
    } else if (route.contains(chatScreen)) {
      return 'login_to_chat';
    } else if (route.contains(addressScreen)) {
      return 'login_to_save_addresses';
    } else if (route.contains(referAndEarn)) {
      return 'login_to_refer_and_earn';
    } else if (route.contains(couponScreen)) {
      return 'login_to_use_coupons';
    } else {
      return 'login_to_get_more_personalized';
    }
  }

  /// Show authentication dialog for menu clicks
  static void _showAuthDialog(String intendedRoute) {
    final BuildContext? context = Get.context;
    if(context == null) return;

    final String subtitleKey = _getSubtitleKeyFromRoute(intendedRoute);

    ResponsiveHelper.showDialogOrBottomSheet(context, CustomAlertDialogWidget(
      leftButtonText: getTranslated('sign_up', context),
      rightButtonText: getTranslated('login', context),
      isHeaderBarExist: true,
      leadingIconWidget: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.lock, color: Colors.white, size: 40),
      ),
      title: getTranslated('login_or_signup', context),
      subTitle: getTranslated(subtitleKey, context),
      onPressLeft: () {
        Navigator.of(context).pop();
        RouterHelper.getCreateAccountRoute(redirectRoute: intendedRoute);
      },
      onPressRight: () {
        Navigator.of(context).pop();
        RouterHelper.getLoginRoute(redirectRoute: intendedRoute);
      },
    ));
  }





  static  Widget _routeHandler(BuildContext context, Widget route,  {bool isBranchCheck = false, required String? path}) {
   return Provider.of<SplashProvider>(context, listen: false).configModel == null
       ? SplashScreen(routeTo: path) : _isMaintenance(Provider.of<SplashProvider>(context, listen: false).configModel!) ? const MaintenanceScreen()
       : (Provider.of<BranchProvider>(context, listen: false).getBranchId() != -1 || !isBranchCheck)
       ?  route : const BranchListScreen();

  }

  static bool _isMaintenance(ConfigModel configModel) {
    if(configModel.maintenanceMode?.maintenanceStatus == 1){
      if( (ResponsiveHelper.isWeb() && configModel.maintenanceMode?.selectedMaintenanceSystem?.webApp == 1) ||
          (!ResponsiveHelper.isWeb() && configModel.maintenanceMode?.selectedMaintenanceSystem?.customerApp == 1)
      ){
        return true;
      }else{
        return false;
      }
    }else{
      return false;
    }
  }

  static String? _getPath(GoRouterState state)=> '${state.fullPath}?${state.uri.query}';

  static final goRoutes = GoRouter(

    navigatorKey: navigatorKey,
    observers: kDebugMode ? [RouteDebugObserver()] : null,
    initialLocation: ResponsiveHelper.isMobilePhone() ? getSplashRoute() : getMainRoute(),
    errorBuilder: (ctx, _) => _routeHandler(ctx, const DashboardScreen(pageIndex: 0), path: '/', isBranchCheck: true),
    routes: [
      GoRoute(path: splashScreen, builder: (context, state) => const SplashScreen()),
      GoRoute(path: maintain, builder: (context, state) => _routeHandler(context, path: _getPath(state), const MaintenanceScreen())),
      GoRoute(path: languageScreen, builder: (context, state) => ChooseLanguageScreen(fromMenu: state.uri.queryParameters['page'] == 'menu')),
      GoRoute(path: onBoardingScreen, builder: (context, state) => OnBoardingScreen()),
      GoRoute(path: welcomeScreen, builder: (context, state) => _routeHandler(context, path: _getPath(state), const WelcomeScreen())),
      GoRoute(
        path: loginScreen,
        redirect: RouteGuards.redirectIfAuthenticated,
        builder: (context, state) {
          final String? redirectRoute = RedirectValidator.decodeFromQueryParam(state.uri.queryParameters['redirect']);
          return _routeHandler(context, path: _getPath(state), LoginScreen(redirectRoute: redirectRoute));
        }
      ),
      GoRoute(
        path: verify,
        redirect: RouteGuards.redirectIfAuthenticated,
        builder: (context, state) {
          return _routeHandler(context, path: _getPath(state), VerificationScreen(
            fromPage: state.uri.queryParameters['page'] ?? '',
            userInput: jsonDecode(state.uri.queryParameters['email'] ?? ''),
            session: state.uri.queryParameters['data'] == 'null'
                ? null
                : utf8.decode(base64Url.decode(state.uri.queryParameters['data'] ?? '')),
            redirectRoute: RedirectValidator.decodeFromQueryParam(state.uri.queryParameters['redirect']),
          ));
        }
      ),
      GoRoute(
        path: forgotPassScreen,
        redirect: RouteGuards.redirectIfAuthenticated,
        builder: (context, state) {
          final String? redirectRoute = RedirectValidator.decodeFromQueryParam(state.uri.queryParameters['redirect']);
          return _routeHandler(context, path: _getPath(state), ForgotPasswordScreen(redirectRoute: redirectRoute));
        }
      ),
      GoRoute(
        path: createNewPassScreen,
        redirect: RouteGuards.redirectIfAuthenticated,
        builder: (context, state) => _routeHandler(context, path: _getPath(state), CreateNewPasswordScreen(
          emailOrPhone: Uri.decodeComponent(state.uri.queryParameters['email_or_phone'] ?? ''),
          resetToken: state.uri.queryParameters['token'],
          redirectRoute: RedirectValidator.decodeFromQueryParam(state.uri.queryParameters['redirect']),
        ))
      ),
      GoRoute(
        path: createAccountScreen,
        redirect: RouteGuards.redirectIfAuthenticated,
        builder: (context, state) => _routeHandler(context, path: _getPath(state),  CreateAccountScreen(
          referralCode: state.uri.queryParameters['referral_code'],
          redirectRoute: RedirectValidator.decodeFromQueryParam(state.uri.queryParameters['redirect']),
        ))
      ),

      GoRoute(
        path: dashboardScreen,
        redirect: (context, state) {
          final page = state.uri.queryParameters['page'];
          // Order and favourite pages require auth
          if (page == 'order' || page == 'favourite') {
            return RouteGuards.requiresAuth(context, state);
          }
          return null; // Other pages are public
        },
        builder: (context, state) {
          return _routeHandler(context, path: _getPath(state), DashboardScreen(
            pageIndex: state.uri.queryParameters['page'] == 'home'
                ? 0 : state.uri.queryParameters['page'] == 'favourite'
                ? 1 : state.uri.queryParameters['page'] == 'cart'
                ? 2 : state.uri.queryParameters['page'] == 'order'
                ? 3 : state.uri.queryParameters['page'] == 'menu'
                ? 4 : 0,
          ), isBranchCheck: state.uri.queryParameters['page'] != 'menu' );
        }
      ),

      GoRoute(path: homeScreen, builder: (context, state) => _routeHandler(context, path: _getPath(state),  const DashboardScreen(pageIndex: 0), isBranchCheck: true)),
      GoRoute(path: dashboard, builder: (context, state) => _routeHandler(context, path: _getPath(state), const DashboardScreen(pageIndex: 0), isBranchCheck: true)),
      GoRoute(path: searchScreen, builder: (context, state) => _routeHandler(context, path: _getPath(state), const SearchScreen())),
      GoRoute(path: searchResultScreen, builder: (context, state) => _routeHandler(
        context, path: _getPath(state), SearchResultScreen(searchString: jsonDecode(state.uri.queryParameters['text'] ?? '')), isBranchCheck: true,
      )),
      GoRoute(path: update, builder: (context, state) => _routeHandler(context, path: _getPath(state), const ForceUpdateScreen())),
      GoRoute(path: setMenuScreen, builder: (context, state) => _routeHandler(context, path: _getPath(state), const SetMenuScreen(), isBranchCheck: true)),
      GoRoute(path: categoryScreen,  builder: (context, state) {
        String image  = utf8.decode(base64Decode(state.uri.queryParameters['img'] ?? ''));

        return _routeHandler(context, path: '${state.fullPath}?${state.uri.query}', CategoryScreen(
          categoryId: state.uri.queryParameters['id']!,
          categoryName: state.uri.queryParameters['name'],
          categoryBannerImage: image,
        ), isBranchCheck: true);
      }),

      GoRoute(path: allCategoryScreen,  builder: (context, state) {
        return _routeHandler(context, path: '${state.fullPath}?${state.uri.query}', const AllCategoryScreen(), isBranchCheck: true);
      }),

      GoRoute(
        path: notificationScreen,
        builder: (context, state) => _routeHandler(context, path: _getPath(state), NotificationScreen(fromSplash: state.uri.queryParameters['from_splash'] == 'true')),
      ),

      GoRoute(
        path: checkoutScreen,
        redirect: RouteGuards.requiresAuthOrGuest,
        builder: (context, state){
          String amount  = '${jsonDecode(utf8.decode(base64Decode(state.uri.queryParameters['amount'] ?? '')))}';
          bool fromCart = state.uri.queryParameters['page'] == 'cart';
          bool isCutlery = state.uri.queryParameters.containsKey('cutlery') && (state.uri.queryParameters['cutlery']?.contains('1') ?? false);

          return _routeHandler(context, path: _getPath(state), (!fromCart ? const PageNotFoundScreen() : CheckoutScreen(
            amount: double.tryParse(amount), cartList: null,
            fromCart: state.uri.queryParameters['page'] == 'cart',
            couponCode: state.uri.queryParameters['code'],
            isCutlery: isCutlery,
            isFreeDelivery: utf8.decode(base64Url.decode('${state.uri.queryParameters['delivery_type']}')) == 'free_delivery',

          )), isBranchCheck: true);
        }
      ),

      GoRoute(path: paymentScreen, builder: (context, state)=> _routeHandler(context, path: _getPath(state), PaymentScreen(
        url: Uri.decodeComponent('${state.uri.queryParameters['url']}'), formCheckout: state.uri.queryParameters['from_checkout'] == 'true',
      ), isBranchCheck: true)),

      GoRoute(path: orderWebPayment, builder: (context, state) =>  _routeHandler(context, path: _getPath(state), OrderWebPayment(token: state.uri.queryParameters['token']), isBranchCheck: true)),
      GoRoute(path: orderDetailsScreen, builder: (context, state) =>  _routeHandler(context, path: _getPath(state), OrderDetailsScreen(
        orderId: int.tryParse(state.uri.queryParameters['id'] ?? ''), orderModel: null,
        fromSplash: state.uri.queryParameters['from_splash'] == 'true',
        phoneNumber: '${state.uri.queryParameters['phone']}' != 'null' && '${state.uri.queryParameters['phone']}' != ''
            ? '+${state.uri.queryParameters['phone']}'.replaceAll('++', '+').replaceAll(' ', '') : null,
      ))),

      GoRoute(path: rateScreen, builder: (context, state) =>  _routeHandler(context, path: _getPath(state), RateReviewScreen(
        orderId: int.parse('${state.uri.queryParameters['id']}'),
        phoneNumber: '${state.uri.queryParameters['phone']}' != 'null' && '${state.uri.queryParameters['phone']}' != ''
            ? '${state.uri.queryParameters['phone']}' : null,
      ))),
      GoRoute(path: orderTrackingScreen, builder: (context, state) => _routeHandler(context, path: _getPath(state), OrderTrackingScreen(
        orderID: state.uri.queryParameters['id'] == 'null' ? null : state.uri.queryParameters['id'],
        phoneNumber: '${state.uri.queryParameters['phone']}' != 'null' && '${state.uri.queryParameters['phone']}' != '' ? '${state.uri.queryParameters['phone']}' : null,
      ))),

      GoRoute(path: trackMapScreen , builder: (context, state) {
        Order? data;
        List<int> decode = base64Decode('${state.uri.queryParameters['address']?.replaceAll(' ', '+')}');
        data = Order.fromJson(jsonDecode(utf8.decode(decode)));
        return _routeHandler(context, path: _getPath(state),  TrackMapScreen(
          order: data,
          deliverymanId: int.tryParse(state.uri.queryParameters['deliveryman'].toString()),
          orderId:  int.tryParse(state.uri.queryParameters['order'].toString()),
        ));
      }),
      GoRoute(
        path: profileScreen,
        redirect: RouteGuards.requiresAuth,
        builder: (context, state) => _routeHandler(context, path: _getPath(state),  const ProfileScreen())
      ),
      GoRoute(
        path: addressScreen,
        redirect: RouteGuards.requiresAuth,
        builder: (context, state) => _routeHandler(context, path: _getPath(state),  const AddressScreen())
      ),
      GoRoute(path: mapScreen, builder: (context, state) {
        List<int> decode = base64Decode('${state.uri.queryParameters['address']?.replaceAll(' ', '+')}');
        DeliveryAddress data = DeliveryAddress.fromJson(jsonDecode(utf8.decode(decode)));
        return _routeHandler(context, path: _getPath(state),  MapWidget(address: data));
      }),

      GoRoute(
        redirect: RouteGuards.requiresAuthOrGuest,
        path: addAddressScreen,
        builder: (context, state) {
          bool isUpdate = state.uri.queryParameters['action'] == 'update';
          AddressModel? addressModel;

          if(isUpdate) {
            String decoded = utf8.decode(base64Url.decode('${state.uri.queryParameters['address']?.replaceAll(' ', '+')}'));
            addressModel = AddressModel.fromJson(jsonDecode(decoded));
          }

          final RouteTypeEnum routeType = RouteTypeEnumExtension.fromString(state.uri.queryParameters['route_type'] ?? '');

          return _routeHandler(context, path: _getPath(state), AddNewAddressScreen(
            fromCheckout: state.uri.queryParameters['page'] == 'checkout',
            isEnableUpdate: isUpdate,
            address: isUpdate ? addressModel : null,
            isCurrentLocation: state.uri.queryParameters['is_current_location']?.contains('true') ?? false,
            routeType: routeType,
          ));
        },
      ),

      GoRoute(
        path: chatScreen,
        redirect: RouteGuards.requiresAuth,
        builder: (context, state) {
          DeliveryMan? deliveryMan;
          try{
            deliveryMan = DeliveryMan.fromJson(jsonDecode(utf8.decode(base64Url.decode('${state.uri.queryParameters['deliveryman']?.replaceAll(' ', '+')}')))); 
          }catch(error){
            debugPrint('route- order_model - $error');
          }
          return _routeHandler(context, path: _getPath(state),  ChatScreen(
            orderId : int.tryParse('${state.uri.queryParameters['order']}'),
            fromSplash: state.uri.queryParameters['from_splash'] == 'true',
            deliveryManModel: deliveryMan,
          ));
        }
      ),

      GoRoute(
        path: couponScreen,
        redirect: RouteGuards.requiresAuthOrGuest,
        builder: (context, state) => _routeHandler(context, path: _getPath(state), const CouponScreen()),
      ),
      GoRoute(path: supportScreen, builder: (context, state) => const SupportScreen()),
      GoRoute(path: termsScreen, builder: (context, state) => const HtmlViewerScreen(htmlType: HtmlType.termsAndCondition)),
      GoRoute(path: policyScreen, builder: (context, state) => const HtmlViewerScreen(htmlType: HtmlType.privacyPolicy)),
      GoRoute(path: aboutUsScreen, builder: (context, state) => const HtmlViewerScreen(htmlType: HtmlType.aboutUs)),
      GoRoute(path: refundPolicyScreen, builder: (context, state) => const HtmlViewerScreen(htmlType: HtmlType.refundPolicy)),
      GoRoute(path: cancellationPolicyScreen, builder: (context, state) => const HtmlViewerScreen(htmlType: HtmlType.cancellationPolicy)),
      GoRoute(path: returnPolicyScreen, builder: (context, state) => _routeHandler(context, path: _getPath(state), const HtmlViewerScreen(htmlType: HtmlType.returnPolicy))),
      // GoRoute(path: popularItemRoute, builder: (context, state) => _routeHandler(context, path: _getPath(state), const PopularItemScreen(), isBranchCheck: true)),
      GoRoute(
        path: wallet,
        redirect: RouteGuards.requiresAuth,
        builder: (context, state) => _routeHandler(context, path: _getPath(state),  WalletScreen(
          token: state.uri.queryParameters['token'], status: state.uri.queryParameters['flag'],
        ))
      ),
      
      GoRoute(
        path: referAndEarn,
        redirect: RouteGuards.requiresAuth,
        builder: (context, state) => _routeHandler(context, path: _getPath(state),  const ReferAndEarnScreen())
      ),
      GoRoute(path: branchListScreen, builder: (context, state) => _routeHandler(context, path: _getPath(state),  const BranchListScreen())),
      GoRoute(path: productImageScreen, builder: (context, state){
        String ? image = state.uri.queryParameters['image'];
        String ? title = state.uri.queryParameters['title'];

        //final productJson = jsonDecode(utf8.decode(base64Url.decode('${state.uri.queryParameters['product']?.replaceAll(' ', '+')}')));
        return _routeHandler(context, path: _getPath(state), ProductImageScreen(image: image, title: title,), isBranchCheck: true);
      }),
      GoRoute(path: qrCategoryScreen, builder: (context, state){
        return Provider.of<SplashProvider>(context, listen: false).configModel == null ? SplashScreen(routeTo: '$qrCategoryScreen?qrcode=${state.uri.queryParameters['qrcode']}') :
        BranchCategoryScreen(
          qrCodeModel: '${state.uri.queryParameters['qrcode']}' == 'null' ? null :  QrCodeModel.fromMap(jsonDecode(utf8.decode(base64Url.decode('${state.uri.queryParameters['qrcode']?.replaceAll(' ', '+')}')))),
        );
      }),
      GoRoute(
        path: loyaltyScreen,
        redirect: RouteGuards.requiresAuth,
        builder: (context, state) => _routeHandler(context, path: _getPath(state),  const LoyaltyScreen())
      ),
      GoRoute(path: orderSearchScreen, builder: (context, state) => _routeHandler(context, path: _getPath(state),  const OrderSearchScreen())),

      GoRoute(path: qrCategoryScreen, builder: (context, state) => Provider.of<SplashProvider>(context, listen: false).configModel == null ? SplashScreen(routeTo: getQrCategoryScreen(qrData: state.uri.queryParameters['qrcode'])) : BranchCategoryScreen(
        qrCodeModel: '${state.uri.queryParameters['qrcode']}' == 'null' ? null :  QrCodeModel.fromMap(jsonDecode(utf8.decode(base64Url.decode(state.uri.queryParameters['qrcode']!.replaceAll(' ', '+'))))),
      )),

      GoRoute(path: orderSuccessScreen, builder: (context, state) {
        int status = (state.uri.queryParameters['status'] == 'success' || state.uri.queryParameters['status'] == 'payment-success')
            ? 0 : state.uri.queryParameters['status'] == 'payment-fail'
            ? 1 : state.uri.queryParameters['status'] == 'order-fail' ?  2 : 3;
        return _routeHandler(context, path: _getPath(state), OrderSuccessfulScreen(orderID: state.uri.queryParameters['order_id'], status: status), isBranchCheck: true);
      }),

      GoRoute(path: orderSuccessScreen, builder: (context, state)=> _routeHandler(context, path: _getPath(state), OrderWebPayment(token: state.uri.queryParameters['token']), isBranchCheck: true)),

      GoRoute(path: branchScreen, builder: (context, state)=> _routeHandler(context, path: _getPath(state),  const BranchScreen())),
      GoRoute(path: homeItem, builder: (context, state){
        return _routeHandler(context, path: _getPath(state),   HomeItemScreen(productType: ProductType.values.byName(state.uri.queryParameters['type']!)));
      }),

      GoRoute(
        path: otpVerification,
        redirect: RouteGuards.redirectIfAuthenticated,
        builder: (context, state) {
          final String? redirectRoute = RedirectValidator.decodeFromQueryParam(state.uri.queryParameters['redirect']);
          return SendOtpScreen(redirectRoute: redirectRoute);
        }
      ),

      GoRoute(
        path: otpRegistration,
        redirect: RouteGuards.redirectIfAuthenticated,
        builder: (context, state) {
          final String? redirectRoute = RedirectValidator.decodeFromQueryParam(state.uri.queryParameters['redirect']);
          return _routeHandler(context, path: _getPath(state), OtpRegistrationScreen(
            tempToken: jsonDecode(state.uri.queryParameters['tempToken'] ?? ''),
            userInput: jsonDecode(state.uri.queryParameters['input'] ?? ''),
            userName: jsonDecode(state.uri.queryParameters['userName'] ?? ''),
            redirectRoute: redirectRoute,
          ));
        }
      ),


    ],
  );

  static void forceGoToBack(BuildContext context) {
    if(context.canPop()) {
      context.pop();
    }else {
      RouterHelper.getMainRoute(action: RouteAction.pushNamedAndRemoveUntil);

    }
  }
}


class HistoryUrlStrategy extends PathUrlStrategy {
  @override
  void pushState(Object? state, String title, String url) => replaceState(state, title, url);
}


