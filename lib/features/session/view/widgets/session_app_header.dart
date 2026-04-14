import 'package:flutter/material.dart';

import '../../../../core/constants/constants.dart';

class SessionAppHeader extends StatelessWidget {
  const SessionAppHeader({
    super.key,
  });


  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppValues.appHeaderHeight,
      color: AppColors.primaryColor,
      padding: EdgeInsets.symmetric(
        horizontal: AppValues.screenPaddingHorizontal,
      ),
      child: Row(
        children: [
          const SizedBox(width: 4),
          Container(
            width: AppValues.sessionHeaderDotSize,
            height: AppValues.sessionHeaderDotSize,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.textWhite,
            ),
          ),
          const SizedBox(width: AppValues.sessionHeaderGap),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.liveMonitoringTitle,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.textWhite,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                Text(
                  AppStrings.sessionHeaderSubtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textWhite,
                        letterSpacing: 0.2,
                      ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
                Navigator.pushNamed(context, AppRoutes.settings);
            },
            icon: const Icon(
              Icons.settings,
              color: AppColors.textWhite,
            ),
          ),
        ],
      ),
    );
  }
}

