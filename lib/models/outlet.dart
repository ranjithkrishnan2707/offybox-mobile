class Outlet {
  final String id;
  final String companyName;
  final String? email;
  final String? phone;
  final String? mobile;
  final String creditLimit;
  final String outstanding;
  final String? outletType;
  final String status;
  final String? gstn;
  final String? outletCategoryId;
  final String? salesPersonId;
<<<<<<< HEAD
  final LedgerGroup? outletCategory;
=======
  final OutletCategory? outletCategory;
>>>>>>> source/main
  final SalesPerson? salesPerson;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  
  // Addresses array
  final List<OutletAddress> addresses;
  
  // Contact person fields
  final String? contactPersonName;
  final String? contactPersonPhone;
  final String? contactPersonEmail;
  final String? contactPersonDesignation;

  Outlet({
    required this.id,
    required this.companyName,
    this.email,
    this.phone,
    this.mobile,
    required this.creditLimit,
    required this.outstanding,
    this.outletType,
    required this.status,
    this.gstn,
    this.outletCategoryId,
    this.salesPersonId,
    this.outletCategory,
    this.salesPerson,
    this.createdAt,
    this.updatedAt,
    this.addresses = const [],
    this.contactPersonName,
    this.contactPersonPhone,
    this.contactPersonEmail,
    this.contactPersonDesignation,
  });

  factory Outlet.fromJson(Map<String, dynamic> json) {
<<<<<<< HEAD
    // Try to find the ID from various common fields
    final id = (json['id'] ?? json['_id'] ?? json['uuid'])?.toString() ?? '';
    
    return Outlet(
      id: id,
=======
    return Outlet(
      id: json['id'] ?? '',
>>>>>>> source/main
      companyName: json['company_name'] ?? '',
      email: json['email'],
      phone: json['phone'],
      mobile: json['mobile'],
<<<<<<< HEAD
      creditLimit: json['credit_limit']?.toString() ?? '0',
      outstanding: json['outstanding']?.toString() ?? '0',
      outletType: json['outlet_type'],
      status: json['status']?.toString() ?? '',
      gstn: json['gstn'],
      outletCategoryId: json['outlet_category_id']?.toString(),
      salesPersonId: json['sales_person_id']?.toString(),
      outletCategory: json['outlet_category'] != null
          ? LedgerGroup.fromJson(json['outlet_category'])
=======
      creditLimit: json['credit_limit'] ?? '0',
      outstanding: json['outstanding'] ?? '0',
      outletType: json['outlet_type'],
      status: json['status'] ?? '',
      gstn: json['gstn'],
      outletCategoryId: json['outlet_category_id'],
      salesPersonId: json['sales_person_id'],
      outletCategory: json['outlet_category'] != null
          ? OutletCategory.fromJson(json['outlet_category'])
>>>>>>> source/main
          : null,
      salesPerson: json['sales_person'] != null
          ? SalesPerson.fromJson(json['sales_person'])
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
<<<<<<< HEAD
      // Addresses array (trying both 'addresses' and 'outlet_addresses')
      addresses: ((json['addresses'] ?? json['outlet_addresses']) as List<dynamic>?)
=======
      // Addresses array
      addresses: (json['addresses'] as List<dynamic>?)
>>>>>>> source/main
              ?.map((e) => OutletAddress.fromJson(e))
              .toList() ??
          [],
      // Contact person
      contactPersonName: json['contact_person_name'] ?? json['contact_name'],
      contactPersonPhone: json['contact_person_phone'] ?? json['contact_phone'],
      contactPersonEmail: json['contact_person_email'] ?? json['contact_email'],
      contactPersonDesignation: json['contact_person_designation'] ?? json['contact_designation'],
    );
  }

  // Get billing address
  OutletAddress? get billingAddress {
    try {
      return addresses.firstWhere((a) => a.type.toLowerCase() == 'billing');
    } catch (_) {
      return addresses.isNotEmpty ? addresses.first : null;
    }
  }

  // Get shipping address
  OutletAddress? get shippingAddress {
    try {
      return addresses.firstWhere((a) => a.type.toLowerCase() == 'shipping');
    } catch (_) {
      return null;
    }
  }

  bool get hasAddresses => addresses.isNotEmpty;

  bool get hasContactPerson =>
      (contactPersonName != null && contactPersonName!.isNotEmpty) ||
      (contactPersonPhone != null && contactPersonPhone!.isNotEmpty) ||
      (contactPersonEmail != null && contactPersonEmail!.isNotEmpty);
<<<<<<< HEAD

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Outlet && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
=======
>>>>>>> source/main
}

class OutletAddress {
  final String id;
  final String type;
  final String? name;
  final String? address1;
  final String? address2;
  final String? pincode;
  final String? countryId;
  final String? stateId;
  final String? cityId;
  final String status;

  OutletAddress({
    required this.id,
    required this.type,
    this.name,
    this.address1,
    this.address2,
    this.pincode,
    this.countryId,
    this.stateId,
    this.cityId,
    required this.status,
  });

  factory OutletAddress.fromJson(Map<String, dynamic> json) {
    return OutletAddress(
<<<<<<< HEAD
      id: json['id']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      name: json['name']?.toString(),
      address1: json['address1']?.toString(),
      address2: json['address2']?.toString(),
      pincode: json['pincode']?.toString(),
      countryId: json['country_id']?.toString(),
      stateId: json['state_id']?.toString(),
      cityId: json['city_id']?.toString(),
      status: json['status']?.toString() ?? '',
=======
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      name: json['name'],
      address1: json['address1'],
      address2: json['address2'],
      pincode: json['pincode'],
      countryId: json['country_id'],
      stateId: json['state_id'],
      cityId: json['city_id'],
      status: json['status'] ?? '',
>>>>>>> source/main
    );
  }

  String get fullAddress {
    final parts = <String>[];
    if (address1 != null && address1!.isNotEmpty) parts.add(address1!);
    if (address2 != null && address2!.isNotEmpty) parts.add(address2!);
    if (pincode != null && pincode!.isNotEmpty) parts.add(pincode!);
    return parts.join(', ');
  }

  bool get hasAddress => fullAddress.isNotEmpty;
<<<<<<< HEAD

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OutletAddress && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class LedgerGroup {
=======
}

class OutletCategory {
>>>>>>> source/main
  final String id;
  final String name;
  final String status;

<<<<<<< HEAD
  LedgerGroup({
=======
  OutletCategory({
>>>>>>> source/main
    required this.id,
    required this.name,
    required this.status,
  });

<<<<<<< HEAD
  factory LedgerGroup.fromJson(Map<String, dynamic> json) {
    return LedgerGroup(
      id: json['id']?.toString() ?? '',
=======
  factory OutletCategory.fromJson(Map<String, dynamic> json) {
    return OutletCategory(
      id: json['id'] ?? '',
>>>>>>> source/main
      name: json['name'] ?? '',
      status: json['status'] ?? '',
    );
  }
}

class SalesPerson {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String? phone;
  final String code;

  SalesPerson({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phone,
    required this.code,
  });

  factory SalesPerson.fromJson(Map<String, dynamic> json) {
    return SalesPerson(
<<<<<<< HEAD
      id: json['id']?.toString() ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone']?.toString(),
      code: json['code']?.toString() ?? '',
=======
      id: json['id'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      code: json['code'] ?? '',
>>>>>>> source/main
    );
  }

  String get fullName => '$firstName $lastName';
}

<<<<<<< HEAD
class LookupItem {
  final String id;
  final String name;

  LookupItem({
    required this.id,
    required this.name,
  });

  factory LookupItem.fromJson(Map<String, dynamic> json) {
    return LookupItem(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
    );
  }
}

=======
>>>>>>> source/main
class OutletListResponse {
  final List<Outlet> data;
  final int page;
  final int limit;
  final int total;
  final int totalPages;

  OutletListResponse({
    required this.data,
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
  });

  factory OutletListResponse.fromJson(Map<String, dynamic> json) {
    return OutletListResponse(
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => Outlet.fromJson(e))
              .toList() ??
          [],
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 10,
      total: json['total'] ?? 0,
      totalPages: json['total_pages'] ?? 0,
    );
  }
}
