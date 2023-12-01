import 'response.dart';

class SuccesResponse implements QueryResponse {
  SuccesResponse({required this.data});
  final dynamic data;
  final int requestCode = 200;
  @override
  Map<String, dynamic> toJson() => {'data': data};

  @override
  int statusCode() {
    return requestCode;
  }
}
