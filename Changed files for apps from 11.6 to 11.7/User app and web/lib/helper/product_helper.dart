import 'package:flutter_restaurant/common/models/cart_calculation_models.dart';
import 'package:flutter_restaurant/common/models/cart_model.dart';
import 'package:flutter_restaurant/common/models/product_model.dart';
import 'package:flutter_restaurant/features/cart/providers/cart_provider.dart';
import 'package:flutter_restaurant/features/home/widgets/cart_bottom_sheet_widget.dart';
import 'package:flutter_restaurant/helper/custom_snackbar_helper.dart';
import 'package:flutter_restaurant/helper/date_converter_helper.dart';
import 'package:flutter_restaurant/helper/price_converter_helper.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/main.dart';
import 'package:provider/provider.dart';

class ProductHelper{
  static bool isProductAvailable({required Product product})=>
      product.availableTimeStarts != null && product.availableTimeEnds != null
          ? DateConverterHelper.isAvailable(product.availableTimeStarts!, product.availableTimeEnds!) : false;

  /// Adds product to cart
  /// If product has variations, opens bottom sheet for selection
  /// If product has no variations and [allowDirectAdd] is true, adds directly to cart
  /// 
  /// Parameters:
  /// - [allowDirectAdd]: Enable direct cart addition for products without variations (default: false)
  static void addToCart({
    required int cartIndex,
    required Product product,
    bool allowDirectAdd = false,
  }) {
    // Get product variations
    final productWithPrice = getBranchProductVariationWithPrice(product);
    final bool hasVariations = productWithPrice.variatins != null && productWithPrice.variatins!.isNotEmpty;

    // Check if we should add directly (no variations AND direct add is allowed)
    final bool shouldAddDirectly = !hasVariations && allowDirectAdd;

    if (shouldAddDirectly) {
      // No variations and direct add is enabled - add directly to cart
      addToCartDirectly(product: product);
    } else {
      // Show bottom sheet for variation selection or when direct add is disabled
      ResponsiveHelper.showDialogOrBottomSheet(Get.context!, CartBottomSheetWidget(
        product: product,
        cartIndex: cartIndex,
        callback: (CartModel cartModel) {
          showCustomSnackBarHelper(getTranslated('added_to_cart', Get.context!), isError: false);
        },
      ));
    }
  }

  /// Adds product directly to cart without showing the bottom sheet
  /// Used for products without variations
  static void addToCartDirectly({required Product product}) {
    // Get cart provider from context
    final cartProvider = Provider.of<CartProvider>(Get.context!, listen: false);
    
    // Get product price
    final productWithPrice = getBranchProductVariationWithPrice(product);
    final double basePrice = productWithPrice.price ?? 0.0;
    
    // No variations or addons for direct add
    final List<List<bool?>> emptyVariations = [];
    final addonsData = AddonsData(cost: 0.0, addOnIdList: []);
    
    // Calculate price details
    final priceDetails = calculatePriceDetails(
      basePrice: basePrice,
      variationPrice: 0.0,
      discount: product.discount,
      discountType: product.discountType,
      addonsCost: 0.0,
      quantity: 1,
    );
    
    // Build cart model
    final cartModel = buildCartModel(
      priceDetails: priceDetails,
      addOnIdList: addonsData.addOnIdList,
      quantity: 1,
      selectedVariations: emptyVariations,
      product: product,
    );
    
    // Add to cart
    cartProvider.addToCart(cartModel, -1);
    
    // Show success message
    // showCustomSnackBarHelper(getTranslated('added_to_cart', Get.context!), isError: false);
  }


  static ({List<Variation>? variatins, double? price}) getBranchProductVariationWithPrice(Product? product){

    List<Variation>? variationList;
    double? price;

    if(product?.branchProduct != null && (product?.branchProduct?.isAvailable ?? false)) {
      variationList = product?.branchProduct?.variations;
      price = product?.branchProduct?.price;

    }else{
      variationList = product?.variations;
      price = product?.price;
    }

    return (variatins: variationList, price: price);
  }

