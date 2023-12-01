import 'response.dart';

class ErrorResponse implements QueryResponse {
  ErrorResponse({required this.message, required this.requestCode});
  final String message;
  final int requestCode;
  @override
  Map<String, String> toJson() => {'message': message};

  @override
  int statusCode() {
    return requestCode;
  }
}
