import 'package:flutter/material.dart';
import 'package:resturant_delivery_boy/utill/dimensions.dart';

class DeliveryAnalyticsShimmerWidget extends StatelessWidget {
  const DeliveryAnalyticsShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.paddingSizeDefault,
        vertical: Dimensions.paddingSizeLarge,
      ),
      child: Column(children: [

        Row(children: [

          Expanded(child: Container(
            height: 25,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              color: Theme.of(context).hintColor.withValues(alpha:0.08),
            ),

          )),

          Expanded(flex: 1, child: Container(

          )),

          Expanded(child: Container(
            height: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              color: Theme.of(context).hintColor.withValues(alpha:0.08),
            ),

          )),


        ]),
        const SizedBox(height: Dimensions.paddingSizeDefault),

        Row(children: [

          Expanded(
            child: Container(
              height: 120, padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                color: Theme.of(context).hintColor.withValues(alpha:0.08),
              ),
              child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

                Align(alignment: Alignment.centerRight,
                  child: Container(
                    height: 30, width: 30,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(50),
                    ),
                  )
                ),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                Column(children: [

                  Row(children: [

                    Expanded(child: Container(
                      height: 20,
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      ),
                    )),

                    Expanded(child: Container()),

                  ]),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  Row(children: [

                    Expanded(flex:2, child: Container(
                      height: 20,
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      ),
                    )),

                    Expanded(child: Container()),

                  ]),

                ])


              ]),
            ),
          ),
          const SizedBox(width: Dimensions.paddingSizeSmall),

          Expanded(
            child: Container(
              height: 120, padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                color: Theme.of(context).hintColor.withValues(alpha:0.08),
              ),
              child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

                Align(alignment: Alignment.centerRight,
                    child: Container(
                      height: 30, width: 30,
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(50),
                      ),
                    )
                ),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                Column(children: [

                  Row(children: [

                    Expanded(child: Container(
                      height: 20,
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      ),
                    )),

                    Expanded(child: Container()),

                  ]),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  Row(children: [

                    Expanded(flex:2, child: Container(
                      height: 20,
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      ),
                    )),

                    Expanded(child: Container()),

                  ]),

                ])


              ]),
            ),
          ),


        ]),
        const SizedBox(height: Dimensions.paddingSizeDefault),

        Row(children: [

          Expanded(
            child: Container(
              height: 120, padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                color: Theme.of(context).hintColor.withValues(alpha:0.08),
              ),
              child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

                Align(alignment: Alignment.centerRight,
                  child: Container(
                    height: 30, width: 30,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(50),
                    ),
                  )
                ),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                Column(children: [

                  Row(children: [

                    Expanded(child: Container(
                      height: 20,
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      ),
                    )),

                    Expanded(child: Container()),

                  ]),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  Row(children: [

                    Expanded(flex:2, child: Container(
                      height: 20,
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      ),
                    )),

                    Expanded(child: Container()),

                  ]),

                ])


              ]),
            ),
          ),
          const SizedBox(width: Dimensions.paddingSizeSmall),

          Expanded(
            child: Container(
              height: 120, padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                color: Theme.of(context).hintColor.withValues(alpha:0.08),
              ),
              child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

                Align(alignment: Alignment.centerRight,
                    child: Container(
                      height: 30, width: 30,
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(50),
                      ),
                    )
                ),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                Column(children: [

                  Row(children: [

                    Expanded(child: Container(
                      height: 20,
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      ),
                    )),

                    Expanded(child: Container()),

                  ]),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  Row(children: [

                    Expanded(flex:2, child: Container(
                      height: 20,
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      ),
                    )),

                    Expanded(child: Container()),

                  ]),

                ])


              ]),
            ),
          ),


        ]),
        const SizedBox(height: Dimensions.paddingSizeLarge),

        Row(children: [

          Expanded(
            child: Container(height: 20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                color: Theme.of(context).hintColor.withValues(alpha:0.08),
              ),
            ),
          ),

          Expanded(flex: 2, child: Container()),

        ]),
        const SizedBox(height: Dimensions.paddingSizeDefault),


        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

          Row(children: [

            Container(
              height: 20, width: 20,
              decoration: BoxDecoration(
                color: Theme.of(context).hintColor.withValues(alpha:0.08),
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              ),
            ),
            const SizedBox(width: Dimensions.paddingSizeSmall),

            Container(
              height: 20, width: 80,
              decoration: BoxDecoration(
                color: Theme.of(context).hintColor.withValues(alpha:0.08),
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              ),
            ),

          ]),

          Container(
            height: 20, width: 20,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              color: Theme.of(context).hintColor.withValues(alpha:0.08)
            ),
          )

        ]),
        const SizedBox(height: Dimensions.paddingSizeDefault),

        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

          Row(children: [

            Container(
              height: 20, width: 20,
              decoration: BoxDecoration(
                color: Theme.of(context).hintColor.withValues(alpha:0.08),
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              ),
            ),
            const SizedBox(width: Dimensions.paddingSizeSmall),

            Container(
              height: 20, width: 80,
              decoration: BoxDecoration(
                color: Theme.of(context).hintColor.withValues(alpha:0.08),
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              ),
            ),

          ]),

          Container(
            height: 20, width: 20,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              color: Theme.of(context).hintColor.withValues(alpha:0.08)
            ),
          )

        ]),
        const SizedBox(height: Dimensions.paddingSizeDefault),

        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

          Row(children: [

            Container(
              height: 20, width: 20,
              decoration: BoxDecoration(
                color: Theme.of(context).hintColor.withValues(alpha:0.08),
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              ),
            ),
            const SizedBox(width: Dimensions.paddingSizeSmall),

            Container(
              height: 20, width: 80,
              decoration: BoxDecoration(
                color: Theme.of(context).hintColor.withValues(alpha:0.08),
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              ),
            ),

          ]),

          Container(
            height: 20, width: 20,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              color: Theme.of(context).hintColor.withValues(alpha:0.08)
            ),
          )

        ]),
        const SizedBox(height: Dimensions.paddingSizeDefault),

        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

          Row(children: [

            Container(
              height: 20, width: 20,
              decoration: BoxDecoration(
                color: Theme.of(context).hintColor.withValues(alpha:0.08),
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              ),
            ),
            const SizedBox(width: Dimensions.paddingSizeSmall),

            Container(
              height: 20, width: 80,
              decoration: BoxDecoration(
                color: Theme.of(context).hintColor.withValues(alpha:0.08),
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              ),
            ),

          ]),

          Container(
            height: 20, width: 20,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              color: Theme.of(context).hintColor.withValues(alpha:0.08)
            ),
          )

        ]),
        const SizedBox(height: Dimensions.paddingSizeDefault),

      ]),
    );
  }
}
