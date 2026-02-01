import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:resturant_delivery_boy/common/models/policy_model.dart';
import 'package:resturant_delivery_boy/localization/language_constrants.dart';
import 'package:resturant_delivery_boy/features/splash/providers/splash_provider.dart';
import 'package:resturant_delivery_boy/utill/dimensions.dart';
import 'package:resturant_delivery_boy/common/widgets/custom_app_bar_widget.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';


class HtmlViewerScreen extends StatelessWidget {

  final bool isPrivacyPolicy;
  const HtmlViewerScreen({super.key, required this.isPrivacyPolicy});

  @override
  Widget build(BuildContext context) {
    final PolicyModel? policyModel = Provider.of<SplashProvider>(context, listen: false).policyModel;

    String data = isPrivacyPolicy ? policyModel?.privacyPolicy ?? '' : policyModel?.termsAndCondition ?? '';

    return Scaffold(
      appBar: CustomAppBarWidget(title: getTranslated(isPrivacyPolicy ? 'privacy_policy' : 'terms_and_condition', context)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
        physics: const BouncingScrollPhysics(),
        child: HtmlWidget(
          data,
          key: Key(data.toString()),
          onTapUrl: (String url) {
            return launchUrl(Uri.parse(url));
          },
        ),
      ),
    );
  }
}