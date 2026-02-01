import 'dart:async';
import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/widgets/custom_app_bar_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_button_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_pop_scope_widget.dart';
import 'package:flutter_restaurant/common/widgets/footer_widget.dart';
import 'package:flutter_restaurant/common/widgets/web_app_bar_widget.dart';
import 'package:flutter_restaurant/features/address/providers/location_provider.dart';
import 'package:flutter_restaurant/features/branch/providers/branch_provider.dart';
import 'package:flutter_restaurant/features/branch/widgets/branch_card_widget.dart';
import 'package:flutter_restaurant/features/branch/widgets/branch_close_widget.dart';
import 'package:flutter_restaurant/features/branch/widgets/branch_item_card_widget.dart';
import 'package:flutter_restaurant/features/branch/widgets/branch_shimmer_widget.dart';
import 'package:flutter_restaurant/features/cart/providers/cart_provider.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/helper/branch_helper.dart';
import 'package:flutter_restaurant/helper/custom_snackbar_helper.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/main.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class BranchListScreen extends StatefulWidget {
  const BranchListScreen({super.key});

  @override
  State<BranchListScreen> createState() => _BranchListScreenState();
}

class _BranchListScreenState extends State<BranchListScreen> {
  // List<BranchValue> _branchesValue = [];
  Set<Marker> _markers = HashSet<Marker>();
  late GoogleMapController _mapController;
  LatLng? _currentLocationLatLng;
  AutoScrollController? scrollController;

  @override
  void initState() {

    super.initState();

    _onInit();
  }


