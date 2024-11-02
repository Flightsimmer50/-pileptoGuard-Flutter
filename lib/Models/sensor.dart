class Sensor {
  String? id;
  String? userId;
  List<num>? imu;
  List<num>? emg;
  List<num>? bmp;

  Sensor({
    this.id,
    this.userId,
    this.imu,
    this.emg,
    this.bmp,
  });

  factory Sensor.fromJson(Map<String, dynamic> json) {
    return Sensor(
      id: json['_id'],
      userId: json['user'],
      imu: (json['imu'] as List<dynamic>).map((e) => e as num).toList(),
      emg: (json['emg'] as List<dynamic>).map((e) => e as num).toList(),
      bmp: (json['bmp'] as List<dynamic>).map((e) => e as num).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'user': userId,
      'imu': imu,
      'emg': emg,
      'bmp': bmp,
    };
    if (id != null) data['_id'] = id;
    return data;
  }
}
