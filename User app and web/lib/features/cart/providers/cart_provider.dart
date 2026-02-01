import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/models/cart_model.dart';
import 'package:flutter_restaurant/common/models/product_model.dart';
import 'package:flutter_restaurant/common/providers/product_provider.dart';
import 'package:flutter_restaurant/features/cart/domain/reposotories/cart_repo.dart';
import 'package:flutter_restaurant/helper/product_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/main.dart';
import 'package:flutter_restaurant/helper/custom_snackbar_helper.dart';
import 'package:provider/provider.dart';

class CartProvider extends ChangeNotifier {
  final CartRepo? cartRepo;
  CartProvider({required this.cartRepo});

  List<CartModel?> _cartList = [];
  double _amount = 0.0;
  bool _isCartUpdate = false;

  List<CartModel?> get cartList => _cartList;
  double get amount => _amount;
  bool get isCartUpdate => _isCartUpdate;


  void getCartData(BuildContext context) {
    _cartList = [];
    _cartList.addAll(cartRepo!.getCartList(context));
    for (var cart in _cartList) {
      _amount = _amount + (cart!.discountedPrice! * cart.quantity!);
    }
  }

  void addToCart(CartModel cartModel, int? index) {
    // Create a new CartModel with updated timestamp
    final updatedCartModel = CartModel(
      cartModel.price,
      cartModel.discountedPrice,
      cartModel.variation ?? [],
      cartModel.discountAmount,
      cartModel.quantity,
      cartModel.taxAmount,
      cartModel.addOnIds ?? [],
      cartModel.product,
      cartModel.variations ?? [],
      lastUpdatedAt: DateTime.now(),
    );

    if(index != null && index != -1) {
      _cartList.replaceRange(index, index+1, [updatedCartModel]);
    }else {
      _cartList.add(updatedCartModel);
    }
    cartRepo!.addToCartList(_cartList);
    setCartUpdate(false);
    showCustomSnackBarHelper(getTranslated(index == -1 ?
    'added_in_cart' : 'cart_updated', Get.context!), isToast: true, isError: false);

    notifyListeners();
  }

  void setQuantity(
      {required bool isIncrement,
      CartModel? cart,
      int? productIndex,
      required bool fromProductView}) {
    int? index = fromProductView ? productIndex :  _cartList.indexOf(cart);
    if (isIncrement) {
      _cartList[index!]!.quantity = _cartList[index]!.quantity! + 1;
      _amount = _amount + _cartList[index]!.discountedPrice!;
    } else {
      _cartList[index!]!.quantity = _cartList[index]!.quantity! - 1;
      _amount = _amount - _cartList[index]!.discountedPrice!;
    }
    cartRepo!.addToCartList(_cartList);

    notifyListeners();
  }

  void removeFromCart(int index) {
    _amount = _amount - (_cartList[index]!.discountedPrice! * _cartList[index]!.quantity!);
    _cartList.removeAt(index);
    cartRepo!.addToCartList(_cartList);
    notifyListeners();
  }

  void removeAddOn(int index, int addOnIndex) {
    _cartList[index]!.addOnIds!.removeAt(addOnIndex);
    cartRepo!.addToCartList(_cartList);
    notifyListeners();
  }

  void clearCartList() {
    _cartList = [];
    _amount = 0;
    cartRepo!.addToCartList(_cartList);
    notifyListeners();
  }

  int isExistInCart(int? productID, int? cartIndex) {
    for(int index=0; index<_cartList.length; index++) {
      if(_cartList[index]!.product!.id == productID) {
        if((index == cartIndex)) {
          return -1;
        }else {
          return index;
        }
      }
    }
    return -1;
  }


  int getFirstCartIndex (Product product) {
    for(int index = 0; index < _cartList.length; index ++) {
      if(_cartList[index]!.product!.id == product.id ) {

        return index;
      }
    }
    return -1;
  }


  int getLastUpdatedCartIndex(Product product) {
    // Early return if cart is empty
    if (_cartList.isEmpty) return -1;

    int lastIndex = -1;
    DateTime? lastUpdatedTime;
    
    for (int index = 0; index < _cartList.length; index++) {
      final cartItem = _cartList[index];
      
      // Skip if cart item or product is null
      if (cartItem?.product?.id == null) continue;
      
      // Check if this cart item matches the product
      if (cartItem!.product!.id == product.id) {
        final itemUpdatedAt = cartItem.updatedAt;
        
        // Update if this is the first match or has a more recent timestamp
        if (_isMoreRecentUpdate(lastUpdatedTime, itemUpdatedAt)) {
          lastIndex = index;
          lastUpdatedTime = itemUpdatedAt;
        }
      }
    }
    
    return lastIndex;
  }

  /// Helper method to determine if the new timestamp is more recent
  bool _isMoreRecentUpdate(DateTime? currentTimestamp, DateTime? newTimestamp) {
    // If we haven't found any item yet, any item is more recent
    if (currentTimestamp == null) return true;
    
    // If new item has no timestamp, it's not more recent
    if (newTimestamp == null) return false;
    
    // Compare timestamps
    return newTimestamp.isAfter(currentTimestamp);
  }

  int getCartProductQuantityCount (Product product) {
    int quantity = 0;
    for(int index = 0; index < _cartList.length; index ++) {
      if(_cartList[index]!.product!.id == product.id ) {
        quantity = quantity + (_cartList[index]!.quantity ?? 0);
      }
    }
    return quantity;
  }


  void setCartUpdate(bool isUpdate) {
    _isCartUpdate = isUpdate;
    if(_isCartUpdate) {
      notifyListeners();
    }

  }

  void onUpdateCartQuantity({required int index, required Product product,  required bool isRemove}) {

    if(!_isProductInCart(product)) {
      final ProductProvider productProvider = Provider.of<ProductProvider>(Get.context!, listen: false);
      int quantity = getCartProductQuantityCount(product) + (isRemove ? -1 : 1);


      if(!isRemove && productProvider.checkStock(product, quantity: quantity) || isRemove) {

        if(isRemove && quantity == 0) {
          removeFromCart(index);
          showCustomSnackBarHelper(getTranslated('this_item_removed_form_cart', Get.context!));

        }else {
          _cartList[index]?.quantity = quantity;
          addToCart(_cartList[index]!, index);

        }
      }else {
        showCustomSnackBarHelper(getTranslated('out_of_stock', Get.context!));

      }
    }else{
      ProductHelper.addToCart(cartIndex: index, product: product);
    }

  }

  bool _isProductInCart(Product product){
    int count = 0;
    for(int index = 0; index < _cartList.length; index ++) {
      if(_cartList[index]!.product!.id == product.id ) {
        count++;
        if(count > 1) {
          return true;
        }
      }
    }
    return false;

  }

  /// Check if product with specific variations exists in cart
  int isExistInCartWithVariation(int? productID, int? cartIndex, List<List<bool?>>? variations) {
    return ProductHelper.findProductWithVariationInCart(
      cartList: _cartList,
      productID: productID,
      cartIndex: cartIndex,
      variations: variations,
    );
  }

}
