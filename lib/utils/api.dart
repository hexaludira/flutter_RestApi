import 'package:flutter_1/models/profile.dart';
import 'package:http/http.dart' show Client;

class ApiService {
  
  //final String baseUrl = "http://api.bengkelrobot.net:8001";
  final String baseUrl = "http://10.10.41.246/rest_ci";
  Client client = Client();

  Future<List<Profile>> getProfiles() async {
    //final response = await client.get("$baseUrl/api/profile");
    final response = await client.get("$baseUrl/index.php/kontak");
    if(response.statusCode == 200) {
      return profileFromJson(response.body);
    } else {
      return null;
    }
  }

}