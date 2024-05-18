import 'package:otlub_multivendor/interface/repository_interface.dart';

abstract class InterestRepositoryInterface extends RepositoryInterface {
  Future<bool> saveUserInterests(List<int?> interests);
}
