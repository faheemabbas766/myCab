class CompanyModel {
  final String cId;
  final String title;
  final String companyAddress;
  final String companyContactPerson;
  final String companyContact;
  final String reference;
  final String createdDate;
  final String createdBy;
  final String updatedDate;
  final String updatedBy;
  final String isActive;
  final String validUpto;

  CompanyModel({
    required this.cId,
    required this.title,
    required this.companyAddress,
    required this.companyContactPerson,
    required this.companyContact,
    required this.reference,
    required this.createdDate,
    required this.createdBy,
    required this.updatedDate,
    required this.updatedBy,
    required this.isActive,
    required this.validUpto,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      cId: json['c_id'],
      title: json['title'],
      companyAddress: json['company_address'],
      companyContactPerson: json['company_cont_prson'],
      companyContact: json['conpany_contact'],
      reference: json['reference'],
      createdDate: json['createddate'],
      createdBy: json['createdby'],
      updatedDate: json['updateddate'],
      updatedBy: json['updatedby'],
      isActive: json['is_active'],
      validUpto: json['valid_upto'],
    );
  }

  static List<CompanyModel> fromJsonArray(List<dynamic> jsonArray) {
    return jsonArray.map((json) => CompanyModel.fromJson(json)).toList();
  }
}
