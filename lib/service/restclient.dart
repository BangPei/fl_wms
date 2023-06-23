import 'package:dio/dio.dart';
import 'package:fl_wms/screen/brand/data/brand.dart';
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
  Future<dynamic> postBrand(@Body() Brand brand);

  @PUT("brand/{id}")
  Future putBrand(@Path() int id, @Body() Brand brand);

  @DELETE("brand/{id}")
  Future<dynamic> deleteBrand(@Path() int id);
}