  @override
  void dispose() {
    super.dispose();
  }
// middle
  @override
  Widget build(BuildContext context) {
    final CartProvider cartProvider = Provider.of<CartProvider>(context, listen: false);

    final double height = MediaQuery.sizeOf(context).height;
    final bool isDesktop = ResponsiveHelper.isDesktop(context);

    return Consumer<SplashProvider>(builder: (ctx,splashProvider,_){
      return Consumer<BranchProvider>(builder: (context, branchProvider, _) {
        return CustomPopScopeWidget(
          isExit: isExit(branchProvider, context),
          onPopInvoked: () {
            if (branchProvider.branchTabIndex != 0) {
              branchProvider.updateTabIndex(0, isUpdate: !kIsWeb);
            }
          },
          child: Scaffold(
            appBar: (isDesktop ? const PreferredSize(preferredSize: Size.fromHeight(100), child: WebAppBarWidget())
                : CustomAppBarWidget(
              context: context,
              title: getTranslated('select_branch', context), //leading
              centerTitle: false,
              isBackButtonExist: true,
              onBackPressed: () {
                if(branchProvider.branchTabIndex == 1) {
                  branchProvider.updateTabIndex(0);

                }else {
                  if(context.canPop()) {
                    context.pop();
                  }
                }
              },
            )) as PreferredSizeWidget?,
            body: splashProvider.getActiveBranch() == 0 ? const BranchCloseWidget() : Column(children: [
              Expanded(child: SingleChildScrollView(
                child: Column(children: [
                  Container(width: Dimensions.webScreenWidth,
                    constraints: BoxConstraints(minHeight: !isDesktop && height < 600 ? height : height - 400),
                    child: Column(children: [




                      /// Common title section for both tab index 0 and 1
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: Dimensions.paddingSizeDefault),
                        child: Column(children: [

                          /// for Nearest Branch top bar
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: getTranslated('nearest_branch', context),
                                    style: rubikBold,
                                  ),
                                  TextSpan(
                                    text: ' (${branchProvider.branchValueList?.length ?? 0})',
                                    style: rubikBold.copyWith(color: Theme.of(context).textTheme.titleLarge?.color?.withValues(alpha: 0.7)),
                                  ),
                                ],
                              ),
                            ),



                            if(splashProvider.configModel?.googleMapStatus == 1)
                              _MapGridToggleButton(
                                currentTabIndex: branchProvider.branchTabIndex,
                                onTap: () => branchProvider.updateTabIndex(branchProvider.branchTabIndex == 0 ? 1 : 0),
                              ),
                          ]),

                         if(ResponsiveHelper.isDesktop(context)) Padding(
                            padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
                            child: Row(
                              children: [
                                Text(getTranslated('select_branch', context)!, style: rubikBold.copyWith(
                                  color: Theme.of(context).primaryColor,
                                )),
                              ],
                            ),
                          ),

                        ]),
                      ),

                      /// Map section - only for tab index 1
                      if(branchProvider.branchTabIndex == 1) ...[
                        if(isDesktop) Container(
                          color: Theme.of(context).hintColor.withValues(alpha:0.02),
                          padding: const EdgeInsets.only(
                            left: Dimensions.paddingSizeSmall,
                            right: Dimensions.paddingSizeSmall,
                            // top: Dimensions.paddingSizeLarge,
                          ),
                          height: height - 400,
                          child: Row(children: [
                            Expanded(flex: 3, child: ScrollConfiguration(
                              behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                              child: ListView.separated(
                                separatorBuilder: (context, index){
                                  return const SizedBox(height: Dimensions.paddingSizeDefault);
                                },
                                itemCount: branchProvider.branchValueList?.length ?? 0,
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) => BranchItemCardWidget(
                                  branchesValue: branchProvider.branchValueList?[index],
                                  onTap: ()=> _setMarkers(index, branchProvider, fromBranchSelect: true),
                                ),
                              ),
                            )),

                            const SizedBox(width: Dimensions.paddingSizeDefault),

                            Expanded(flex: 7, child: Padding(
                              padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeLarge),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                child: GoogleMap(
                                  mapType: MapType.normal,
                                  initialCameraPosition: CameraPosition(
                                    target: LatLng(
                                      branchProvider.branchValueList?[0].branches?.latitude ??  0,
                                      branchProvider.branchValueList?[0].branches?.longitude ?? 0,
                                    ), zoom: 5,
                                  ),
                                  minMaxZoomPreference: const MinMaxZoomPreference(0, 16),
                                  zoomControlsEnabled: true,
                                  markers: _markers,
                                  onMapCreated: (GoogleMapController controller) async {
                                    _mapController = controller;
                                    _setMarkers(1, branchProvider);
                                  },
                                ),
                              ),
                            )),
                          ]),
                        ) else SizedBox(height: height - 170, child: Stack(children: [
                          GoogleMap(
                            mapType: MapType.normal,
                            initialCameraPosition: CameraPosition(
                              target: LatLng(
                                branchProvider.branchValueList?[0].branches?.latitude ?? 0,
                                branchProvider.branchValueList?[0].branches?.longitude ??  0,
                              ), zoom: 5,
                            ),
                            minMaxZoomPreference: const MinMaxZoomPreference(0, 16),
                            zoomControlsEnabled: true,
                            markers: _markers,
                            onMapCreated: (GoogleMapController controller) async {
                              await Geolocator.requestPermission();
                              _mapController = controller;
                              _setMarkers(1, branchProvider);
                            },
                          ),

                          Positioned.fill(child: Align(alignment: Alignment.bottomCenter, child: Padding(
                            padding: const EdgeInsets.only(bottom: 100),
                            child: SizedBox(
                              height: 150,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: branchProvider.branchValueList?.length,
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) => Padding(
                                  padding: EdgeInsets.only(
                                    left: Dimensions.paddingSizeLarge, bottom: Dimensions.paddingSizeLarge,
                                    right: index == (branchProvider.branchValueList?.length ?? 0) - 1 ? Dimensions.paddingSizeLarge : 0,
                                  ),
                                  child: BranchCardWidget(
                                    branchModel: branchProvider.branchValueList?[index],
                                    branchModelList: branchProvider.branchValueList,
                                    onTap: ()=> _setMarkers(index, branchProvider, fromBranchSelect: true),
                                  ),
                                ),
                              ),
                            ),
                          ))),
                        ])),
                      ],

                      /// Grid section - only for tab index 0
                      if(branchProvider.branchTabIndex == 0) Container(
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                        child: Column(children: [
                          const SizedBox(height: Dimensions.paddingSizeDefault),

                          (branchProvider.branchValueList?.isNotEmpty ?? false) ? GridView.builder(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisSpacing: isDesktop ? Dimensions.paddingSizeLarge : Dimensions.paddingSizeDefault,
                              mainAxisSpacing: isDesktop ? Dimensions.paddingSizeExtraLarge : Dimensions.paddingSizeDefault,
                              // childAspectRatio: 2,
                              mainAxisExtent: isDesktop ? 190 : 180,
                              crossAxisCount: isDesktop ? 3 : ResponsiveHelper.isTab(context) ? 2 : 1,
                            ),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: branchProvider.branchValueList?.length,
                            itemBuilder: (context, index) => BranchItemCardWidget(
                              branchesValue: branchProvider.branchValueList?[index],
                            ),
                          ) : GridView.builder(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisSpacing: Dimensions.paddingSizeDefault,
                              mainAxisSpacing: isDesktop ? Dimensions.paddingSizeExtraSmall : 0.01,
                              childAspectRatio: 2,
                              crossAxisCount: isDesktop ? 3 : ResponsiveHelper.isTab(context) ? 2 : 1,
                            ),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: 5,
                            itemBuilder: (context, index) => BranchShimmerCardWidget(isEnabled: (branchProvider.branchValueList?.isEmpty ?? true)),
                          ),

                        ]),
                      ),

                      /// for Branch select button web
                      if(isDesktop)
                        _BranchSelectButtonWidget(cartProvider: cartProvider),

                    ]),
                  ),

                  if(isDesktop) const FooterWidget(),
                ]),
              )),

              /// for Branch select button
              if(!isDesktop)
                _BranchSelectButtonWidget(cartProvider: cartProvider),
            ]),
          ),
        );
      });
    });
  }

  bool isExit(BranchProvider branchProvider, BuildContext context) => branchProvider.branchTabIndex == 0
      && (context.canPop() ||
          (GoRouter.of(context).state.uri.path == RouterHelper.dashboard
              || GoRouter.of(context).state.uri.path == RouterHelper.dashboardScreen));



  Future<void> _onInit() async {
    final BranchProvider branchProvider = Provider.of<BranchProvider>(Get.context!, listen: false);
    
    // Initialize current location with proper error handling
    await _initializeCurrentLocation();

    branchProvider.updateTabIndex(0, isUpdate: false);
    ///if need to previous selection
    if(branchProvider.getBranchId() == -1) {
      branchProvider.updateBranchId(null, isUpdate: false);
    } else{
      branchProvider.updateBranchId(branchProvider.getBranchId(), isUpdate: false);
    }

    if(branchProvider.branchValueList == null && mounted){
      await branchProvider.getBranchValueList(context);
    }

    scrollController = AutoScrollController(
      viewportBoundaryGetter: () => Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
      axis: Axis.horizontal,
    );
  }

  /// Initialize current location using LocationProvider (same as BranchProvider)
  Future<void> _initializeCurrentLocation() async {
    if (!mounted) return;
    
    try {
      // Request location permission first
      await Geolocator.requestPermission();

      if (!mounted) return;


      // Use LocationProvider's getCurrentLatLong() method (same as BranchProvider uses)
      final LocationProvider locationProvider = Provider.of<LocationProvider>(context, listen: false);
      
      await locationProvider.getCurrentLatLong().then((latLong) {
        if (latLong != null && mounted) {
          _currentLocationLatLng = latLong;
          
          if (kDebugMode) {
            debugPrint('Current location initialized: ${latLong.latitude}, ${latLong.longitude}');
          }
        } else {
          if (kDebugMode) {
            debugPrint('Current location is null - permission may be denied or service disabled');
          }
        }
      });
      
    } catch (e) {
      // Handle any errors from permission request or location retrieval
      if (kDebugMode) {
        debugPrint('Error initializing current location: $e');
      }
    }
  }


  void _setMarkers(int selectedIndex, BranchProvider branchProvider, {bool fromBranchSelect = false}) async {
    await scrollController!.scrollToIndex(selectedIndex, preferPosition: AutoScrollPosition.middle);
    await scrollController!.highlight(selectedIndex);

    late BitmapDescriptor bitmapDescriptor;
    late BitmapDescriptor bitmapDescriptorUnSelect;
    late BitmapDescriptor currentLocationDescriptor;

    await BitmapDescriptor.asset(const ImageConfiguration(size: Size(35, 60)), Images.restaurantMarker).then((marker) {
      bitmapDescriptor = marker;
    });

    await BitmapDescriptor.asset(const ImageConfiguration(size: Size(25, 40)), Images.restaurantMarkerUnselect).then((marker) {
      bitmapDescriptorUnSelect = marker;
    });

    await BitmapDescriptor.asset(const ImageConfiguration(size: Size(30, 50)), Images.currentLocationMarker).then((marker) {
      currentLocationDescriptor = marker;
    });

    // Marker
    _markers = HashSet<Marker>();
    for(int index=0; index < (branchProvider.branchValueList?.length ?? 0); index++) {

      _markers.add(Marker(
        onTap: () async {
          if(branchProvider.branchValueList?[index].branches?.status ?? false) {
            Provider.of<BranchProvider>(context, listen: false).updateBranchId(branchProvider.branchValueList?[index].branches!.id);
          }},
        markerId: MarkerId('branch_$index'),
        position: LatLng(
          branchProvider.branchValueList?[index].branches?.latitude ?? 0,
          branchProvider.branchValueList?[index].branches?.longitude ?? 0,
        ),
        infoWindow: InfoWindow( title: branchProvider.branchValueList?[index].branches?.name, snippet:branchProvider.branchValueList?[index].branches?.address),
        visible: branchProvider.branchValueList?[index].branches?.status ?? false,
        icon: selectedIndex == index ? bitmapDescriptor : bitmapDescriptorUnSelect,
      ));
    }
    if(_currentLocationLatLng != null) {
      _markers.add(Marker(
        markerId: const MarkerId('current_location'),
        position: _currentLocationLatLng!,
        infoWindow: InfoWindow(title: getTranslated('current_location', Get.context!), snippet: ''),
        icon: currentLocationDescriptor,
      ));
    }

    _mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: _currentLocationLatLng != null && !fromBranchSelect ? _currentLocationLatLng! : LatLng(
        branchProvider.branchValueList?[selectedIndex].branches?.latitude ?? 0,
        branchProvider.branchValueList?[selectedIndex].branches?.longitude ?? 0,
      ),
      zoom: ResponsiveHelper.isMobile() ? 12 : 16,
    )));

    if(mounted){
      setState(() {});
    }
  }

}

