class Brand {
  int? id;
  String? name;
  String? logo;

  Brand({
    this.id,
    this.name,
    this.logo,
  });

  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(
      id: json['id'],
      name: json['brand_name'],
      logo: json['brand_logo_image_path'],
    );
  }
}
