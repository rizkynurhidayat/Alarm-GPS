class RuteModel {
  int? id;
  String? name;
  String? deskripsi;
  String? timestamp;
  bool? isActive;

  RuteModel({
    this.id,
    this.name,
    this.deskripsi,
    this.isActive,
    this.timestamp,
  });

  RuteModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    deskripsi = json['deskripsi'];
    timestamp = json['timestamp'];
    isActive = json['isActive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['deskripsi'] = this.deskripsi;
    data['timestamp'] = this.timestamp;
    data['isActive'] = this.isActive;
    return data;
  }
}
