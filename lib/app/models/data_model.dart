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

class DataPaginationInModel<T> {
  late int pageSize;
  late int pageNo;
  late int totalCount;
  late int totalPage;
  late T data;
  DataPaginationInModel(
      {required this.pageSize,
      required this.pageNo,
      required this.totalCount,
      required this.totalPage,
      required this.data});
  factory DataPaginationInModel.fromJson(Map<String, dynamic> json) {
    return DataPaginationInModel(
        pageSize: json['pageSize'],
        pageNo: json['pageNo'],
        totalCount: json['totalCount'],
        totalPage: json['totalPage'],
        data: json['data'] as T
        // 初始化其他属性
        );
  }
}

class DataPaginationFinalModel<T> {
  final int code;
  final String message;
  final DataPaginationInModel<T> data;
  DataPaginationFinalModel(
      {required this.code, required this.message, required this.data});
  factory DataPaginationFinalModel.fromJson(Map<String, dynamic> json) {
    return DataPaginationFinalModel(
        code: json['code'],
        message: json['message'],
        data: DataPaginationInModel.fromJson(json['data'])
        // 初始化其他属性
        );
  }
}
