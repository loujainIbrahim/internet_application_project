import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../core/network/DioHelper.dart';
import 'package:internet_application/monitoring_files/data/monitoring_files_model.dart';
part 'monitoring_files_state.dart';

class MonitoringFilesCubit extends Cubit<MonitoringFilesState> {
  MonitoringFilesCubit() : super(MonitoringFilesInitial());
  late MonitoringModel monitoringModel;
  Future<void> getMonitoringFiles(int file_id) async {
    emit(MonitoringFilesLoadingState());
    try {
      final response = await DioHelper.getData(url: "group/modefies/file/$file_id");
      monitoringModel = MonitoringModel.fromJsonList(response.data);
      print(response.data);
      emit(MonitoringFilesSuccessState());
    } catch (error) {
      emit(MonitoringFilesErrorState(error.toString()));
      print(error.toString());
    }
  }

}
