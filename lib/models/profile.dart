import 'dart:convert';

class Profile {
  String id;
  String date;
  String detail;
  String location;
  String status;
  String remark;
  // String nama;
  // String nomor;
  //int age;

  Profile({this.id, this.date, this.detail, this.location, this.status, this.remark});

  factory Profile.fromJson(Map<String, dynamic> map) {
    return Profile(
      id:map["id"], date: map["date"], detail: map["detail"], location: map["location"], status: map["status"], remark: map["remark"]
    );
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "date": date, "detail": detail, "location": location, "status": status, "remark": remark};
  }

  @override
  String toString() {
    return 'Profile{id: $id, nama: $date, detail: $detail, location: $location, status: $status, remark: $remark}';
  }
}

  List<Profile> profileFromJson (String jsonData) {
    final data = json.decode(jsonData);
    return List<Profile>.from(data.map((item) => Profile.fromJson(item)));

  }

  String profileToJson(Profile data) {
    final jsonData = data.toJson();
    return json.encode(jsonData);
  }

