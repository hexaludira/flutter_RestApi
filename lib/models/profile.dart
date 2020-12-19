import 'dart:convert';

class Profile {
  String id;
  String nama;
  String nomor;
  //int age;

  Profile({this.id, this.nama, this.nomor});

  factory Profile.fromJson(Map<String, dynamic> map) {
    return Profile(
      id:map["id"], nama: map["nama"], nomor: map["nomor"]
    );
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "nama": nama, "nomor": nomor};
  }

  @override
  String toString() {
    return 'Profile{id: $id, nama: $nama, nomor: $nomor}';
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

