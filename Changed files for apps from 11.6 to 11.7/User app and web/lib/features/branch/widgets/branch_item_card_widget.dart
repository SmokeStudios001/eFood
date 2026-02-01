import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/models/config_model.dart';
import 'package:flutter_restaurant/common/widgets/custom_image_widget.dart';
import 'package:flutter_restaurant/features/branch/providers/branch_provider.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/helper/custom_snackbar_helper.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:provider/provider.dart';

class BranchItemCardWidget extends StatelessWidget {
  final BranchValue? branchesValue;
  final VoidCallback? onTap;

  const BranchItemCardWidget({super.key, this.branchesValue, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Consumer<BranchProvider>(
      builder: (context, branchProvider, _) {
        // Check if it's mobile or web view
        final isMobile = ResponsiveHelper.isMobile();
        
        if (isMobile) {
          // Mobile view - overlay design
          return _MobileBranchItemCard(branchesValue: branchesValue, onTap: onTap);
        } else {
          // Web view - column layout design
          return _WebBranchItemCard(branchesValue: branchesValue, onTap: onTap);
        }
      }
    );
  }
}

// Mobile view widget - overlay design
class _MobileBranchItemCard extends StatelessWidget {
  final BranchValue? branchesValue;
  final VoidCallback? onTap;

  const _MobileBranchItemCard({required this.branchesValue, this.onTap});

