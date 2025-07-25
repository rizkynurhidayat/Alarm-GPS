class LocationModel {
  String? name;
  double? lat;
  double? lon;
  String? timestamp;
  bool? isEntry;

  LocationModel({this.name, this.lat, this.lon, this.timestamp, this.isEntry});

  LocationModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    lat = json['lat'];
    lon = json['lon'];
    timestamp = json['timestamp'];
    isEntry = json['isEntry'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['lat'] = this.lat;
    data['lon'] = this.lon;
    data['timestamp'] = this.timestamp;
    data['isEntry'] = this.isEntry;
    return data;
  }
}
