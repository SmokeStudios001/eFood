import 'package:flutter/material.dart';
import 'package:resturant_delivery_boy/localization/language_constrants.dart';
import 'package:resturant_delivery_boy/features/profile/providers/theme_provider.dart';
import 'package:resturant_delivery_boy/utill/dimensions.dart';
import 'package:provider/provider.dart';

class ThemeStatusWidget extends StatelessWidget {
  const ThemeStatusWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) => InkWell(
              onTap: themeProvider.toggleTheme,
              child: themeProvider.darkTheme
                  ? Container(
                      width: 74,
                      height: 29,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                              child: Text(
                            getTranslated('dark', context)!,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.displayMedium!.copyWith(
                                  color: Colors.white,
                                  fontSize: Dimensions.fontSizeSmall,
                                ),
                          )),
                          const Padding(
                            padding: EdgeInsets.all(1.0),
                            child: CircleAvatar(
                              radius: 13,
                              backgroundColor: Colors.white,
                            ),
                          )
                        ],
                      ),
                    )
                  : Container(
                      width: 74,
                      height: 29,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Theme.of(context).hintColor.withValues(alpha:0.7),
                      ),
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(1.0),
                            child: CircleAvatar(
                              radius: 13,
                              backgroundColor: Colors.white,
                            ),
                          ),
                          Expanded(
                              child: Text(
                            getTranslated('light', context)!,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.displayMedium!.copyWith(
                                  color: Colors.white,
                                  fontSize: Dimensions.fontSizeSmall,
                                ),
                          )),
                        ],
                      ),
                    ),
            ));
  }
}
