import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/utils/size_helper.dart';
import '../../view_model/cubit/log_history_cubit.dart';
import '../../view_model/cubit/log_history_state.dart';
import '../widgets/log_history_details_summary_row.dart';
import '../widgets/log_history_timeline_item.dart';

class LogHistoryDetailsScreen extends StatefulWidget {
  const LogHistoryDetailsScreen({
    super.key,
    required this.sessionId,
  });

  final String sessionId;

  @override
  State<LogHistoryDetailsScreen> createState() => _LogHistoryDetailsScreenState();
}

class _LogHistoryDetailsScreenState extends State<LogHistoryDetailsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<LogHistoryCubit>().loadSessionDetails(sessionId: widget.sessionId);
  }

  @override
  Widget build(BuildContext context) {
    final paddingH = SizeHelper.screenPaddingHorizontal(context);
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.textWhite,
        title: const Text('Session Details'),
      ),
      body: BlocBuilder<LogHistoryCubit, LogHistoryState>(
        builder: (context, state) {
          if (state is LogHistoryDetailsLoading ||
              state is LogHistoryInitial ||
              state is LogHistoryLoading) {
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
          if (state is! LogHistoryDetailsLoaded) {
            return const SizedBox.shrink();
          }

          final details = state.details;
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: paddingH),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: AppValues.spacingMedium),
                Text(
                  details.sessionDateLabel,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                Text(
                  details.sessionStartTimeLabel,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textMedium,
                      ),
                ),
                SizedBox(height: AppValues.spacingMedium),
                LogHistoryDetailsSummaryRow(
                  durationLabel: details.durationLabel,
                  safetyScore: details.safetyScore,
                  detectionsCount: details.detectionsCount,
                ),
                SizedBox(height: AppValues.spacingLarge),
                Text(
                  'Detection Timeline',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                SizedBox(height: AppValues.spacingMedium),
                ...details.timeline.asMap().entries.map(
                  (entry) => LogHistoryTimelineItem(
                    event: entry.value,
                    isLast: entry.key == details.timeline.length - 1,
                  ),
                ),
                SizedBox(height: AppValues.spacingXSmall),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      foregroundColor: AppColors.textWhite,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppValues.borderRadius),
                      ),
                    ),
                    icon: const Icon(Icons.picture_as_pdf_outlined),
                    label: const Text('Export Detection Report'),
                  ),
                ),
                SizedBox(height: AppValues.spacingLarge),
              ],
            ),
          );
        },
      ),
    );
  }
}
