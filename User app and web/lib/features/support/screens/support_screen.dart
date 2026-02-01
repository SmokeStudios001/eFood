import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/models/config_model.dart';
import 'package:flutter_restaurant/common/widgets/custom_asset_image_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_pop_scope_widget.dart';
import 'package:flutter_restaurant/features/support/support_item_widget.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/common/widgets/custom_app_bar_widget.dart';
import 'package:flutter_restaurant/common/widgets/web_app_bar_widget.dart';
import 'package:flutter_restaurant/common/widgets/footer_widget.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final ConfigModel? configModel = Provider.of<SplashProvider>(context, listen: false).configModel;

    return CustomPopScopeWidget(
      child: Scaffold(
        appBar: (ResponsiveHelper.isDesktop(context) ? const PreferredSize(preferredSize: Size.fromHeight(100), child: WebAppBarWidget()) : CustomAppBarWidget(context: context, title: getTranslated('help_and_support', context))) as PreferredSizeWidget?,
        body: Scrollbar(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [

                if(ResponsiveHelper.isDesktop(context))
                Padding(
                  padding: const EdgeInsets.only(top: Dimensions.paddingSizeExtraLarge),
                  child: Text(getTranslated('help_and_support', context)!, style: rubikBold.copyWith(
                      fontWeight: FontWeight.w800,
                      fontSize: Dimensions.paddingSizeLarge,
                  )),
                ),

                Padding(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                  child: Container(
                    width: width > 700 ? Dimensions.webScreenWidth : width,
                    padding: width > 700 ? const EdgeInsets.all(Dimensions.paddingSizeDefault) : null,
                    decoration: width > 700 ? BoxDecoration(
                      color: Theme.of(context).canvasColor, borderRadius: BorderRadius.circular(10),
                      boxShadow: [BoxShadow(
                        color: Theme.of(context).shadowColor,
                        offset: const Offset(10, 18),
                        blurRadius: 35,
                      )],
                    ) : null,
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                      const Align(alignment: Alignment.center, child: CustomAssetImageWidget(Images.support, height: 120, width: 170)),
                      const SizedBox(height: 40),

                      if(ResponsiveHelper.isDesktop(context))
                        Padding(
                          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                          child: Row(children: [
                            Flexible(
                              flex: 1,
                              child: SupportItemWidget(
                                label: getTranslated('call_us', context),
                                info: '${configModel?.restaurantPhone}',
                                iconData: Icons.call_rounded,
                                onTap: (){
                                  launchUrl(Uri.parse(
                                    'tel:${configModel?.restaurantPhone}',
                                  ), mode: LaunchMode.externalApplication);
                                },
                              ),
                            ),
                            const SizedBox(width: Dimensions.paddingSizeDefault),

                            Flexible(
                              flex: 1,
                              child: SupportItemWidget(
                                label: getTranslated('email_us', context),
                                info: '${configModel?.restaurantEmail}',
                                iconData: Icons.email,
                                onTap: () async {
                                  final uri = Uri(scheme: 'mailto', path: configModel?.restaurantEmail);

                                  if (await canLaunchUrl(uri)) {
                                    await launchUrl(uri);
                                  }
                                },
                              ),
                            ),
                            const SizedBox(width: Dimensions.paddingSizeDefault),

                            Flexible(
                              flex: 1,
                              child: SupportItemWidget(
                                label: getTranslated('our_location', context),
                                info: '${configModel?.restaurantAddress}',
                                iconData: Icons.location_on,
                                  onTap: () async {
                                    final uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=${configModel?.restaurantLocationCoverage?.latitude},${configModel?.restaurantLocationCoverage?.longitude}',);

                                    if(await canLaunchUrl(uri)) {
                                      launchUrl(uri, mode: LaunchMode.externalApplication);
                                    }
                                  }
                              ),
                            ),

                          ]),
                        )
                      else ...[
                        SupportItemWidget(
                          label: getTranslated('call_us', context),
                          info: '${configModel?.restaurantPhone}',
                          iconData: Icons.call_rounded,
                          onTap: (){
                            launchUrl(Uri.parse(
                              'tel:${configModel?.restaurantPhone}',
                            ), mode: LaunchMode.externalApplication);
                          },
                        ),
                        const SizedBox(height: Dimensions.paddingSizeSmall),

                        SupportItemWidget(
                          label: getTranslated('email_us', context),
                          info: '${configModel?.restaurantEmail}',
                          iconData: Icons.email,
                          onTap: () async {
                            final uri = Uri(scheme: 'mailto', path: configModel?.restaurantEmail);

                            if (await canLaunchUrl(uri)) {
                              await launchUrl(uri);
                            }
                          },
                        ),
                        const SizedBox(height: Dimensions.paddingSizeSmall),

                        SupportItemWidget(
                          label: getTranslated('our_location', context),
                          info: '${configModel?.restaurantAddress}',
                          iconData: Icons.location_on,
                            onTap: () async {
                              final uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=${configModel?.restaurantLocationCoverage?.latitude},${configModel?.restaurantLocationCoverage?.longitude}',);

                              if(await canLaunchUrl(uri)) {
                                launchUrl(uri, mode: LaunchMode.externalApplication);
                              }
                            }
                        ),
                        const SizedBox(height: Dimensions.paddingSizeSmall),
                      ]
                    ]),
                  ),
                ),
                if(ResponsiveHelper.isDesktop(context)) const FooterWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
