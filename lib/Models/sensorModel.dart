class SensorModel {
  String? id;
  List<int>? emg;
  List<int>? bmp;
  DateTime? updatedAt;

  SensorModel(
      this.id,
      this.emg,
      this.bmp,
      this.updatedAt,
      );

  SensorModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    emg = List<int>.from(json['emg']);
    bmp = List<int>.from(json['bmp']);
    updatedAt = DateTime.parse(json['updatedAt']);

    // if (json['bmp'] is String) {
    //   bmp = int.parse(json['bmp']);
    // } else {
    //   bmp = json['bmp'] is int ? json['bmp'] : 0;
    // }
  }
}