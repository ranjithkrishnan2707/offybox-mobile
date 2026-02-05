import 'api_service.dart';
import '../models/product.dart';
import '../models/outlet.dart'; // For LookupItem

class ProductService {
  static Future<Map<String, dynamic>> getProducts({
    int page = 1,
    int limit = 100,
    String? search,
  }) async {
    final queryParams = <String, String>{
      'page': page.toString(),
      'limit': limit.toString(),
    };

    if (search != null && search.isNotEmpty) {
      queryParams['search'] = search;
    }

    final result = await ApiService.get(ApiService.ENDPOINT_PRODUCTS, queryParams: queryParams);
    print('ProductService.getProducts result: $result');

    if (result['success']) {
      try {
        final body = result['data'];
        final List dataList;
        
        if (body is List) {
          dataList = body;
        } else if (body is Map) {
          // Check for 'data' key which might contain the list or another nested 'data'
          if (body['data'] is List) {
            dataList = body['data'];
          } else if (body['data'] is Map && body['data']['data'] is List) {
            dataList = body['data']['data'];
          } else {
            dataList = [];
          }
        } else {
          dataList = [];
        }

        final products = dataList
            .map((e) => Product.fromJson(e as Map<String, dynamic>))
            .toList();
            
        return {
          'success': true,
          'data': products,
        };
      } catch (e) {
        print('Error parsing products: $e');
        return {
          'success': false,
          'message': 'Error processing product data. Please contact support.',
        };
      }
    }

    return result;
  }

  static Future<Map<String, dynamic>> createProduct(Map<String, dynamic> data) async {
    return await ApiService.post(ApiService.ENDPOINT_PRODUCTS, data);
  }

  static Future<Map<String, dynamic>> _fetchLookup(String endpoint, {bool paginated = true}) async {
    final queryParams = paginated ? {'page': '1', 'limit': '1000'} : <String, String>{};
    final result = await ApiService.get(endpoint, queryParams: queryParams);
    
    if (result['success']) {
      final body = result['data'];
      final List dataList;
      if (body is List) {
        dataList = body;
      } else if (body is Map && body.containsKey('data')) {
        final data = body['data'];
        if (data is List) {
          dataList = data;
        } else if (data is Map && data.containsKey('data') && data['data'] is List) {
          dataList = data['data'];
        } else {
          dataList = [];
        }
      } else {
        dataList = [];
      }
      
      final items = dataList.map((e) => LookupItem.fromJson(e)).toList();
      return {'success': true, 'data': items};
    }
    return result;
  }

  static Future<Map<String, dynamic>> getCategories() => _fetchLookup(ApiService.ENDPOINT_CATEGORIES);
  static Future<Map<String, dynamic>> getBrands() => _fetchLookup(ApiService.ENDPOINT_BRANDS);
  static Future<Map<String, dynamic>> getUnits() => _fetchLookup(ApiService.ENDPOINT_UNITS);
  static Future<Map<String, dynamic>> getTaxes() => _fetchLookup(ApiService.ENDPOINT_TAXES, paginated: false);
}
