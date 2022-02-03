import 'package:http/http.dart' as http;

class CRUD {
  String _baseUrl = "https://simanis.ntbprov.go.id/api";

  postData(String url, Map<String, String> data) async {
    final response = await http.post(Uri.parse(_baseUrl + url), body: data);
    // print('Response status: ${response.statusCode}');
    // print('Response body: ${response.body}');
    return response;
  }

  putData(String url, Map<String, String> data) async {
    final response = await http.put(Uri.parse(_baseUrl + url), body: data);
    // print('Response status : ${response.statusCode}');
    // print('Response body: ${response.body}');
    return response;
  }

  checkLogin(Map<String, String> data) async {
    final response =
        await http.post(Uri.parse(_baseUrl + '/check_login'), body: data);
    // print('Response status: ${response.statusCode}');
    // print('Response body: ${response.body}');
    return response;
  }

  getData(String url) async {
    final response = await http.get(Uri.parse(_baseUrl + url));
    // print('Response status: ${response.statusCode}');
    // print('Response body: ${response.body}');
    return response;
  }
}