  @override
  Widget build(BuildContext context) {
    final splashProvider = Provider.of<SplashProvider>(context, listen: false);
    final branchProvider = Provider.of<BranchProvider>(context, listen: false);
    final bool isSelected = branchProvider.selectedBranchId == branchesValue!.branches!.id;
    final bool isCurrentlySaved = branchesValue!.branches!.id == branchProvider.getBranchId();
    final bool isClosed = !(branchesValue!.branches!.status ?? true);
    
    return GestureDetector(
      onTap: (){
        if(branchesValue!.branches!.status!) {
          branchProvider.updateBranchId(branchesValue!.branches!.id);
          onTap?.call(); // Call the optional callback if provided
        }else{
          showCustomSnackBarHelper('${branchesValue!.branches!.name} ${getTranslated('close_now', context)}');
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          color: Theme.of(context).cardColor,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).textTheme.titleLarge!.color!.withValues(alpha: 0.1),
              offset: const Offset(0, 3),
              blurRadius: 30,
            )
          ],
        ),
        child: Stack(
          children: [
            /// Full background image
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    border: Border.all(
                      color: (isSelected ? Theme.of(context).primaryColor : Theme.of(context).hintColor).withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    child: CustomImageWidget(
                      placeholder: Images.branchBanner,
                      image: '${splashProvider.baseUrls!.branchImageUrl}/${branchesValue!.branches!.coverImage}',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),

            
            /// Branch info overlay at bottom
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.paddingSizeDefault,
                  vertical: Dimensions.paddingSizeSmall,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? Color.alphaBlend(
                    Theme.of(context).primaryColor.withValues(alpha: 0.1),
                    Colors.white,
                  ) : Colors.white,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(Dimensions.radiusDefault),
                    bottomRight: Radius.circular(Dimensions.radiusDefault),
                  ),
                  border: isSelected ? Border(
                    left: BorderSide(color: Theme.of(context).primaryColor.withValues(alpha: 0.6), width: 1),
                    right: BorderSide(color: Theme.of(context).primaryColor.withValues(alpha: 0.6), width: 1),
                    bottom: BorderSide(color: Theme.of(context).primaryColor.withValues(alpha: 0.6), width: 1),
                  ) : Border.all(
                    color: Theme.of(context).hintColor.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Left column: Branch name and address
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          /// Branch name
                          Text(
                            branchesValue?.branches?.name ?? '',
                            style: rubikSemiBold.copyWith(
                              fontSize: Dimensions.fontSizeLarge,
                              color: Colors.black,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                          /// Address with location icon
                          Row(
                            children: [
                              Icon(Icons.location_on_rounded, size: Dimensions.fontSizeDefault, color: Theme.of(context).primaryColor),
                              const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                              Expanded(
                                child: Text(
                                  branchesValue?.branches?.address ?? '',
                                  style: rubikMedium.copyWith(
                                    fontSize: Dimensions.fontSizeSmall,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    /// Right column: Distance information
                    if (branchesValue?.distance != -1 && splashProvider.configModel?.googleMapStatus == 1)
                      Padding(
                        padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(height: Dimensions.paddingSizeSmall),
                            Text(
                              '${branchesValue!.distance.toStringAsFixed(2)} ${getTranslated('km', context)}',
                              style: rubikBold.copyWith(
                                fontSize: Dimensions.fontSizeLarge,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              getTranslated('away', context)!,
                              style: rubikRegular.copyWith(
                                fontSize: Dimensions.fontSizeSmall,
                                color: Theme.of(context).hintColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
            
            /// Rectangular logo badge (bottom right on image)
            Positioned(
              bottom: 55, // Above the white info box
              right: 10,
              child: Container(
                height: 65,
                width: 65,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  color: Colors.white,
                  border: Border.all(
                    color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  child: CustomImageWidget(
                    placeholder: Images.placeholderImage,
                    image: '${splashProvider.baseUrls!.branchImageUrl}/${branchesValue!.branches!.image}',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            
            /// Selected checkmark (top left)
            if (isSelected)
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),

            /// Currently saved branch indicator (top right)
            if (isCurrentlySaved)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  ),
                  child: Text(
                    getTranslated('current_branch', context)!,
                    style: rubikMedium.copyWith(
                      color: Colors.white,
                      fontSize: Dimensions.fontSizeExtraSmall,
                    ),
                  ),
                ),
              ),
            
            /// Closed badge
            if (isClosed)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Dimensions.paddingSizeDefault,
                          vertical: Dimensions.paddingSizeExtraSmall,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.schedule,
                              color: Colors.white,
                              size: 16,
                            ),
                            const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                            Text(
                              getTranslated('close_now', context)!,
                              style: rubikMedium.copyWith(
                                color: Colors.white,
                                fontSize: Dimensions.fontSizeSmall,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// Web view widget - column layout design
class _WebBranchItemCard extends StatelessWidget {
  final BranchValue? branchesValue;
  final VoidCallback? onTap;

  const _WebBranchItemCard({required this.branchesValue, this.onTap});

  @override
  Widget build(BuildContext context) {
    final splashProvider = Provider.of<SplashProvider>(context, listen: false);
    final branchProvider = Provider.of<BranchProvider>(context, listen: false);
    final bool isSelected = branchProvider.selectedBranchId == branchesValue!.branches!.id;
    final bool isCurrentlySaved = branchesValue!.branches!.id == branchProvider.getBranchId();


    return GestureDetector(
      onTap: (){
        if(branchesValue!.branches!.status!) {
          branchProvider.updateBranchId(branchesValue!.branches!.id);
          onTap?.call(); // Call the optional callback if provided
        }else{
          showCustomSnackBarHelper('${branchesValue!.branches!.name} ${getTranslated('close_now', context)}');
        }
      },
      child: SizedBox(
        height: 190, // Fixed height to provide bounded constraints
        child: Stack(children: [

        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).hintColor.withValues(alpha: 0.4),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
            color: Theme.of(context).cardColor,
            boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withValues(alpha:0.25), blurRadius: 36, offset: const Offset(18, 18))]
          ),
          child: Column(children: [

            /// for Branch banner
            Expanded(flex: 6, child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(Dimensions.radiusLarge),
                topLeft: Radius.circular(Dimensions.radiusLarge),
              ),
              child: Stack(children: [
                CustomImageWidget(
                  placeholder: Images.branchBanner,
                  image: '${splashProvider.baseUrls!.branchImageUrl}/${branchesValue!.branches!.coverImage}',
                  width: Dimensions.webScreenWidth,
                ),

                if(! branchesValue!.branches!.status!) Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha:0.4),
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(Dimensions.radiusLarge),
                      topLeft: Radius.circular(Dimensions.radiusLarge),
                    ),
                  ),
                  child: Center(child:Container(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withValues(alpha:0.5),
                      borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
                    ),
                    child: Row(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.end, children: [
                      const Icon(Icons.schedule_outlined, color: Colors.white, size: Dimensions.paddingSizeLarge),
                      const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                      Text(
                        getTranslated('close_now', context)!,
                        style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Colors.white),
                      ),
                    ]),
                  )),
                ),
              ]),
            )),

            /// for Branch info
            Expanded(flex: 3, child: Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const SizedBox(width: 90),

                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Expanded(flex: 2, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(branchesValue!.branches!.name!, style: rubikSemiBold),

                      Row(children: [
                        Icon(Icons.location_on_rounded, size: Dimensions.fontSizeDefault, color: Theme.of(context).primaryColor),
                        const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                        Expanded(child: Text(
                          branchesValue?.branches?.address ?? '',
                          style: rubikSemiBold.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeSmall),
                          maxLines: 1, overflow: TextOverflow.ellipsis,
                        )),
                      ]),
                    ])),

                    if(branchesValue!.distance != -1 && splashProvider.configModel?.googleMapStatus == 1)
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [

                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerRight,
                          child: Text(
                            '${branchesValue!.distance.toStringAsFixed(2)} ${getTranslated('km', context)}',
                            style: rubikBold,
                            maxLines: 1,
                          ),
                        ),

                        Text(getTranslated('away', context)!, style: rubikSemiBold.copyWith(
                          fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).hintColor,
                        )),

                      ])),
                  ]),
                ])),
              ]),
            )),

          ]),
        ),

        /// for Branch image
        Positioned(
          bottom: 15,
          left: 15,
          child: Container(
            height: 70, width: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              color: Colors.white,
            ),
            margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
            padding: const EdgeInsets.all(3),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                border: Border.all(color: Theme.of(context).primaryColor.withValues(alpha:0.2)),
                color: Theme.of(context).cardColor,
              ),
              child: ClipRRect(borderRadius: BorderRadius.circular(Dimensions.radiusSmall), child: CustomImageWidget(
                placeholder: Images.placeholderImage,
                image: '${splashProvider.baseUrls!.branchImageUrl}/${branchesValue!.branches!.image}',
                height: 70, width: 70,
              )),
            ),
          ),
        ),

        /// Currently saved branch indicator (top right)
        if (isCurrentlySaved)
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: 078),
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              ),
              child: Text(
                getTranslated('current_branch', context)!,
                style: rubikMedium.copyWith(
                  color: Colors.white,
                  fontSize: Dimensions.fontSizeExtraSmall,
                ),
              ),
            ),
          ),

        ]),
      ),
    );
  }
}