import 'package:dio/dio.dart';
import 'package:food_score/Remote/api_constant.dart';
import 'package:food_score/Remote/api_exception.dart';
import 'package:velocity_x/velocity_x.dart';

mixin ApiClientMixin {
  final Dio _dio = Dio(BaseOptions(baseUrl: ApiConstant.mainURL));

//^ POST Request Method
  Future<Response> postRequest({
    required String path,
    String? jwtToken,
    required Map body,
  }) async {
    Options options = Options(
      headers: {
        Headers.acceptHeader: "application/json",
        Headers.contentTypeHeader: "application/json",
      },
    );

    if (jwtToken.isNotEmptyAndNotNull) {
      options.headers?.addAll({
        "Authorization": "Bearer $jwtToken",
      });
    }

    try {
      Response response = await _dio.post(path, options: options, data: body);

      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        Vx.log(e.response);

        throw ApiException(
            e.response?.statusCode ?? 401, e.response!.data['message']);
      } else {
        Vx.log('❌ Network Error: ${e.message}');
        throw "Network error occurred";
      }
    }
  }

  //^ PUT Request Method
  Future<Response> putRequest({
    required String path,
    String? jwtToken,
    required Map body,
  }) async {
    Options options = Options(
      headers: {
        Headers.acceptHeader: "application/json",
        Headers.contentTypeHeader: "application/json",
      },
    );

    if (jwtToken.isNotEmptyAndNotNull) {
      options.headers?.addAll({
        "Authorization": "Bearer $jwtToken",
      });
    }

    try {
      
      Response response = await _dio.put(path, options: options, data: body);
      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        throw ApiException(
            e.response?.statusCode ?? 401, e.response!.data['message']);
      } else {
        Vx.log('❌ Network Error: ${e.message}');
        throw "Network error occurred";
      }
    }
  }

  //^ GET Request Method
  Future<Response> getRequest({
    required String path,
    String? jwtToken,
    required Map<String, dynamic>? body,
  }) async {
    Options options = Options(
      headers: {
        Headers.acceptHeader: "application/json",
        Headers.contentTypeHeader: "application/json",
      },
    );

    if (jwtToken.isNotEmptyAndNotNull) {
      options.headers?.addAll({
        "Authorization": "Bearer $jwtToken",
      });
    }

    try {
      Response response = await _dio.get(path, options: options, data: body);

      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        throw ApiException(
            e.response?.statusCode ?? 401, e.response!.data['message']);
      } else {
        Vx.log('❌ Network Error: ${e.message}');
        throw "Network error occurred";
      }
    }
  }

  //^ DELETE Request Method
  Future<Response> deleteRequest({
    required String path,
    String? jwtToken,
    required Map<String, dynamic>? body,
  }) async {
    Options options = Options(
      headers: {
        Headers.acceptHeader: "application/json",
        Headers.contentTypeHeader: "application/json",
      },
    );

    if (jwtToken.isNotEmptyAndNotNull) {
      options.headers?.addAll({
        "Authorization": "Bearer $jwtToken",
      });
    }

    try {
      Response response = await _dio.delete(path, options: options, data: body);

      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        throw ApiException(
            e.response?.statusCode ?? 401, e.response!.data['message']);
      } else {
        Vx.log('❌ Network Error: ${e.message}');
        throw "Network error occurred";
      }
    }
  }
}
