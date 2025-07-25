class CircleAreaModel {
  String? name;
  double? lat;
  double? lon;
  double? rad;
  String? alrmPath;

  CircleAreaModel({this.name, this.lat, this.lon, this.rad, this.alrmPath});

  CircleAreaModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    lat = json['lat'];
    lon = json['lon'];
    rad = json['rad'];
    alrmPath = json['alrm_path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['lat'] = this.lat;
    data['lon'] = this.lon;
    data['rad'] = this.rad;
    data['alrm_path'] = this.alrmPath;
    return data;
  }
}
