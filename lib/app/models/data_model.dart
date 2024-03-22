class DataModel {
  final int code;
  final String message;
  final Map<String, dynamic>? data;
  DataModel({required this.code, required this.message, this.data});
  factory DataModel.fromJson(Map<String, dynamic> json) {
    return DataModel(
        code: json['code'], message: json['message'], data: json['data']
        // 初始化其他属性
        );
  }
}

class DataFinalModel<T> {
  final int code;
  final String message;
  late final T? data;
  DataFinalModel({required this.code, required this.message, this.data});
}
