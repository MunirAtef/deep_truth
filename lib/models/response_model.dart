
class ResponseModel<T> {
  T? model;
  String message = "Request failed";
  bool passed = true;

  ResponseModel<T> set(T? model) {
    passed = true;
    return this..model = model;
  }

  ResponseModel<T> failed(String message) {
    passed = false;
    return this..message = message;
  }
}
