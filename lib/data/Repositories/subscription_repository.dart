import 'dart:io';

import '../../utils/api.dart';
import '../../utils/hive_utils.dart';
import '../model/data_output.dart';
import '../model/subscription_pacakage_model.dart';

class SubscriptionRepository {
  Future<DataOutput<SubscriptionPackageModel>> getSubscriptionPacakges() async {
    Map<String, dynamic> response = await Api.get(
        url: Api.getPackage,
        queryParameters: {"platform": Platform.isIOS ? "ios" : "android"});

    List<SubscriptionPackageModel> modelList = (response['data'] as List)
        .map((element) => SubscriptionPackageModel.fromJson(element))
        .toList();

    return DataOutput(total: modelList.length, modelList: modelList);
  }

  Future<void> subscribeToPackage(
      int packageId, bool isPackageAvailable) async {
    try {
      Map<String, dynamic> parameters = {
        Api.packageId: packageId,
        Api.userid: HiveUtils.getUserId(),
        if (isPackageAvailable) 'flag': 1,
      };

      await Api.post(
        url: Api.userPurchasePackage,
        parameter: parameters,
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> assignFreePackage(int packageId) async {
    await Api.post(
        url: Api.assignPackage,
        parameter: {"package_id": packageId, "in_app": false});
  }

  Future<void> assignPackage({
    required String packageId,
    required String productId,
  }) async {
    try {
      await Api.post(url: Api.assignPackage, parameter: {
        "package_id": packageId,
        "product_id": productId,
        "in_app": true,
      });
    } catch (e) {
      throw "e:$e";
    }
  }
}