class _BranchSelectButtonWidget extends StatelessWidget {
  const _BranchSelectButtonWidget({required this.cartProvider});
  
  final CartProvider cartProvider;

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = ResponsiveHelper.isDesktop(context);


    return Container(
      width: isDesktop ? 400 : Dimensions.webScreenWidth,
      padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
      child: Consumer<BranchProvider>(builder: (context, branchProvider, _) => CustomButtonWidget(
        btnTxt: getTranslated(branchProvider.selectedBranchId == null ? 'select_branch' : 'confirm_branch', context),
        borderRadius: Dimensions.radiusDefault,
        onTap: branchProvider.selectedBranchId == null ? null : () {

          if(branchProvider.selectedBranchId != branchProvider.getBranchId() && cartProvider.cartList.isNotEmpty) {
            BranchHelper.dialogOrBottomSheet(
              context,
              onPressRight: (){
                BranchHelper.setBranch(context);
                cartProvider.getCartData(context);
                },
            );
          }

          else{
            if(branchProvider.getBranchId() == -1){
              if(branchProvider.branchTabIndex != 0) {
                branchProvider.updateTabIndex(0, isUpdate: false);
              }
              BranchHelper.setBranch(context);
              cartProvider.getCartData(context);
            }else if(branchProvider.selectedBranchId  == branchProvider.getBranchId()){
              showCustomSnackBarHelper(getTranslated('this_is_your_current_branch', context));
            }else {
              BranchHelper.dialogOrBottomSheet(
                context,
                onPressRight: (){
                  if(branchProvider.branchTabIndex != 0) {
                    branchProvider.updateTabIndex(0, isUpdate: false);
                  }
                  BranchHelper.setBranch(context);
                  cartProvider.getCartData(context);
                },
              );
            }
          }
        },
      )),
    );
  }
}

