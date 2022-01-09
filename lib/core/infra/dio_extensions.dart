import 'dart:io' show SocketException;

import 'package:dio/dio.dart';

extension DioErrorX on DioError {
  bool get isNoConnection {
    if (type == DioErrorType.other && error is SocketException) {
      return true;
    }
    return false;
  }
}
