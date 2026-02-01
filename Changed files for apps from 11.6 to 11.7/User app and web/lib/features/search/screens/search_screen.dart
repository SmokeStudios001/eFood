import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/widgets/custom_asset_image_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_pop_scope_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_text_field_widget.dart';
import 'package:flutter_restaurant/common/widgets/web_app_bar_widget.dart';
import 'package:flutter_restaurant/features/cart/providers/cart_provider.dart';
import 'package:flutter_restaurant/features/search/providers/search_provider.dart';
import 'package:flutter_restaurant/features/search/widget/search_recommended_widget.dart';
import 'package:flutter_restaurant/features/search/widget/search_suggestion_widget.dart';
import 'package:flutter_restaurant/helper/debounce_helper.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  final FocusNode _searchBarFocus = FocusNode();
  final DebounceHelper debounce = DebounceHelper(milliseconds: 500);

  @override
  void initState() {
    super.initState();

    final SearchProvider searchProvider = Provider.of<SearchProvider>(context, listen: false);

    searchProvider.initHistoryList();
    searchProvider.onClearSearchSuggestion();

    _searchController.addListener(_onChange);

    _searchBarFocus.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    super.dispose();
    _searchBarFocus.removeListener(_onFocusChange);
  }

  void _onFocusChange() {
    if(mounted){
      setState(() {});
    }
  }

  void _onChange() {
    if(_searchController.text.isEmpty) {
      Provider.of<SearchProvider>(context, listen: false).onClearSearchSuggestion();
    }
    if(mounted){
      setState(() {});
    }
  }


  @override
  Widget build(BuildContext context) {
    return CustomPopScopeWidget(
      child: Scaffold(
        appBar: ResponsiveHelper.isDesktop(context)
            ? const PreferredSize(preferredSize: Size.fromHeight(100), child: WebAppBarWidget())
            : PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Consumer<SearchProvider>(
            builder: (context, searchProvider, _) {
              return Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  boxShadow: [BoxShadow(color: Theme.of(context).shadowColor, blurRadius: 5, spreadRadius: 1)],
                ),
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top < 20 ? 40 : 0,
                  bottom: Dimensions.paddingSizeDefault,
                  right: Dimensions.paddingSizeLarge,
                  left: Dimensions.paddingSizeSmall,
                ),
                child: SafeArea(
                  child: Row(children: [
                    IconButton(
                      onPressed: () => context.pop(),
                      icon: const Icon(Icons.arrow_back_ios),
                    ),
                    Expanded(
                      child: Hero(
                        tag: 'search_text_field',
                        child: Material(
                          color: Colors.transparent,
                          child: CustomTextFieldWidget(
                            hintText: getTranslated('search_items_here', context),
                            isShowBorder: true,
                            controller: _searchController,
                            focusNode: _searchBarFocus,
                            inputAction: TextInputAction.search,
                            isIcon: true,
                            suffixIconUrl: Images.closeSvg,
                            isShowSuffixIcon: _searchController.text.isNotEmpty,
                            onSuffixTap: () => _searchController.clear(),
                            onSubmit: (text) {
                              if (_searchController.text.trim().isNotEmpty) {
                                searchProvider.saveSearchAddress(_searchController.text);
                                searchProvider.searchProduct(
                                  name: _searchController.text,
                                  offset: 1,
                                  context: context,
                                );
                                RouterHelper.getSearchResultRoute(
                                  _searchController.text.replaceAll(' ', '-'),
                                );
                              }
                            },
                            onChanged: (String text) => debounce.run(() {
                              if (text.isNotEmpty) {
                                searchProvider.onChangeAutoCompleteTag(searchText: text);
                              }
                            }),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: Dimensions.paddingSizeSmall),

                    InkWell(
                      onTap: () {
                        RouterHelper.getDashboardRoute('cart', action: RouteAction.pushReplacement);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).hintColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                        ),
                        padding: const EdgeInsets.all(kIsWeb ? 12 : Dimensions.paddingSizeDefault),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            CustomAssetImageWidget(
                              Images.navOrderSvg,
                              width: Dimensions.paddingSizeLarge,
                              color: Theme.of(context).primaryColor,
                            ),
                            Positioned(
                              top: -7,
                              right: -6,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Theme.of(context).primaryColor,
                                  border: Border.all(color: Colors.white, width: 0.5),
                                ),
                                child: Center(
                                  child: Text(
                                    Provider.of<CartProvider>(context).cartList.length.toString(),
                                    style: rubikSemiBold.copyWith(color: Colors.white, fontSize: 8),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]),
                ),
              );
            },
          ),
        ),

        body: SafeArea(child: SizedBox(
          width: Dimensions.webScreenWidth,
          child: _searchController.text.isNotEmpty
              ? SearchSuggestionWidget(searchedText: _searchController.text)
              :  const SearchRecommendedWidget(),
        )),
      ),
    );
  }
}





