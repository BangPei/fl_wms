import 'package:dio/dio.dart';
import 'package:fl_wms/screen/brand/data/brand.dart';
import 'package:fl_wms/screen/category/data/category.dart';
import 'package:fl_wms/screen/product/data/product.dart';
import 'package:fl_wms/screen/uom/data/uom.dart';
import 'package:fl_wms/screen/warehouse/data/warehouse.dart';
import 'package:retrofit/retrofit.dart';

part 'restclient.g.dart';

@RestApi()
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @GET("brand")
  Future<List<Brand>> getBrands();

  @GET("brand/{id}")
  Future<Brand> getBrand(@Path() int id);

  @POST("brand")
  Future postBrand(@Body() Brand brand);

  @PUT("brand/{id}")
  Future putBrand(@Path() int id, @Body() Brand brand);

  @DELETE("brand/{id}")
  Future<dynamic> deleteBrand(@Path() int id);

  @GET("category")
  Future<List<Category>> getCategories();

  @GET("category/{id}")
  Future<Category> getCategory(@Path() int id);

  @POST("category")
  Future postCategory(@Body() Category category);

  @PUT("category/{id}")
  Future putCategory(@Path() int id, @Body() Category category);

  @DELETE("category/{id}")
  Future<dynamic> deleteCategory(@Path() int id);

  @GET("uom")
  Future<List<Uom>> getUoms();

  @GET("uom/{id}")
  Future<Uom> getUom(@Path() int id);

  @POST("uom")
  Future postUom(@Body() Uom uom);

  @PUT("uom/{id}")
  Future putUom(@Path() int id, @Body() Uom uom);

  @DELETE("uom/{id}")
  Future<dynamic> deleteUom(@Path() int id);

  @GET("warehouse")
  Future<List<Warehouse>> getWarehouses();

  @GET("warehouse/code/{code}")
  Future<Warehouse> getWarehouseByCode(@Path() String code);

  @GET("warehouse/{id}")
  Future<Warehouse> getWarehouse(@Path() int id);

  @POST("warehouse")
  Future postWarehouse(@Body() Warehouse wa);

  @PUT("warehouse/{id}")
  Future putWarehouse(@Path() int id, @Body() Warehouse wa);

  @DELETE("warehouse/{id}")
  Future<dynamic> deleteWarehouse(@Path() int id);

  @GET("product")
  Future<List<Product>> getProducts();

  @GET("product/sku/{sku}")
  Future<Product> getProductBySku(@Path() String sku);

  @GET("product/{id}")
  Future<Product> getProduct(@Path() int id);

  @POST("product")
  Future postProduct(@Body() Product product);

  @PUT("product/{id}")
  Future putProduct(@Path() int id, @Body() Product product);

  @DELETE("product/{id}")
  Future<dynamic> deleteProduct(@Path() int id);
}