  /// Initialize addon active list from cart addon IDs
  static List<bool> initializeCartAddonActiveList(Product? product, List<AddOn>? addOnIds) {
    List<int?> addOnIdList = [];
    List<bool> addOnActiveList = [];
    if(addOnIds != null) {
      for (var addOnId in addOnIds) {
        addOnIdList.add(addOnId.id);
      }
      for (var addOn in product!.addOns!) {
        if(addOnIdList.contains(addOn.id)) {
          addOnActiveList.add(true);
        }else {
          addOnActiveList.add(false);
        }
      }
    }
    return addOnActiveList;
  }

  /// Initialize addon quantity list from cart addon IDs
  static List<int?> initializeCartAddonQuantityList(Product? product, List<AddOn>? addOnIds) {
    List<int?> addOnIdList = [];
    List<int?> addOnQtyList = [];
    if(addOnIds != null) {
      for (var addOnId in addOnIds) {
        addOnIdList.add(addOnId.id);
      }
      for (var addOn in product!.addOns!) {
        if(addOnIdList.contains(addOn.id)) {
          addOnQtyList.add(addOnIds[addOnIdList.indexOf(addOn.id)].quantity);
        }else {
          addOnQtyList.add(1);
        }
      }
    }
    return addOnQtyList;
  }

  /// Check if a product with specific variations exists in cart
  static int findProductWithVariationInCart({
    required List<CartModel?> cartList,
    required int? productID,
    required int? cartIndex,
    required List<List<bool?>>? variations,
  }) {
    for (int index = 0; index < cartList.length; index++) {
      final cartItem = cartList[index];
      
      // Skip if not the same product
      if (cartItem?.product?.id != productID) {
        continue;
      }
      
      // Skip if it's the same cart index (checking against itself)
      if (index == cartIndex) {
        return -1;
      }
      
      // Check if variations match
      if (_doVariationsMatch(variations, cartItem?.variations)) {
        return index;
      }
    }
    
    return -1;
  }

  /// Check if two variation lists match
  static bool _doVariationsMatch(
    List<List<bool?>>? variations1,
    List<List<bool?>>? variations2,
  ) {
    // Both have no variations - they match
    if (_hasNoVariations(variations1) && _hasNoVariations(variations2)) {
      return true;
    }
    
    // One has variations and the other doesn't - they don't match
    if (_hasNoVariations(variations1) || _hasNoVariations(variations2)) {
      return false;
    }
    
    // Both have variations - compare them
    return _areVariationsIdentical(variations1!, variations2!);
  }

  /// Check if variations list is null or empty
  static bool _hasNoVariations(List<List<bool?>>? variations) {
    return variations == null || variations.isEmpty;
  }

  /// Compare two variation lists for equality
  static bool _areVariationsIdentical(
    List<List<bool?>> variations1,
    List<List<bool?>> variations2,
  ) {
    // Check if lengths match
    if (variations1.length != variations2.length) {
      return false;
    }
    
    // Compare each variation group
    for (int i = 0; i < variations1.length; i++) {
      if (!_areVariationGroupsIdentical(variations1[i], variations2[i])) {
        return false;
      }
    }
    
    return true;
  }

  /// Compare two variation groups for equality
  static bool _areVariationGroupsIdentical(
    List<bool?> group1,
    List<bool?> group2,
  ) {
    // Check if lengths match
    if (group1.length != group2.length) {
      return false;
    }
    
    // Compare each item in the group
    for (int j = 0; j < group1.length; j++) {
      if (group1[j] != group2[j]) {
        return false;
      }
    }
    
    return true;
  }

  /// Calculates the total price of selected variations
  /// 
  /// Iterates through all variations and sums up the prices of selected variation values.
  /// For multi-select variations, multiple values can be selected.
  /// For single-select variations, only one value is selected.
  static double calculateVariationPrice({
    required List<Variation>? variationList,
    required List<List<bool?>> selectedVariations,
  }) {
    if (variationList == null || variationList.isEmpty) {
      return 0.0;
    }

    double totalVariationPrice = 0.0;
    
    for (int variationIndex = 0; variationIndex < variationList.length; variationIndex++) {
      final variationValues = variationList[variationIndex].variationValues;
      
      if (variationValues == null) continue;
      
      for (int valueIndex = 0; valueIndex < variationValues.length; valueIndex++) {
        final isSelected = selectedVariations[variationIndex][valueIndex] ?? false;
        
        if (isSelected) {
          totalVariationPrice += variationValues[valueIndex].optionPrice ?? 0.0;
        }
      }
    }
    
    return totalVariationPrice;
  }

