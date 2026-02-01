import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/models/config_model.dart';
import 'package:flutter_restaurant/common/widgets/custom_button_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_single_child_list_widget.dart';
import 'package:flutter_restaurant/features/category/providers/category_provider.dart';
import 'package:flutter_restaurant/features/home/widgets/category_widget.dart';
import 'package:flutter_restaurant/features/search/providers/search_provider.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SearchFilterWidget extends StatelessWidget {
  final double? maxValue;
  const SearchFilterWidget({super.key, required this.maxValue});

  @override
  Widget build(BuildContext context) {
    final CategoryProvider categoryProvider = Provider.of<CategoryProvider>(context, listen: true);
    final ConfigModel ? configModel = Provider.of<SplashProvider>(context, listen: true).configModel;

    return Consumer<SearchProvider>(
      builder: (context, searchProvider, child) {
        bool canNotFilter = searchProvider.selectedSortByIndex == null
            && searchProvider.selectedPriceIndex == null
            && searchProvider.selectedRatingIndex == null
            &&  categoryProvider.selectedCategoryList.isEmpty
            && searchProvider.cuisineIds == null
            && searchProvider.halalTagStatus == false
            && searchProvider.tempVegTagStatus == false
            && searchProvider.tempNonVegTagStatus == false;

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            ResponsiveHelper.isDesktop(context) ? Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeLarge).copyWith(bottom: 0),
              child: const _HeaderWidget(middleExist: false),
            ) : Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeLarge).copyWith(bottom: 0),
              child: const _HeaderWidget(),
            ),
            const SizedBox(height: Dimensions.paddingSizeLarge),

            ///sort by
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(getTranslated('sort_by', context)!, style: rubikBold.copyWith(fontSize: Dimensions.fontSizeSmall)),
                const SizedBox(height: Dimensions.paddingSizeDefault),


                CustomSingleChildListWidget(
                  physics: const NeverScrollableScrollPhysics(),
                  isWrap: true,
                  wrapSpacing: Dimensions.paddingSizeSmall,
                  runSpacing: Dimensions.paddingSizeSmall,
                  itemCount: searchProvider.getSortByList.length,
                  itemBuilder: (index)=> InkWell(
                    onTap: ()=> searchProvider.onChangeSortByIndex(index),
                    child: Container(
                      // alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: searchProvider.selectedSortByIndex == index ? Theme.of(context).primaryColor : Theme.of(context).hintColor.withValues(alpha:0.5),
                        ),
                        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                      ),
                      child: Text(
                        getTranslated(searchProvider.getSortByList[index], context)!,
                        textAlign: TextAlign.center,
                        style: rubikRegular.copyWith(
                          fontSize: Dimensions.fontSizeSmall,
                          // color: searchProvider.selectedSortByIndex == index ? Theme.of(context).cardColor : Theme.of(context).hintColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),

              ]),
            ),
            const SizedBox(height: Dimensions.paddingSizeLarge),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
              child: Divider(color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha:0.1)),
            ),


            Expanded(child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
              child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [


                /// Food Preference
                if(configModel?.halalTagStatus == 1) Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                 Padding(
                   padding: const EdgeInsets.only(top: Dimensions.paddingSizeDefault, bottom: Dimensions.paddingSizeDefault),
                   child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                     Text(getTranslated('food_preferences', context)!, style: rubikBold.copyWith(fontSize: Dimensions.fontSizeSmall)),
                     const SizedBox(height: Dimensions.paddingSizeDefault),

                     Row(mainAxisSize: MainAxisSize.min, children: [

                       _FilterCheckbox(
                         value: searchProvider.halalTagStatus,
                         onChanged: (bool? newValue) {
                           searchProvider.onChangeHalalTagStatus(status: newValue);
                         },
                       ),
                       const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                       Text(
                         getTranslated('only_halal_food', context)!,
                         textAlign: TextAlign.center,
                         style: rubikRegular.copyWith(
                           fontSize: ResponsiveHelper.isDesktop(context)
                               ? Dimensions.fontSizeDefault
                               : Dimensions.fontSizeSmall,
                           color: searchProvider.halalTagStatus
                               ? Theme.of(context).textTheme.bodyMedium?.color
                               : Theme.of(context).hintColor,
                         ),
                         maxLines: 1,
                         overflow: TextOverflow.ellipsis,
                       ),
                     ]),
                   ]),
                 ),
                 Divider(color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha:0.1)),
                 const SizedBox(height: Dimensions.paddingSizeLarge),
               ]),


               /// Food Type
                if(configModel?.isVegNonVegActive ?? false)
                  _FoodTypeSection(
                    vegTagStatus: searchProvider.tempVegTagStatus,
                    nonVegTagStatus: searchProvider.tempNonVegTagStatus,
                    onVegChanged: (value) => searchProvider.onChangeTempVegTagStatus(status: value),
                    onNonVegChanged: (value) => searchProvider.onChangeTempNonVegTagStatus(status: value),
                  ),


                /// Price section
                Text(getTranslated('price', context)!, style: rubikBold.copyWith(fontSize: Dimensions.fontSizeSmall)),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                SizedBox(width: Dimensions.webScreenWidth, height: 30, child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: searchProvider.priceFilterList.length,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                    child: Material(
                      color: searchProvider.selectedPriceIndex == index
                          ? Theme.of(context).primaryColor.withAlpha(230)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                      clipBehavior: Clip.hardEdge,
                      child: InkWell(
                        onTap: () => searchProvider.updatePriceFilter(index),
                        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                        child: Tooltip(
                          message:
                          '[${searchProvider.priceFilterList[index].first} - ${(searchProvider.priceFilterList[index].last - 0.01).toStringAsFixed(2)}]',
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(
                              horizontal: Dimensions.paddingSizeSmall,
                              vertical: Dimensions.paddingSizeExtraSmall,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: searchProvider.selectedPriceIndex == index
                                    ? Theme.of(context).primaryColor
                                    : Theme.of(context).hintColor.withAlpha(128),
                              ),
                              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                            ),
                            child: Text(
                              searchProvider.priceFilterList[index].last.toString().replaceAll(RegExp('[^0]'), '').replaceAll(RegExp('0'), '\$'),
                              textAlign: TextAlign.center,
                              style: rubikRegular.copyWith(
                                fontSize: Dimensions.fontSizeSmall,
                                color: searchProvider.selectedPriceIndex == index
                                    ? Theme.of(context).cardColor
                                    : Theme.of(context).hintColor,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )),
                const SizedBox(height: Dimensions.paddingSizeLarge),

                /// Rating section
                Text(getTranslated('ratings', context)!, style: rubikBold.copyWith(fontSize: Dimensions.fontSizeSmall)),
                const SizedBox(height: Dimensions.paddingSizeDefault),


                GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: Dimensions.paddingSizeSmall,
                    mainAxisSpacing: Dimensions.paddingSizeSmall,
                    crossAxisCount: 2,
                    mainAxisExtent: 20,
                  ),
                  itemCount: searchProvider.ratingList?.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return InkWell(
                      highlightColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: ()=> searchProvider.onChangeRating(index),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          RadioGroup<int?>(
                            groupValue: searchProvider.selectedRatingIndex,
                            onChanged: (value) => searchProvider.onChangeRating(value),
                            child: Radio<int?>(
                              value: index,
                              visualDensity: const VisualDensity(horizontal: -3, vertical: -3),
                              fillColor: WidgetStateColor.resolveWith((states) => states.contains(WidgetState.selected)
                                  ? Theme.of(context).primaryColor :  Theme.of(context).hintColor),
                              toggleable: false,
                            ),
                          ),
                          const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                          Text(searchProvider.ratingList?[index].title ?? '', style: rubikRegular.copyWith(
                            fontSize: ResponsiveHelper.isDesktop(context)
                                ? Dimensions.fontSizeDefault : Dimensions.fontSizeSmall,
                            color: searchProvider.selectedRatingIndex == index
                                ? Theme.of(context).textTheme.bodyMedium?.color : Theme.of(context).hintColor,
                          )),
                        ],
                      ),
                    );
                  },
                ),

                const SizedBox(height: Dimensions.paddingSizeLarge),
                /// Category section
                Text(getTranslated('category', context)!, style: rubikBold.copyWith(fontSize: Dimensions.fontSizeSmall)),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                Consumer<CategoryProvider>(
                  builder: (context, category, child) {
                    return category.categoryList != null ? SizedBox(
                      child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisExtent: Dimensions.paddingSizeDefault * 2,
                          ),
                          itemCount: category.categoryList?.length,
                           itemBuilder: (context, index) {
                             final categoryId = category.categoryList?[index].id;
                             final categoryName = category.categoryList?[index].name ?? '';
                             final isSelected = category.selectedCategoryList.contains(categoryId);
                             
                             return _FilterGridItemWidget(
                               label: categoryName,
                               isSelected: isSelected,
                               onTap: () {
                                 if(categoryId != null) {
                                   category.updateSelectCategory(id: categoryId);
                                 }
                               },
                             );
                          }
                      ),
                    )
                        : const CategoryShimmer();
                  },
                ),

                const SizedBox(height: Dimensions.paddingSizeLarge),
                /// Cuisine section
                Text(getTranslated('cuisine', context)!, style: rubikBold.copyWith(fontSize: Dimensions.fontSizeSmall)),
                const SizedBox(height: Dimensions.paddingSizeDefault),


                if(searchProvider.cuisineList?.isNotEmpty ?? false) SizedBox(
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisExtent: Dimensions.paddingSizeDefault * 2,
                    ),
                    itemCount: searchProvider.cuisineList?.length,
                     itemBuilder: (context, index) {
                       final cuisine = searchProvider.cuisineList![index];
                       final isSelected = searchProvider.cuisineIds?.contains(cuisine.id) ?? false;
                       
                       return _FilterGridItemWidget(
                         label: cuisine.name ?? '',
                         isSelected: isSelected,
                         onTap: () {
                           if(cuisine.id != null) {
                             searchProvider.onSelectCuisineList(cuisine.id);
                           }
                         },
                       );
                    },
                  ),
                ),
                const SizedBox(height: Dimensions.paddingSizeLarge),

              ]),
            )),

            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0,0),
                    blurRadius: 10,
                    spreadRadius: 0,
                    color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha:0.08),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeSmall),
                child: Row(children: [

                  Expanded(child: CustomButtonWidget(
                    onTap: () {
                      searchProvider.resetFilterData();
                      Navigator.pop(context);
                      searchProvider.searchProduct(offset: 1, name: searchProvider.searchText, context: context);
                    },
                    height: 40,
                    btnTxt: getTranslated('reset', context),
                    textStyle: rubikSemiBold.copyWith(color: Theme.of(context).textTheme.bodyMedium?.color),
                    borderRadius: Dimensions.radiusSmall,
                    backgroundColor: Theme.of(context).primaryColor.withValues(alpha:0.2),
                  )),
                  const SizedBox(width: Dimensions.paddingSizeDefault),

                  Expanded(flex: 2, child: CustomButtonWidget(
                    isLoading: searchProvider.isLoading,
                    height: 40,
                    btnTxt: getTranslated('apply', context),
                    textStyle: rubikSemiBold.copyWith(color: Theme.of(context).cardColor),
                    borderRadius: Dimensions.radiusSmall,
                    onTap: canNotFilter ? null :  () async {
                      // Commit temporary state to actual state
                      searchProvider.commitTempFoodTypeStatus();

                      searchProvider.searchProduct(offset: 1, name: searchProvider.searchText, context: context);

                      if(context.mounted) {
                        context.pop();
                      }
                    },
                  )),

                ]),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _HeaderWidget extends StatelessWidget {
  final bool middleExist;
  const _HeaderWidget({this.middleExist = true});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

      Text(getTranslated('filter', context)!, textAlign: TextAlign.center, style: rubikSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge)),

      middleExist ?  Container(
        transform: Matrix4.translationValues(0, -10, 0),
        width: 35, height: 4, decoration: BoxDecoration(
        color: Theme.of(context).hintColor.withValues(alpha:0.3),
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
      ),
        padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
      ) : const SizedBox(width: Dimensions.paddingSizeLarge),
    
      InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () => context.pop(),
        child: Container(
            padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
            transform: Matrix4.translationValues(0, -4, 0),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.close, size: Dimensions.paddingSizeDefault, color: Theme.of(context).cardColor)),
      ),
    
    ]);
  }
}

