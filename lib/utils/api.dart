import 'package:flutter_1/models/profile.dart';
import 'package:http/http.dart' show Client;

class ApiService {
  
  //final String baseUrl = "http://10.0.2.2/rest_ci";
  final String baseUrl = "http://10.10.41.246/rest_ci";
  //final String baseUrl = "http://192.168.1.14/rest_ci";
  Client client = Client();

  //Menampilkan data dari DB
  Future<List<Profile>> getProfiles() async {
    //final response = await client.get("$baseUrl/api/profile");
    final response = await client.get("$baseUrl/index.php/List_Problem");
    if(response.statusCode == 200) {
      return profileFromJson(response.body);
    } else {
      return null;
    }
  }

  //Menambahkan data ke DB
  Future<bool> createProfile (Profile data) async {
    final response = await client.post(
      "$baseUrl/index.php/List_Problem",
      headers: {"content-type": "application/json"},
      body: profileToJson(data),
    );
    if(response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  //Mengupdate data pada DB
  Future<bool> updateProfile (Profile data) async {
    final response = await client.put(
      "$baseUrl/index.php/List_Problem/${data.id}",
      headers: {"content-type" : "application/json"},
      body: profileToJson(data),
    );
    if(response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  //Menghapus data pada DB
  Future<bool> deleteData (int id) async {
    final response = await client.delete(
      "$baseUrl/index.php/List_Problem/$id",
      headers: {"content-type" : "application/json"},
    );
    if(response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

}