  /// Calculates addons cost and builds the list of selected addons
  /// 
  /// Returns an AddonsData object containing:
  /// - cost: Total cost of all selected addons (price * quantity)
  /// - addOnIdList: List of AddOn objects with id and quantity
  static AddonsData calculateAddonsData({
    required Product? product,
    required List<bool> addOnActiveList,
    required List<int?> addOnQtyList,
  }) {
    double totalAddonsCost = 0.0;
    List<AddOn> addOnIdList = [];

    final addOns = product?.addOns;
    if (addOns == null || addOns.isEmpty) {
      return AddonsData(cost: 0.0, addOnIdList: []);
    }

    for (int index = 0; index < addOns.length; index++) {
      final isActive = addOnActiveList[index];
      
      if (isActive) {
        final addOnPrice = addOns[index].price ?? 0.0;
        final addOnQuantity = addOnQtyList[index] ?? 0;
        final addOnTotalPrice = addOnPrice * addOnQuantity;
        
        totalAddonsCost += addOnTotalPrice;
        
        addOnIdList.add(AddOn(
          id: addOns[index].id,
          quantity: addOnQuantity,
        ));
      }
    }

    return AddonsData(cost: totalAddonsCost, addOnIdList: addOnIdList);
  }

  /// Calculates all price-related details including discounts and totals
  /// 
  /// Returns a PriceDetails object containing:
  /// - basePrice: Original product price
  /// - priceWithVariation: Base price + variation price
  /// - priceWithDiscount: Single item price after discount
  /// - discountAmount: Amount of discount per item
  /// - totalWithDiscount: Total price with addons, variations, and discount applied
  /// - totalWithoutDiscount: Total price with addons and variations but no discount
  static PriceDetails calculatePriceDetails({
    required double basePrice,
    required double variationPrice,
    required double? discount,
    required String? discountType,
    required double addonsCost,
    required int quantity,
  }) {
    // Calculate base prices
    final double priceWithVariation = basePrice + variationPrice;
    
    // Calculate discounted prices
    final double priceWithDiscount = PriceConverterHelper.convertWithDiscount(
      basePrice,
      discount,
      discountType,
    ) ?? basePrice;
    
    final double priceWithVariationDiscounted = PriceConverterHelper.convertWithDiscount(
      priceWithVariation,
      discount,
      discountType,
    ) ?? priceWithVariation;
    
    // Calculate discount amount per item
    final double discountAmount = priceWithVariation - priceWithVariationDiscounted;
    
    // Calculate total prices
    final double totalWithDiscount = (priceWithVariationDiscounted * quantity) + addonsCost;
    final double totalWithoutDiscount = (priceWithVariation * quantity) + addonsCost;

    return PriceDetails(
      basePrice: basePrice,
      priceWithVariation: priceWithVariation,
      priceWithDiscount: priceWithDiscount,
      discountAmount: discountAmount,
      totalWithDiscount: totalWithDiscount,
      totalWithoutDiscount: totalWithoutDiscount,
    );
  }

  /// Builds the CartModel with all calculated prices and selections
  /// 
  /// Creates a CartModel instance with:
  /// - Price information (with variations, discounts, tax)
  /// - Selected variations and addons
  /// - Product information
  static CartModel buildCartModel({
    required PriceDetails priceDetails,
    required List<AddOn> addOnIdList,
    required int? quantity,
    required List<List<bool?>> selectedVariations,
    required Product product,
  }) {
    // Calculate tax amount
    final double priceAfterDiscount = priceDetails.priceWithVariation - priceDetails.discountAmount;
    final double priceAfterTax = PriceConverterHelper.convertWithDiscount(
      priceAfterDiscount,
      product.tax,
      product.taxType,
    ) ?? priceAfterDiscount;
    final double taxAmount = priceAfterDiscount - priceAfterTax;

    return CartModel(
      priceDetails.priceWithVariation,      // Price with variation
      priceDetails.priceWithDiscount,       // Price with discount
      [],                                   // Variation (legacy parameter)
      priceDetails.discountAmount,          // Discount amount
      quantity,                             // Quantity
      taxAmount,                            // Tax amount
      addOnIdList,                          // Selected addons
      product,                              // Product
      selectedVariations,                   // Selected variations
    );
  }

}