class _FilterCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?>? onChanged;

  const _FilterCheckbox({
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: value,
      activeColor: Theme.of(context).primaryColor,
      checkColor: Theme.of(context).primaryColor,
      fillColor: WidgetStateProperty.all(Colors.transparent),
      side: WidgetStateBorderSide.resolveWith((states) {
        return BorderSide(
          color: value ? Theme.of(context).primaryColor : Theme.of(context).hintColor,
        );
      }),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
      onChanged: onChanged,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: const VisualDensity(horizontal: -4, vertical: -3),
    );
  }
}

class _FilterGridItemWidget extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterGridItemWidget({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Container(
            transform: Matrix4.translationValues(-2, 0, 0),
            child: _FilterCheckbox(
              value: isSelected,
              onChanged: (_) => onTap(),
            ),
          ),
          Flexible(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: rubikRegular.copyWith(
                fontSize: ResponsiveHelper.isDesktop(context)
                    ? Dimensions.fontSizeDefault
                    : Dimensions.fontSizeSmall,
                color: isSelected ? Theme.of(context).textTheme.bodyMedium?.color : Theme.of(context).hintColor,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: Dimensions.paddingSizeDefault),
        ]),
      ),
    );
  }
}

class _FoodTypeCheckbox extends StatelessWidget {
  final String label;
  final bool value;
  final Function(bool?) onChanged;

