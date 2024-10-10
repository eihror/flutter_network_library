abstract class ApiErrorInterface {
  var code;
  var message;

  T fromMap<T>(Map<String, dynamic> map);
}
