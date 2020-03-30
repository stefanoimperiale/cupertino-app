import 'package:babynames/model/product.dart';
import 'package:babynames/model/products_repository.dart';
import 'package:flutter/foundation.dart' as foundation;

double _salesTaxRate = 0.06;
double _shippingCostPerItem = 7;

class AppStateModel extends foundation.ChangeNotifier {
  // All available products
  List<Product> _availableProducts;

  // The currently selected category of products.
  Category _selectedCategory = Category.all;

  // The IDs and quantities of products currently in the cart.
  final _productsInCart = <int, int>{};

  Map<int, int> get productsInCart => Map.from(_productsInCart);

  // Total number of items in cart.
  int get totalCartQuantity => _productsInCart.values
      .fold(0, (accumulator, value) => accumulator + value);

  Category get selectedCategory => _selectedCategory;

  // Totaled prices of the item in the cart.
  double get subtotalCost => _productsInCart.keys
      .map((id) => _availableProducts[id].price * _productsInCart[id])
      .fold(0, (accumulator, extendedPrice) => accumulator + extendedPrice);

  // Total shipping cost for the items in the cart.
  double get shippingCost =>
      _shippingCostPerItem *
      _productsInCart.values
          .fold(0.0, (accumulator, itemCount) => accumulator + itemCount);

  // Sales tax for the items in the cart
  double get tax => subtotalCost * _salesTaxRate;

  // Total cost to order everything in the cart.
  double get totalCost => subtotalCost + shippingCost + tax;

  // Returns a copy of the list of available products, filtered by category.
  List<Product> getProducts() {
    if (_availableProducts == null) {
      return [];
    }

    if (_selectedCategory == Category.all) {
      return List.from(_availableProducts);
    } else {
      return _availableProducts
          .where((p) => p.category == _selectedCategory)
          .toList();
    }
  }

  // Search the product catalog
  List<Product> search(String searchTerms) => getProducts().where((product) =>
      product.name.toLowerCase().contains(searchTerms.toLowerCase())).toList();

  // Add a product to the cart.
  void addProductToCart(int productId) {
    if (!_productsInCart.containsKey(productId)) {
      _productsInCart[productId] = 1;
    } else {
      _productsInCart[productId]++;
    }

    notifyListeners();
  }

  // Removes an item from the cart.
  void removeItemFromCart(int productId) {
    if (_productsInCart.containsKey(productId)) {
      if (_productsInCart[productId] == 1) {
        _productsInCart.remove(productId);
      } else {
        _productsInCart[productId]--;
      }
    }
    notifyListeners();
  }

  // Returns the Product instance matching the provided id.
  Product getProductById(int id) =>
      _availableProducts.firstWhere((p) => p.id == id);

  // Removes everything from cart.
  void clearCart() {
    _productsInCart.clear();
    notifyListeners();
  }

  // Loads the list of available products from the repo.
  void loadProducts()  async {
    _availableProducts = await ProductsRepository.loadProducts(Category.all);
    notifyListeners();
  }

  setCategory(Category newCategory) {
    _selectedCategory = newCategory;
    notifyListeners();
  }
}
