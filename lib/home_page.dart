import 'package:flutter/material.dart';
import 'package:iot/model/sensor.dart';
import 'package:iot/services/service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isSwitched = false;
  List<Sensor> sensorDataList = [];
  List<Sensor> sensorDataList2 = [];

  ///For loding more data
  bool _isLoadMore = false;
  bool _isNewest = false;


  void _loadMoreData() {
    setState(() {
      _isLoadMore = !_isLoadMore;
    });
  }


  void newestToOld() {
    setState(() {
    _isNewest = !_isNewest;
    if(_isNewest){
      sensorDataList.sort((a, b) => a.time1Data!.compareTo(b.time1Data.toString()));
      sensorDataList2.sort((a, b) => a.time1Data!.compareTo(b.time1Data.toString()));

    } else {
      sensorDataList.sort((a, b) => b.time1Data!.compareTo(a.time1Data.toString()));
      sensorDataList2.sort((a, b) => b.time1Data!.compareTo(a.time1Data.toString()));
    }
    });
  }


  void initialisedSensorData() async {
    final tempSensorDataList = await ApiService().getSensorData();
    tempSensorDataList.forEach((element) {
      Sensor tempSensorData = Sensor(
        srNo: element['sr_no'],
        sensor1Data: element['sensor1'],
        sensor2Data: element['sensor2'],
        sensor3Data: element['sensor3'],
        time1Data: element['time1'],
      );
     // print(tempSensorData.time1Data);
      sensorDataList.add(tempSensorData);
    });
    setState(() {});
    sensorDataList2 = List<Sensor>.from(sensorDataList.sublist(0, 9));
    print(sensorDataList);
  }

  @override
  void initState() {
    // TODO: implement initState
    initialisedSensorData();
    super.initState();
  }

  final int _currentSortColumn = 0;
  final bool _isSortAsc = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: const Icon(
          Icons.menu,
        ),
        actions: [
          IconButton(
              onPressed: () {
                // await ApiService().getSensorData();
                initialisedSensorData();
                final snackBar = SnackBar(content: Text('Data Refressed!'));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                print("object is Done!");
              },
              icon: const Padding(
                padding: EdgeInsets.only(right: 18.0),
                child: Icon(
                  Icons.refresh,
                  color: Colors.blueAccent,
                ),
              ))
        ],
        title: const Text(
          "Device Data",
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     const Text(
              //       "Enable Device",
              //       style: TextStyle(
              //           fontWeight: FontWeight.bold,
              //           fontSize: 20.0,
              //           color: Colors.black),
              //     ),
              //     Switch(
              //       value: _isSwitched,
              //       onChanged: (value) {
              //         print("VALUE : $value");
              //         setState(() {
              //           _isSwitched = value;
              //         });
              //       },
              //       activeColor: Colors.blue,
              //       inactiveThumbColor: Colors.grey,
              //       inactiveTrackColor: Colors.grey.withOpacity(0.5),
              //     )
              //   ],
              // ),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 170,
                    child: ElevatedButton(
                        onPressed: ()  {
                          newestToOld();
                          print('NewestFirst button pressed!');
                        },
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            backgroundColor: Colors.white),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                           const Icon(
                              Icons.sort,
                              color: Color(0xFF7A7A7A),
                            ),
                           const SizedBox(width: 8.0),
                            Text(
                              _isNewest ? 'Oldest First' : 'Newest First',
                              style: TextStyle(color: Color(0xFF7A7A7A)),
                            ),
                          ],
                        )),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  sortColumnIndex: _currentSortColumn,
                  sortAscending: _isSortAsc,
                  // showBottomBorder: true,
                  // dividerThickness: 5,
                  headingTextStyle: const TextStyle(
                      fontWeight: FontWeight.bold, color: Color(0xFFFFFFFF)),
                  headingRowColor: MaterialStateProperty.resolveWith(
                      (states) => const Color(0xFF279CEB)),

                  // border: TableBorder.all(),
                  columns: const [
                    DataColumn(
                      label: Text('Sr.no'),
                      // numeric: true,
                      // onSort: (columnIndex,_) {
                      //   setState(() {
                      //     _currentSortColumn = columnIndex;
                      //     if (_isSortAsc) {
                      //       sensorDataList.sort((a, b) => b.srNo.compareTo(a.srNo));
                      //     } else {
                      //       sensorDataList.sort((a, b) => a.srNo.compareTo(b.srNo));
                      //     }
                      //     _isSortAsc = !_isSortAsc;
                      //   });
                      // }
                    ),
                    DataColumn(label: Text('Sensor 1')),
                    DataColumn(label: Text('Sensor 2')),
                    DataColumn(label: Text('Sensor 3')),
                    DataColumn(label: Text('TimeStamp')),
                  ],
                  rows: _isLoadMore ? sensorDataList.map((element) {
                    return DataRow(selected: true, cells: [
                      DataCell(
                        Text(element.srNo),
                        showEditIcon: true, // placeholder: true
                      ),
                      DataCell(Align(
                        alignment: Alignment.center,
                        child: Text(element.sensor1Data.toString()),
                      )),
                      DataCell(Align(
                        alignment: Alignment.center,
                        child: Text(element.sensor2Data.toString()),
                      )),
                      DataCell(Align(
                        alignment: Alignment.center,
                        child: Text(element.sensor3Data.toString()),
                      )),
                      DataCell(Align(
                        alignment: Alignment.center,
                        child: Text(element.time1Data.toString()),
                      )),
                    ]);
                  }).toList() : sensorDataList2.map((element) {
                    return DataRow(selected: true, cells: [
                      DataCell(
                        Text(element.srNo),
                        showEditIcon: true, // placeholder: true
                      ),
                      DataCell(Align(
                        alignment: Alignment.center,
                        child: Text(element.sensor1Data.toString()),
                      )),
                      DataCell(Align(
                        alignment: Alignment.center,
                        child: Text(element.sensor2Data.toString()),
                      )),
                      DataCell(Align(
                        alignment: Alignment.center,
                        child: Text(element.sensor3Data.toString()),
                      )),
                      DataCell(Align(
                        alignment: Alignment.center,
                        child: Text(element.time1Data.toString()),
                      )),
                    ]);
                  }).toList(),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  _loadMoreData();
                },
                child: Text(_isLoadMore ? 'Load Less' : 'Load More'),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
