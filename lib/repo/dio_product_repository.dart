import 'package:dio/dio.dart';

import '/constants.dart';
import '/interfaces/product_repository.dart';
import '/models/app_exception.dart';
import '/models/catalog_sort_option.dart';
import '/models/product.dart';
import '/models/product_category.dart';
import '/models/product_list_response.dart';

class DioProductRepository implements ProductRepository {
  final Dio _dio;

  const DioProductRepository({required this._dio});

  @override
  Future<ProductListResponse> getProducts({
    required int limit,
    required int skip,
    String? searchQuery,
    String? categorySlug,
    CatalogSortOption sortOption = CatalogSortOption.popular,
    CancelToken? cancelToken,
  }) async {
    final cleanQuery = searchQuery?.trim() ?? '';
    final cleanCategory = categorySlug?.trim() ?? '';

    final queryParams = <String, Object?>{
      'limit': limit,
      'skip': skip,
    };

    if (sortOption.sortByField != null && sortOption.sortOrder != null) {
      queryParams['sortBy'] = sortOption.sortByField;
      queryParams['order'] = sortOption.sortOrder;
    }

    try {
      if (cleanQuery.isNotEmpty && cleanCategory.isNotEmpty) {
        final categoryParams = <String, Object?>{
          'limit': 0,
          if (sortOption.sortByField != null) 'sortBy': sortOption.sortByField,
          if (sortOption.sortOrder != null) 'order': sortOption.sortOrder,
        };
        final response = await _dio.get<Map<String, Object?>>(
          '${ApiConstants.productsPath}/category/$cleanCategory',
          queryParameters: categoryParams,
          cancelToken: cancelToken,
        );
        final parsed = ProductListResponse.fromJson(
          response.data ?? const <String, Object?>{},
        );
        final needle = cleanQuery.toLowerCase();
        final filtered = parsed.products.where((product) {
          return product.title.toLowerCase().contains(needle) ||
              product.description.toLowerCase().contains(needle) ||
              product.brand.toLowerCase().contains(needle);
        }).toList(growable: false);

        final paged = filtered.skip(skip).take(limit).toList(growable: false);
        return ProductListResponse(
          products: paged,
          total: filtered.length,
          skip: skip,
          limit: limit,
        );
      }

      final String endpoint;
      if (cleanQuery.isNotEmpty) {
        endpoint = ApiConstants.productsSearchPath;
        queryParams['q'] = cleanQuery;
      } else if (cleanCategory.isNotEmpty) {
        endpoint = '${ApiConstants.productsPath}/category/$cleanCategory';
      } else {
        endpoint = ApiConstants.productsPath;
      }

      final response = await _dio.get<Map<String, Object?>>(
        endpoint,
        queryParameters: queryParams,
        cancelToken: cancelToken,
      );

      final data = response.data;
      if (data == null) {
        throw const AppException(
          messageTh: 'ไม่พบข้อมูลตอบกลับจากเซิร์ฟเวอร์',
          messageEn: 'Empty response received from server.',
        );
      }

      return ProductListResponse.fromJson(data);
    } on DioException catch (error) {
      throw _mapDioException(error);
    } catch (error) {
      if (error is AppException) rethrow;
      throw const AppException(
        messageTh: 'เกิดข้อผิดพลาดในการแปลงข้อมูลสินค้า',
        messageEn: 'Failed to parse product catalog response.',
      );
    }
  }

  @override
  Future<Product> getProductById(
    int id, {
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.get<Map<String, Object?>>(
        '${ApiConstants.productsPath}/$id',
        cancelToken: cancelToken,
      );
      final data = response.data;
      if (data == null) {
        throw const AppException(
          messageTh: 'ไม่พบข้อมูลรายละเอียดสินค้า',
          messageEn: 'Product details not found.',
          statusCode: 404,
        );
      }
      return Product.fromJson(data);
    } on DioException catch (error) {
      throw _mapDioException(error);
    } catch (error) {
      if (error is AppException) rethrow;
      throw const AppException(
        messageTh: 'ไม่สามารถโหลดรายละเอียดสินค้าได้',
        messageEn: 'Unable to load product details.',
      );
    }
  }

  @override
  Future<List<ProductCategory>> getCategories({
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.get<List<Object?>>(
        ApiConstants.categoriesPath,
        cancelToken: cancelToken,
      );
      final rawList = response.data ?? const <Object?>[];
      return rawList
          .whereType<Map<Object?, Object?>>()
          .map(
            (item) => ProductCategory.fromJson(
              item.map((k, v) => MapEntry(k.toString(), v)),
            ),
          )
          .where((cat) => cat.slug.isNotEmpty)
          .toList(growable: false);
    } on DioException catch (error) {
      throw _mapDioException(error);
    } catch (error) {
      if (error is AppException) rethrow;
      throw const AppException(
        messageTh: 'ไม่สามารถโหลดหมวดหมู่สินค้าได้',
        messageEn: 'Unable to load product categories.',
      );
    }
  }

  AppException _mapDioException(DioException error) {
    final statusCode = error.response?.statusCode;
    return switch (error.type) {
      DioExceptionType.cancel => const AppException(
          messageTh: 'ยกเลิกคำขอข้อมูล',
          messageEn: 'Request was cancelled.',
          isCancelled: true,
        ),
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.transformTimeout =>
        AppException(
          messageTh:
              'การเชื่อมต่อใช้เวลานานเกินกำหนด กรุณาตรวจสอบอินเทอร์เน็ตแล้วลองใหม่',
          messageEn:
              'Connection timed out. Please check your network and try again.',
          statusCode: statusCode,
        ),
      DioExceptionType.connectionError => AppException(
          messageTh:
              'ไม่สามารถเชื่อมต่อเซิร์ฟเวอร์ได้ กรุณาตรวจสอบการเชื่อมต่ออินเทอร์เน็ต',
          messageEn:
              'Unable to reach the server. Please check your internet connection.',
          statusCode: statusCode,
        ),
      DioExceptionType.badResponse => AppException(
          messageTh: statusCode == 404
              ? 'ไม่พบข้อมูลสินค้าที่ต้องการ (404)'
              : 'เซิร์ฟเวอร์ตอบกลับด้วยข้อผิดพลาด (${statusCode ?? 'Unknown'})',
          messageEn: statusCode == 404
              ? 'Requested product resource was not found (404).'
              : 'Server returned an error (${statusCode ?? 'Unknown'}).',
          statusCode: statusCode,
        ),
      DioExceptionType.badCertificate || DioExceptionType.unknown => AppException(
          messageTh: 'เกิดข้อผิดพลาดในการเชื่อมต่อเครือข่าย กรุณาลองใหม่อีกครั้ง',
          messageEn: 'A network error occurred. Please try again.',
          statusCode: statusCode,
        ),
    };
  }
}