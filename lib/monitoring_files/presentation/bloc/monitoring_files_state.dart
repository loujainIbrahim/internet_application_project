part of 'monitoring_files_cubit.dart';

@immutable
abstract class MonitoringFilesState {}

class MonitoringFilesInitial extends MonitoringFilesState {}
class MonitoringFilesLoadingState extends MonitoringFilesState {}
class MonitoringFilesSuccessState extends MonitoringFilesState {}
class MonitoringFilesErrorState extends MonitoringFilesState {
  final String error;
  MonitoringFilesErrorState(this.error);
}
