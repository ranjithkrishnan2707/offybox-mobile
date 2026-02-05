import 'package:flutter/material.dart';
import '../../services/product_service.dart';
import '../../services/outlet_service.dart';
import '../../models/outlet.dart';

class ProductFormScreen extends StatefulWidget {
  const ProductFormScreen({super.key});

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  final _nameController = TextEditingController();
  final _codeController = TextEditingController();
  final _hsnController = TextEditingController();
  final _barcodeController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _mrpController = TextEditingController(text: '0');
  final _sellingPriceController = TextEditingController(text: '0');
  
  // Lookups
  List<LookupItem> _categories = [];
  List<LookupItem> _brands = [];
  List<LookupItem> _units = [];
  List<LookupItem> _taxes = [];
  
  LookupItem? _selectedCategory;
  LookupItem? _selectedBrand;
  LookupItem? _selectedUnit;
  LookupItem? _selectedTax;
  
  String _status = 'ACTIVE';
  
  bool _isLoading = true;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _fetchLookups();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _hsnController.dispose();
    _barcodeController.dispose();
    _descriptionController.dispose();
    _mrpController.dispose();
    _sellingPriceController.dispose();
    super.dispose();
  }

  Future<void> _fetchLookups() async {
    try {
      final results = await Future.wait([
        ProductService.getCategories(),
        ProductService.getBrands(),
        ProductService.getUnits(),
        ProductService.getTaxes(),
      ]);

      if (mounted) {
        setState(() {
          if (results[0]['success']) _categories = results[0]['data'] as List<LookupItem>;
          if (results[1]['success']) _brands = results[1]['data'] as List<LookupItem>;
          if (results[2]['success']) _units = results[2]['data'] as List<LookupItem>;
          if (results[3]['success']) _taxes = results[3]['data'] as List<LookupItem>;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        // We can still proceed even if lookups fail, using text inputs or empty lists
      }
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final payload = {
      'name': _nameController.text,
      'code': _codeController.text,
      'category_id': _selectedCategory?.id,
      'brand_id': _selectedBrand?.id,
      'unit_id': _selectedUnit?.id,
      'hsn_code': _hsnController.text,
      'barcode': _barcodeController.text,
      'description': _descriptionController.text,
      'mrp': _mrpController.text,
      'sale_price': _sellingPriceController.text,
      'tax_id': _selectedTax?.id,
      'tax_rate': _selectedTax?.name.replaceAll(RegExp(r'[^0-9.]'), ''), // Extracting number if needed
      'status': _status,
    };

    final result = await ProductService.createProduct(payload);

    if (mounted) {
      setState(() => _isSubmitting = false);
      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product created successfully')),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? 'Failed to create product')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF7C3AED),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Add New Product', style: TextStyle(fontWeight: FontWeight.w600)),
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator(color: Color(0xFF7C3AED)))
        : SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   _buildSectionHeader('Basic Details'),
                  const SizedBox(height: 16),
                  
                  _buildLabel('Product Name *'),
                  _buildTextField(_nameController, 'Enter product name', 
                    validator: (v) => v == null || v.isEmpty ? 'Name is required' : null),
                  
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('Product Code'),
                            _buildTextField(_codeController, 'ERP/SKU Code'),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('HSN Code'),
                            _buildTextField(_hsnController, 'HSN Code'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  _buildLabel('Barcode'),
                  _buildTextField(_barcodeController, 'Scan or enter barcode'),
                  
                  const SizedBox(height: 24),
                  _buildSectionHeader('Categorization'),
                  const SizedBox(height: 16),
                  
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('Category'),
                            _buildLookupDropdown('Category', _categories, _selectedCategory, (v) => setState(() => _selectedCategory = v)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('Brand'),
                            _buildLookupDropdown('Brand', _brands, _selectedBrand, (v) => setState(() => _selectedBrand = v)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  _buildLabel('Unit'),
                  _buildLookupDropdown('Unit', _units, _selectedUnit, (v) => setState(() => _selectedUnit = v)),
                  
                  const SizedBox(height: 24),
                  _buildSectionHeader('Pricing & Stock'),
                  const SizedBox(height: 16),
                  
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('MRP *'),
                            _buildTextField(_mrpController, '0.00', keyboardType: TextInputType.number),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('Selling Price *'),
                            _buildTextField(_sellingPriceController, '0.00', keyboardType: TextInputType.number),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                             _buildLabel('Tax'),
                             _buildLookupDropdown('Tax', _taxes, _selectedTax, (v) => setState(() => _selectedTax = v)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                             _buildLabel('Status'),
                             _buildStatusDropdown(),
                          ],
                        ),
                      ),
                    ],
                  ),

                  _buildLabel('Description'),
                  _buildTextField(_descriptionController, 'Enter product description', maxLines: 3),
                  
                  const SizedBox(height: 40),
                  _buildActionButtons(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF7C3AED).withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: const Border(left: BorderSide(color: Color(0xFF7C3AED), width: 4)),
      ),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1F2937)),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 16),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF374151), fontSize: 13),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, {TextInputType? keyboardType, String? Function(String?)? validator, int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      maxLines: maxLines,
      decoration: _inputDecoration(hint: hint),
      style: const TextStyle(fontSize: 14),
    );
  }

  Widget _buildLookupDropdown(String label, List<LookupItem> items, LookupItem? selectedItem, Function(LookupItem?) onChanged) {
    return DropdownButtonFormField<LookupItem>(
      value: selectedItem,
      hint: Text('Select $label', style: const TextStyle(fontSize: 14, color: Colors.grey)),
      decoration: _inputDecoration(),
      items: items.map((item) => DropdownMenuItem(value: item, child: Text(item.name, style: const TextStyle(fontSize: 14)))).toList(),
      onChanged: onChanged,
      isExpanded: true,
      icon: const Icon(Icons.keyboard_arrow_down, size: 20),
    );
  }

  Widget _buildStatusDropdown() {
    return DropdownButtonFormField<String>(
      value: _status,
      decoration: _inputDecoration(),
      items: ['ACTIVE', 'INACTIVE'].map((s) => DropdownMenuItem(value: s, child: Text(s, style: const TextStyle(fontSize: 14)))).toList(),
      onChanged: (v) => setState(() => _status = v!),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: BorderSide(color: Colors.grey.shade300),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: _isSubmitting ? null : _handleSubmit,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7C3AED),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 4,
              shadowColor: const Color(0xFF7C3AED).withOpacity(0.4),
            ),
            child: _isSubmitting 
              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
              : const Text('Create Product', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration({String? hint}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF7C3AED), width: 1.5)),
      filled: true,
      fillColor: Colors.grey.shade50,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }
}
