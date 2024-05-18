import 'package:otlub_multivendor/common/widgets/rating_bar_widget.dart';
import 'package:otlub_multivendor/features/auth/controllers/auth_controller.dart';
import 'package:otlub_multivendor/features/order/controllers/order_controller.dart';
import 'package:otlub_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:otlub_multivendor/features/order/domain/models/order_model.dart';
import 'package:otlub_multivendor/util/dimensions.dart';
import 'package:otlub_multivendor/util/images.dart';
import 'package:otlub_multivendor/util/styles.dart';
import 'package:otlub_multivendor/features/order/widgets/address_details_widget.dart';
import 'package:otlub_multivendor/common/widgets/custom_divider_widget.dart';
import 'package:otlub_multivendor/common/widgets/custom_image_widget.dart';
import 'package:otlub_multivendor/common/widgets/custom_snackbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

class TrackDetailsView extends StatelessWidget {
  final OrderModel track;
  final Function callback;
  const TrackDetailsView(
      {super.key, required this.track, required this.callback});

  @override
  Widget build(BuildContext context) {
    double distance = 0;
    bool takeAway = track.orderType == 'take_away';
    if (track.deliveryMan != null) {
      distance = Geolocator.distanceBetween(
            double.parse(track.deliveryAddress!.latitude!),
            double.parse(track.deliveryAddress!.longitude!),
            double.parse(track.deliveryMan!.lat ?? '0'),
            double.parse(track.deliveryMan!.lng ?? '0'),
          ) /
          1000;
    }

    return Container(
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
        color: Theme.of(context).cardColor,
      ),
      alignment: Alignment.center,
      child: (!takeAway && track.deliveryMan == null)
          ? Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              child: Text(
                'delivery_man_not_assigned'.tr,
                style: robotoMedium,
                textAlign: TextAlign.center,
              ),
            )
          : Column(children: [
              Text('trip_route'.tr, style: robotoMedium),
              const SizedBox(height: Dimensions.paddingSizeLarge),
              Row(children: [
                Expanded(
                    flex: 3,
                    child: Text(
                      takeAway
                          ? track.deliveryAddress!.address!
                          : track.deliveryMan!.location!,
                      style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeSmall),
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                    )),
                const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                SizedBox(
                    width: 80,
                    child: CustomDividerWidget(
                        color: Theme.of(context).primaryColor, height: 2)),
                Container(
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).primaryColor)),
                const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                Expanded(
                  flex: 5,
                  child: takeAway
                      ? Text(
                          track.restaurant != null
                              ? track.restaurant!.address!
                              : '',
                          style: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeSmall),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        )
                      : AddressDetailsWidget(
                          addressDetails: track.deliveryAddress),
                ),
              ]),
              const SizedBox(height: Dimensions.paddingSizeSmall),
              takeAway
                  ? InkWell(
                      onTap: () async {
                        String url =
                            'https://www.google.com/maps/dir/?api=1&destination=${track.restaurant != null ? track.restaurant!.latitude : '0'}'
                            ',${track.restaurant != null ? track.restaurant!.longitude : '0'}&mode=d';
                        if (await canLaunchUrlString(url)) {
                          Get.find<OrderController>().cancelTimer();
                          await launchUrlString(url,
                              mode: LaunchMode.externalApplication);
                          Get.find<OrderController>().callTrackOrderApi(
                              orderModel:
                                  Get.find<OrderController>().trackModel!,
                              orderId: track.id.toString());
                        } else {
                          showCustomSnackBar('unable_to_launch_google_map'.tr);
                        }
                      },
                      child: Column(children: [
                        Icon(Icons.directions,
                            size: 25, color: Theme.of(context).primaryColor),
                        Text(
                          'direction'.tr,
                          style: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeExtraSmall,
                              color: Theme.of(context).disabledColor),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeSmall),
                      ]),
                    )
                  : Column(children: [
                      Image.asset(Images.route,
                          height: 20,
                          width: 20,
                          color: Theme.of(context).primaryColor),
                      Text(
                        '${distance.toStringAsFixed(2)} ${'km'.tr}',
                        style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeExtraSmall,
                            color: Theme.of(context).disabledColor),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeSmall),
                    ]),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    takeAway ? 'restaurant'.tr : 'delivery_man'.tr,
                    style: robotoMedium.copyWith(
                        fontSize: Dimensions.fontSizeSmall),
                  )),
              const SizedBox(height: Dimensions.paddingSizeExtraSmall),
              Row(children: [
                ClipOval(
                    child: CustomImageWidget(
                  image:
                      '${takeAway ? Get.find<SplashController>().configModel!.baseUrls!.restaurantImageUrl : Get.find<SplashController>().configModel!.baseUrls!.deliveryManImageUrl}/${takeAway ? track.restaurant != null ? track.restaurant!.logo : '' : track.deliveryMan!.image}',
                  height: 35,
                  width: 35,
                  fit: BoxFit.cover,
                )),
                const SizedBox(width: Dimensions.paddingSizeSmall),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text(
                        takeAway
                            ? track.restaurant != null
                                ? track.restaurant!.name!
                                : 'no_restaurant_data_found'.tr
                            : '${track.deliveryMan!.fName} ${track.deliveryMan!.lName}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: robotoMedium.copyWith(
                            fontSize: Dimensions.fontSizeExtraSmall),
                      ),
                      RatingBarWidget(
                        rating: takeAway
                            ? track.restaurant != null
                                ? track.restaurant!.avgRating
                                : 0
                            : track.deliveryMan!.avgRating,
                        size: 10,
                        ratingCount: takeAway
                            ? track.restaurant != null
                                ? track.restaurant!.ratingCount
                                : 0
                            : track.deliveryMan!.ratingCount,
                      ),
                    ])),
                InkWell(
                  onTap: () async {
                    if (await canLaunchUrlString(
                        'tel:${takeAway ? track.restaurant != null ? track.restaurant!.phone : '' : track.deliveryMan!.phone}')) {
                      launchUrlString(
                          'tel:${takeAway ? track.restaurant != null ? track.restaurant!.phone : '' : track.deliveryMan!.phone}',
                          mode: LaunchMode.externalApplication);
                    } else {
                      showCustomSnackBar(
                          '${'can_not_launch'.tr} ${takeAway ? track.restaurant != null ? track.restaurant!.phone : '' : track.deliveryMan!.phone}');
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: Dimensions.paddingSizeExtraSmall,
                        horizontal: Dimensions.paddingSizeSmall),
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(Dimensions.radiusSmall),
                      color: Colors.green,
                    ),
                    child: Text(
                      'call'.tr,
                      style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeExtraSmall,
                          color: Theme.of(context).cardColor),
                    ),
                  ),
                ),
                const SizedBox(width: Dimensions.paddingSizeSmall),
                Get.find<AuthController>().isLoggedIn()
                    ? InkWell(
                        onTap: callback as void Function()?,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: Get.context!.width >= 1300
                                  ? 7
                                  : Dimensions.paddingSizeExtraSmall,
                              horizontal: Dimensions.paddingSizeSmall),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(Dimensions.radiusSmall),
                            color: Colors.green,
                          ),
                          child: Icon(Icons.chat,
                              size: 12, color: Theme.of(context).cardColor),
                        ),
                      )
                    : const SizedBox(),
              ]),
            ]),
    );
  }
}
