import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resturant_delivery_boy/common/widgets/custom_image_widget.dart';
import 'package:resturant_delivery_boy/features/chat/domain/models/chat_model.dart';
import 'package:resturant_delivery_boy/helper/date_converter_helper.dart';
import 'package:resturant_delivery_boy/features/splash/providers/splash_provider.dart';
import 'package:resturant_delivery_boy/utill/dimensions.dart';
import 'package:resturant_delivery_boy/utill/images.dart';
import 'package:resturant_delivery_boy/utill/styles.dart';

import 'image_diaglog_widget.dart';

class MessageBubbleWidget extends StatelessWidget {
  final Messages? messages;
  const MessageBubbleWidget({super.key, this.messages});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.fontSizeLarge),
      child: messages!.deliverymanId != null?
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),

        ),

        child: Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          child: Column(crossAxisAlignment: CrossAxisAlignment.end, mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(messages!.deliverymanId!.name ?? '',style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeLarge),),
              const SizedBox(height: Dimensions.paddingSizeSmall),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [

                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if(messages!.message != null && messages!.message!.isNotEmpty) Flexible(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(messages!.message != null?Dimensions.paddingSizeDefault:0),
                              child: Text(messages!.message??''),
                            ),
                          ),
                        ),

                        messages!.attachment !=null?
                        Directionality(
                          textDirection: TextDirection.rtl,
                          child: GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              childAspectRatio: 1,
                              crossAxisCount: 3,
                              crossAxisSpacing: 5, mainAxisSpacing: 5,
                            ),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: messages!.attachment!.length,
                            itemBuilder: (BuildContext context, index){
                              return  messages!.attachment!.isNotEmpty?
                              InkWell(
                                hoverColor: Colors.transparent,
                                onTap: () => showDialog(context: context, builder: (ctx)  =>  ImageDialogWidget(imageUrl:  messages!.attachment![index])),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    top: (messages!.message != null && messages!.message!.isNotEmpty) ? Dimensions.paddingSizeSmall : 0,),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: CustomImageWidget(
                                      placeholder: Images.placeholderImage, height: 100, width: 100, fit: BoxFit.cover,
                                      image: messages!.attachment![index],
                                    ),
                                  ),
                                ),
                              ):const SizedBox();

                            },),
                        ):const SizedBox(),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall),
                    child: Container(
                      width: 40, height: 40,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(Dimensions.paddingSizeDefault))
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50.0),
                        child: CustomImageWidget(
                          placeholder: Images.placeholderUser, fit: BoxFit.cover, width: 40, height: 40,
                          image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.deliveryManImageUrl}/${messages!.deliverymanId!.image}',
                        ),
                      ),
                    ),
                  ),
                ],
              ),





              const SizedBox(height: Dimensions.paddingSizeSmall),
              Text(DateConverterHelper.formatDate(DateConverterHelper.isoStringToLocalDate(messages!.createdAt!), context, isSecond: false), style: rubikRegular.copyWith(color: Theme.of(context).hintColor,fontSize: Dimensions.fontSizeSmall),),
              const SizedBox(),
            ],
          ),
        ),
      ) :
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),

        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(messages?.customerId?.name ?? ''),
            const SizedBox(height: Dimensions.paddingSizeSmall),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                  child: Container(
                    width: 40, height: 40,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(Dimensions.paddingSizeDefault))
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50.0),
                      child: CustomImageWidget(
                        placeholder: Images.placeholderUser, fit: BoxFit.cover, width: 40, height: 40,
                        image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.customerImageUrl}/${messages!.customerId!.image ?? ''}',
                      ),
                      // child: Image.asset(Images.placeholderUser), borderRadius: BorderRadius.circular(50.0),
                    ),
                  ),
                ),

                Flexible(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if(messages!.message != null && messages!.message!.isNotEmpty) Flexible(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).secondaryHeaderColor,
                            borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(messages!.message != null?Dimensions.paddingSizeDefault:0),
                            child: Text(messages!.message??''),
                          ),
                        ),
                      ),

                      messages!.attachment !=null?
                      GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: 1,
                          crossAxisCount: 3,
                          crossAxisSpacing: 5, mainAxisSpacing: 5,
                        ),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: messages!.attachment!.length,
                        itemBuilder: (BuildContext context, index){
                          return  messages!.attachment!.isNotEmpty?
                          InkWell(
                            onTap: () => showDialog(context: context, builder: (ctx)  =>  ImageDialogWidget(imageUrl: messages!.attachment![index])),
                            child: Padding(
                              padding: EdgeInsets.only(
                                top: (messages!.message != null && messages!.message!.isNotEmpty) ? Dimensions.paddingSizeSmall : 0,                                       ),
                              child:ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: CustomImageWidget(
                                  placeholder: Images.placeholderImage, height: 100, width: 100, fit: BoxFit.cover,
                                  image: messages!.attachment![index],
                                ),
                              ),
                            ),
                          ):const SizedBox();

                        },):const SizedBox(),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),

           Text(
             DateConverterHelper.formatDate(DateConverterHelper.isoStringToLocalDate(messages!.createdAt!), context, isSecond: false),
             style: rubikRegular.copyWith(color: Theme.of(context).hintColor,fontSize: Dimensions.fontSizeSmall),
           ),
          ],
        ),
      ),
    );
  }
}
