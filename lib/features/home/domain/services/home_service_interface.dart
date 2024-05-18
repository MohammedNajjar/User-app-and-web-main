import 'package:otlub_multivendor/features/home/domain/models/banner_model.dart';

abstract class HomeServiceInterface {
  Future<BannerModel?> getBannerList();
}
