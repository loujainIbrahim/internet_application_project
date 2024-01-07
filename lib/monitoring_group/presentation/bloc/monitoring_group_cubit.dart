import 'package:bloc/bloc.dart';
import 'package:internet_application/monitoring_group/data/monitoring_model.dart';
import 'package:meta/meta.dart';

import '../../../core/network/DioHelper.dart';

part 'monitoring_group_state.dart';

class MonitoringGroupCubit extends Cubit<MonitoringGroupState> {
  MonitoringGroupCubit() : super(MonitoringGroupInitial());
  late MonitoringModel monitoringModel;
  Future<void> getMonitoringGroup(int group_id) async {
    emit(MonitoringGroupLoadingState());
    await DioHelper.getData(url: "group/modefies/group/$group_id")
        .then((value) {
      monitoringModel=MonitoringModel.fromJson(value.data);
      print(value.data);
      emit(MonitoringGroupSuccessState());
    }).catchError((onError) {
      emit(MonitoringGroupErrorState(onError.toString()));
    });
  }
}
