import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_application/monitoring_files/presentation/bloc/monitoring_files_cubit.dart';
import 'package:internet_application/monitoring_group/presentation/bloc/monitoring_group_cubit.dart';

class MonitoringFilesScreen extends StatelessWidget {
  final int file_id;
final int group_id;
  const MonitoringFilesScreen({Key? key, required this.file_id,required this.group_id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MonitoringFilesCubit()..getMonitoringFiles(file_id,group_id),
      child: BlocConsumer<MonitoringFilesCubit, MonitoringFilesState>(
        builder: (BuildContext context, state) {
          if (state is MonitoringFilesLoadingState) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (state is MonitoringFilesSuccessState) {
            final monitoringModel = context.read<MonitoringFilesCubit>().monitoringModel;

            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.grey[200],
                centerTitle: true,
                title: Text('Monitoring Group'),
              ),
              body: SingleChildScrollView(
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: [
                            if (monitoringModel.data != null && monitoringModel.data!.isNotEmpty) // Add null and emptiness check
                              DataTable(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.blue),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                columns: [
                                  DataColumn(
                                    label: Text(
                                      'ID',
                                      style: TextStyle(
                                        color: Colors.deepOrange,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Name',
                                      style: TextStyle(
                                        color: Colors.deepOrange,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Action',
                                      style: TextStyle(
                                        color: Colors.deepOrange,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Created At',
                                      style: TextStyle(
                                        color: Colors.deepOrange,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Updated At',
                                      style: TextStyle(
                                        color: Colors.deepOrange,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ],
                                rows: monitoringModel.data!
                                    .asMap()
                                    .entries
                                    .map((entry) {
                                  final index = entry.key + 1;
                                  final data = entry.value;
                                  return DataRow(
                                    cells: [
                                      DataCell(
                                        Text(
                                          '$index',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          '${data.name ?? 'N/A'}',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          '${data.action ?? 'N/A'}',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          '${data.createdAt ?? 'N/A'}',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          '${data.updatedAt ?? 'N/A'}',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else if (state is MonitoringFilesErrorState) {
            return Scaffold(
              body: Center(
                child: Text('Error: ${state.error}'),
              ),
            );
          } else {
            return Scaffold(
              body: Center(
                child: Text('Unknown state'),
              ),
            );
          }
        },
        listener: (BuildContext context, Object? state) {},
      ),
    );
  }
}
