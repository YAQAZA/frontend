import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/utils/size_helper.dart';
import '../../../../core/widget/core_widgets.dart';
import '../widgets/session_app_header.dart';
import '../widgets/session_bottom_nav.dart';
import '../../view_model/cubit/session_cubit.dart';
import '../../view_model/cubit/session_state.dart';

class SessionStartScreen extends StatelessWidget {
  const SessionStartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final paddingH = SizeHelper.screenPaddingHorizontal(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            const SessionAppHeader(),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: paddingH),
                child: BlocListener<SessionCubit, SessionState>(
                  listener: (context, state) {},
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: AppValues.spacingXLarge),
                        _buildStartButton(context),
                        SizedBox(height: AppValues.spacingXLarge),
                        _buildSafetyScoreCard(context),
                        SizedBox(height: AppValues.spacingMedium),
                        _buildPreDriveCheckCard(context),
                        SizedBox(height: AppValues.spacingXLarge),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: AppValues.bottomNavHeight,
              child: SessionBottomNav(
                selectedIndex: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStartButton(BuildContext context) {
    return BlocBuilder<SessionCubit, SessionState>(
      builder: (context, state) {
        final starting = state is SessionStarting;
        return SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.38,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppCircleActionButton(
                enabled: !starting,
                onPressed: starting
                    ? null
                    : () {
                        context.read<SessionCubit>().startSession();
                        Navigator.pushNamed(context, AppRoutes.sessionActive);
                      },
              ),
              const SizedBox(height: 12),
              Text(
                AppStrings.start,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryColor,
                    ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSafetyScoreCard(BuildContext context) {
    return AppSurfaceCard(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.safetyScore,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                ),
                Text(
                  AppStrings.basedOnLastDays,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textMedium,
                      ),
                ),
              ],
            ),
          ),
          Text(
            '${AppValues.sessionSafetyScore}',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryColor,
                ),
          ),
          Text(
            '/${AppValues.sessionSafetyScoreMax}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textMedium,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreDriveCheckCard(BuildContext context) {
    return AppSurfaceCard(
      showBorder: true,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.inputBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.phone_android,
              color: AppColors.primaryColor,
            ),
          ),
          SizedBox(width: AppValues.spacingMedium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.preDriveCheck,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                Text(
                  AppStrings.ensurePhoneMounted,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textMedium,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