  const _FoodTypeCheckbox({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        _FilterCheckbox(
          value: value,
          onChanged: onChanged,
        ),
        const SizedBox(width: Dimensions.paddingSizeExtraSmall),

        Flexible(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: rubikRegular.copyWith(
              fontSize: ResponsiveHelper.isDesktop(context)
                  ? Dimensions.fontSizeDefault
                  : Dimensions.fontSizeSmall,
              color: value ? Theme.of(context).textTheme.bodyMedium?.color : Theme.of(context).hintColor,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ]),
    );
  }
}

class _FoodTypeSection extends StatelessWidget {
  final bool vegTagStatus;
  final bool nonVegTagStatus;
  final Function(bool?) onVegChanged;
  final Function(bool?) onNonVegChanged;

  const _FoodTypeSection({
    required this.vegTagStatus,
    required this.nonVegTagStatus,
    required this.onVegChanged,
    required this.onNonVegChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.only(
          top: Dimensions.paddingSizeDefault, 
          bottom: Dimensions.paddingSizeDefault,
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            getTranslated('food_type', context)!, 
            style: rubikBold.copyWith(fontSize: Dimensions.fontSizeSmall),
          ),
          const SizedBox(height: Dimensions.paddingSizeDefault),

          Row(children: [
            _FoodTypeCheckbox(
              label: getTranslated('veg_food', context)!,
              value: vegTagStatus,
              onChanged: onVegChanged,
            ),
            const SizedBox(width: Dimensions.paddingSizeSmall),
            _FoodTypeCheckbox(
              label: getTranslated('non_veg_food', context)!,
              value: nonVegTagStatus,
              onChanged: onNonVegChanged,
            ),
          ]),
        ]),
      ),
    ]);
  }
}
