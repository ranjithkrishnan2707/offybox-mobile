import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/outlet.dart';
import '../../services/payment_service.dart';
import '../../services/outlet_service.dart';

class PaymentFormScreen extends StatefulWidget {
  const PaymentFormScreen({super.key});

  @override
  State<PaymentFormScreen> createState() => _PaymentFormScreenState();
}

class _PaymentFormScreenState extends State<PaymentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  
  List<Outlet> _ledgers = [];
  Outlet? _selectedLedger;
  DateTime _paymentDate = DateTime.now();
  String _paymentMode = 'CASH';
  String _status = 'SUCCESS';
  
  final _amountController = TextEditingController();
  final _referenceController = TextEditingController();
  final _remarksController = TextEditingController();
  
  bool _isLoading = true;
  bool _isSubmitting = false;

  final List<String> _paymentModes = ['CASH', 'BANK TRANSFER', 'CHEQUE', 'UPI', 'CARD', 'OTHER'];
  final List<String> _statuses = ['SUCCESS', 'PENDING', 'FAILED'];

  @override
  void initState() {
    super.initState();
    _fetchInitialData();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _referenceController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  Future<void> _fetchInitialData() async {
    try {
      final result = await OutletService.getOutlets(limit: 100);
      if (mounted) {
        setState(() {
          if (result['success']) {
            _ledgers = (result['data'] as OutletListResponse).data;
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading ledgers: $e')),
        );
      }
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedLedger == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a ledger')));
      return;
    }

    setState(() => _isSubmitting = true);

    final payload = {
      'outlet_id': _selectedLedger!.id,
      'payment_date': DateFormat('yyyy-MM-dd').format(_paymentDate),
      'amount': _amountController.text,
      'payment_mode': _paymentMode,
      'reference_no': _referenceController.text,
      'remarks': _remarksController.text,
      'status': _status,
    };

    final result = await PaymentService.createPayment(payload);

    if (mounted) {
      setState(() => _isSubmitting = false);
      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Payment recorded successfully')),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? 'Failed to record payment')),
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
        title: const Text('New Payment', style: TextStyle(fontWeight: FontWeight.w600)),
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
                  _buildSectionHeader('Payment Details'),
                  const SizedBox(height: 16),
                  
                  _buildLabel('Select Ledger *'),
                  _buildLedgerDropdown(),
                  
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('Amount *'),
                            _buildTextField(_amountController, '0.00', keyboardType: TextInputType.number, 
                              validator: (v) => v == null || v.isEmpty ? 'Amount is required' : null),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('Payment Date'),
                            _buildDateField(),
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
                            _buildLabel('Payment Mode'),
                            _buildDropdown(_paymentMode, _paymentModes, (v) => setState(() => _paymentMode = v!)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('Status'),
                            _buildDropdown(_status, _statuses, (v) => setState(() => _status = v!)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  _buildLabel('Reference Number'),
                  _buildTextField(_referenceController, 'Check No / Transaction ID'),
                  
                  _buildLabel('Remarks'),
                  _buildTextField(_remarksController, 'Enter Remarks', maxLines: 3),
                  
                  const SizedBox(height: 40),
                  _buildActionButtons(),
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

  Widget _buildLedgerDropdown() {
    return DropdownButtonFormField<Outlet>(
      value: _selectedLedger,
      hint: const Text('Select Ledger', style: TextStyle(fontSize: 14)),
      decoration: _inputDecoration(),
      items: _ledgers.map((l) => DropdownMenuItem(value: l, child: Text(l.companyName, style: const TextStyle(fontSize: 14), overflow: TextOverflow.ellipsis))).toList(),
      onChanged: (v) => setState(() => _selectedLedger = v),
      isExpanded: true,
    );
  }

  Widget _buildDropdown(String value, List<String> items, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: _inputDecoration(),
      items: items.map((s) => DropdownMenuItem(value: s, child: Text(s, style: const TextStyle(fontSize: 14)))).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildDateField() {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: _paymentDate,
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (picked != null) setState(() => _paymentDate = picked);
      },
      child: IgnorePointer(
        child: TextFormField(
          controller: TextEditingController(text: DateFormat('MM/dd/yyyy').format(_paymentDate)),
          decoration: _inputDecoration(suffixIcon: const Icon(Icons.calendar_today, size: 18)),
          style: const TextStyle(fontSize: 14),
        ),
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
              : const Text('Save Payment', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration({String? hint, Widget? suffixIcon}) {
    return InputDecoration(
      hintText: hint,
      suffixIcon: suffixIcon,
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
