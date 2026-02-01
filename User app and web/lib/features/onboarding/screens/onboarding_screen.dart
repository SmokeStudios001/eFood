import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/widgets/custom_asset_image_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_pop_scope_widget.dart';
import 'package:flutter_restaurant/features/onboarding/providers/onboarding_provider.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:provider/provider.dart';

class OnBoardingScreen extends StatefulWidget {

  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _pageController = PageController();
  bool _isNavigating = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<OnBoardingProvider>(context, listen: false).initBoardingList(context);

    final size = MediaQuery.sizeOf(context);

    return Consumer<OnBoardingProvider>(
      builder: (context, onBoardingProvider, child) => CustomPopScopeWidget(
        child: Scaffold(
          body: onBoardingProvider.onBoardingList.isNotEmpty ? SafeArea(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [ColorResources.onBoardingBgColor, Theme.of(context).cardColor],
                ),
              ),
              child: Stack(
                children: [
                  // PageView for scrolling content
                  NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification notification) {
                      if (notification.metrics.axis == Axis.horizontal) {

                        double maxSwipe = notification.metrics.maxScrollExtent + 50;

                        double currentPosition = notification.metrics.pixels;
                        bool isLastPage = onBoardingProvider.selectedIndex == onBoardingProvider.onBoardingList.length - 1;
                        final canNavigate = currentPosition >= maxSwipe && isLastPage && !_isNavigating;

                        if (canNavigate) {
                          _isNavigating = true;
                          _onNavigate();
                        }
                      }
                      return false;
                    },
                    child: PageView.builder(
                      itemCount: onBoardingProvider.onBoardingList.length,
                      controller: _pageController,
                      physics: const BouncingScrollPhysics(),

                      onPageChanged: (index) {
                        onBoardingProvider.changeSelectIndex(index);

                      },
                      itemBuilder: (context, index) {
                        return SizedBox(
                          width: Dimensions.webScreenWidth,
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [

                                Padding(
                                  padding: const EdgeInsets.all(30),
                                  child: CustomAssetImageWidget(
                                    onBoardingProvider.onBoardingList[index].imageUrl,
                                    width: 250, height: 190, fit: BoxFit.cover,
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeDefault),
                                  child: Text(
                                    onBoardingProvider.onBoardingList[index].title ?? '',
                                    style: rubikBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge, color: Theme.of(context).textTheme.bodyLarge!.color),
                                    textAlign: TextAlign.center,
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                                  child: Text(
                                    onBoardingProvider.onBoardingList[index].description ?? '',
                                    style: rubikRegular.copyWith(
                                      fontSize: Dimensions.fontSizeLarge,
                                      color: Theme.of(context).textTheme.bodyLarge!.color?.withValues(alpha: 0.7),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),

                                SizedBox(height: size.height * 0.1),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Fixed Skip button at top
                  if (_isNotLastIndex(onBoardingProvider))
                    Positioned(
                      top: Dimensions.paddingSizeDefault,
                      right: Dimensions.paddingSizeDefault,
                      child: InkWell(
                        onTap: () => RouterHelper.getLoginRoute(action: RouteAction.pushNamedAndRemoveUntil),
                        child: Padding(
                          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                          child: Text(
                            getTranslated('skip', context)!,
                            style: rubikRegular.copyWith(color: Theme.of(context).primaryColor),
                          ),
                        ),
                      ),
                    ),

                  // Fixed Next button at bottom
                  Positioned(
                    bottom: size.height > 700 ? size.height * 0.2 : size.height * 0.1,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: InkWell(
                        onTap: () => _onNavigate(),
                        child: _isNotLastIndex(onBoardingProvider) ? Stack(children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).cardColor,
                              border: Border.all(color: Theme.of(context).primaryColor.withValues(alpha: 0.2), width: 2),
                            ),
                            padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                            child: Icon(Icons.arrow_forward_ios, color: Theme.of(context).primaryColor),
                          ),

                          Positioned.fill(
                            child: Align(
                              alignment: Alignment.center,
                              child: SizedBox(
                                width: 100, height: 65,
                                child: CircularProgressIndicator(
                                  value: (onBoardingProvider.selectedIndex) / (onBoardingProvider.onBoardingList.length - 1),
                                  color: Theme.of(context).primaryColor,
                                  backgroundColor: Colors.transparent,
                                  strokeCap: StrokeCap.round,
                                ),
                              ),
                            ),
                          ),
                        ]) : ElevatedButton(
                          onPressed: ()=> _onNavigate(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor, // Button color
                            foregroundColor: Colors.white, // Text color
                            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 0,

                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(getTranslated('lets_start', context)!, style: rubikSemiBold.copyWith(
                                fontSize: Dimensions.fontSizeLarge,
                              )),
                              SizedBox(width: Dimensions.paddingSizeExtraSmall),

                              Icon(Icons.navigate_next, size: 25),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ) : const SizedBox(),
        ),
      ),
    );
  }

  void _onNavigate() {
    if(_isNotLastIndex(Provider.of<OnBoardingProvider>(context, listen: false))) {
      _pageController.nextPage(duration: const Duration(seconds: 1), curve: Curves.ease);
    } else {
      RouterHelper.getLoginRoute(action: RouteAction.pushNamedAndRemoveUntil);
    }
  }

  bool _isNotLastIndex(OnBoardingProvider onBoardingProvider) => onBoardingProvider.selectedIndex < onBoardingProvider.onBoardingList.length - 1;
}