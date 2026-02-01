import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/widgets/custom_image_widget.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:go_router/go_router.dart';

class ImageDialogWidget extends StatelessWidget {
  final String imageUrl;
  const ImageDialogWidget({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
      child: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 48), // Space for close button
                Container(
                  constraints: BoxConstraints(
                    maxWidth: Dimensions.webMaxWidth,
                    maxHeight: MediaQuery.of(context).size.height * 0.7,
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).primaryColor.withValues(alpha: 0.20),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CustomImageWidget(
                      placeholder: Images.placeholderImage,
                      image: imageUrl,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: Dimensions.paddingSizeLarge),
              ],
            ),
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => context.pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
