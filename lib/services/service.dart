import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {

  String commonUrl = 'http://humble-winding.000webhostapp.com/api.php';

  Future<List<dynamic>> getSensorData() async {
    final url = Uri.parse(commonUrl);
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
      //  print(responseData);
        return responseData;
      }
    } catch (error) {
      throw error;
    }
    return [];
  }

}