import 'api_service.dart';
import '../models/invoice.dart';

class InvoiceService {
  static Future<Map<String, dynamic>> getInvoices({
    int page = 1,
    int limit = 10,
    String? search,
  }) async {
    final queryParams = <String, String>{
      'page': page.toString(),
      'limit': limit.toString(),
      'order_type': 'INVOICE', // Following the pattern for Quotations
    };

    if (search != null && search.isNotEmpty) {
      queryParams['search'] = search;
    }

    // Using the same API endpoint as Quotations (Orders endpoint)
    final result = await ApiService.get(ApiService.ENDPOINT_ORDERS, queryParams: queryParams);

    if (result['success']) {
      try {
        final response = InvoiceListResponse.fromJson(result['data']);
        return {
          'success': true,
          'data': response,
        };
      } catch (e) {
        print('Error parsing invoices: $e');
        return {
          'success': false,
          'message': 'Error parsing invoice data',
        };
      }
    }

    return result;
  }

  static Future<Map<String, dynamic>> createInvoice(Map<String, dynamic> data) async {
    // Ensuring the order_type is INVOICE if not already set
    if (!data.containsKey('order_type')) {
      data['order_type'] = 'INVOICE';
    }
    // Using the same API endpoint as Quotations (Orders endpoint)
    return await ApiService.post(ApiService.ENDPOINT_ORDERS, data);
  }
}
