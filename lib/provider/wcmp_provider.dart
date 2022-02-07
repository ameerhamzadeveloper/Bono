import 'package:bono_gifts/models/wcmp_api/vendor.dart';
import 'package:bono_gifts/models/wcmp_api/vendor_product.dart';
import 'package:bono_gifts/services/sign_up_service.dart';
import 'package:bono_gifts/services/wcmp_service.dart';
import 'package:flutter/material.dart';

enum ApiState {
  none,
  loading,
  completed,
  error,
}

class WooCommerceMarketPlaceProvider extends ChangeNotifier {
  final WooCommerceMarketPlaceService wooCommerceMarketPlaceService =
      WooCommerceMarketPlaceService();
  final SignUpService signUpService = SignUpService();

  ApiState apiState = ApiState.none;

  List<Vendor> allVendors = <Vendor>[];
  List<Vendor> nearbyVendors = <Vendor>[];
  List<Categories> categories = [];
  List<VendorProduct> nearbyVendorProducts = <VendorProduct>[];

  Future<void> fetchVendors(String city) async {
    clearShops();
    apiState = ApiState.loading;
    try {
      allVendors = await wooCommerceMarketPlaceService.getAllVendors();
      nearbyVendors = allVendors.where((element) {
        return element.address?.city!.trim().toLowerCase() ==
            city.trim().toLowerCase();
      }).toList();
      for (Vendor vendor in nearbyVendors) {
        List<VendorProduct> nearbyProducts =
            await wooCommerceMarketPlaceService.getVendorProducts(vendor.id!);
        nearbyVendorProducts.addAll(nearbyProducts);
      }
      for (VendorProduct product in nearbyVendorProducts) {
        if (product.categories != null) {
          bool found = false;
          for (Categories category in categories) {
            if (category.name ==
                product.categories![product.categories!.length - 1].name) {
              found = true;
              break;
            }
          }
          if (!found) {
            categories.add(product.categories![product.categories!.length - 1]);
          }
        }
      }
      apiState = ApiState.completed;
    } catch (e) {
      apiState = ApiState.error;

      print(e.toString());
    }
    notifyListeners();
  }

  List<VendorProduct> filterByCategory(Categories category) {
    return nearbyVendorProducts
        .where((element) =>
            element.categories![element.categories!.length - 1].name ==
            category.name)
        .toList();
  }

  Future<Map<String, dynamic>> getUserInfo(String phone) async {
    return await signUpService.getUser(phone);
  }

  clearShops() {
    nearbyVendors.clear();
    categories.clear();
    allVendors.clear();
    nearbyVendorProducts.clear();
    notifyListeners();
  }
}
