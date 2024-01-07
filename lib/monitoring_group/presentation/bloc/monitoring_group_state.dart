part of 'monitoring_group_cubit.dart';

@immutable
abstract class MonitoringGroupState {}

class MonitoringGroupInitial extends MonitoringGroupState {}
class MonitoringGroupSuccessState extends MonitoringGroupState {}
class MonitoringGroupLoadingState extends MonitoringGroupState {}
class MonitoringGroupErrorState extends MonitoringGroupState {
  final String error;
  MonitoringGroupErrorState(this.error);
}
