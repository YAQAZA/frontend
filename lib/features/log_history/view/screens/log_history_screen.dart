import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/utils/size_helper.dart';
import '../../../session/view/widgets/session_bottom_nav.dart';
import '../../view_model/cubit/log_history_cubit.dart';
import '../../view_model/cubit/log_history_state.dart';
import '../widgets/log_history_section_header.dart';
import '../widgets/log_history_session_card.dart';
import '../widgets/log_history_summary_cards.dart';

class LogHistoryScreen extends StatefulWidget {
  const LogHistoryScreen({super.key});

  @override
  State<LogHistoryScreen> createState() => _LogHistoryScreenState();
}

class _LogHistoryScreenState extends State<LogHistoryScreen> {
  @override
  void initState() {
    super.initState();
    context.read<LogHistoryCubit>().loadHistory();
  }

  @override
  Widget build(BuildContext context) {
    final paddingH = SizeHelper.screenPaddingHorizontal(context);
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.textWhite,
        title: const Text('Sessions History'),
        actions: const [
          Icon(Icons.filter_list_rounded),
          SizedBox(width: 8),
          Icon(Icons.settings_outlined),
          SizedBox(width: 12),
        ],
      ),
      body: BlocBuilder<LogHistoryCubit, LogHistoryState>(
        builder: (context, state) {
          if (state is LogHistoryLoading || state is LogHistoryInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is LogHistoryError) {
            return Center(
              child: Text(
                state.message,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            );
          }
          if (state is! LogHistoryLoaded) {
            return const SizedBox.shrink();
          }

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: paddingH),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: AppValues.spacingMedium),
                LogHistorySummaryCards(summary: state.summary),
                SizedBox(height: AppValues.spacingLarge),
                const LogHistorySectionHeader(title: 'TODAY'),
                SizedBox(height: AppValues.spacingMedium),
                ...state.todayLogs.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: AppValues.spacingMedium),
                    child: LogHistorySessionCard(
                      session: item,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.sessionHistoryDetails,
                          arguments: item.id,
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(height: AppValues.spacingXSmall),
                const LogHistorySectionHeader(title: 'YESTERDAY'),
                SizedBox(height: AppValues.spacingMedium),
                ...state.yesterdayLogs.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: AppValues.spacingMedium),
                    child: LogHistorySessionCard(
                      session: item,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.sessionHistoryDetails,
                          arguments: item.id,
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(height: AppValues.spacingLarge),
                Center(
                  child: Text(
                    'Historical drive patterns analyzed via Yaqazah AI',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textMedium,
                        ),
                  ),
                ),
                SizedBox(height: AppValues.spacingLarge),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: const SizedBox(
        height: AppValues.bottomNavHeight,
        child: SessionBottomNav(selectedIndex: 1),
      ),
    );
  }
}