/// Toggle button widget for switching between map and grid view
class _MapGridToggleButton extends StatelessWidget {
  final int currentTabIndex;
  final VoidCallback onTap;

  const _MapGridToggleButton({
    required this.currentTabIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          border: Border.all(color: Theme.of(context).primaryColor),
        ),
        clipBehavior: Clip.hardEdge,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Animated icon section
            Container(
              height: 25,
              width: 28,
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: Padding(
                padding: const EdgeInsets.all(3),
                child: AnimatedCrossFade(
                  duration: const Duration(milliseconds: 300),
                  firstChild: const Icon(
                    Icons.location_on,
                    color: Colors.white,
                    size: 18,
                  ),
                  secondChild: const Icon(
                    Icons.grid_view,
                    color: Colors.white,
                    size: 18,
                  ),
                  crossFadeState: currentTabIndex == 0
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                ),
              ),
            ),

            /// Animated text section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
              child: AnimatedCrossFade(
                duration: const Duration(milliseconds: 300),
                firstChild: Text(
                  getTranslated('map_view', context)!,
                  style: rubikBold.copyWith(color: Theme.of(context).primaryColor),
                ),
                secondChild: Text(
                  getTranslated('grid_view', context)!,
                  style: rubikBold.copyWith(color: Theme.of(context).primaryColor),
                ),
                crossFadeState: currentTabIndex == 0
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
