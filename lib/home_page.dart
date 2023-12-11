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

  initialisedSensorData() async {
    final tempSensorDataList = await ApiService().getSensorData();
    tempSensorDataList.forEach((element) {
      Sensor tempSensorData = Sensor(
        srNo: element['sr_no'],
        sensor1Data: element['sensor1'],
        sensor2Data: element['sensor2'],
        sensor3Data: element['sensor3'],
        time1Data: element['time1'],
      );
      sensorDataList.add(tempSensorData);
    });
    setState(() {});
    print(sensorDataList);
  }
  @override
  void initState() {
    // TODO: implement initState
    initialisedSensorData();
    super.initState();
  }

  int _currentSortColumn = 0;
  bool _isSortAsc = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        title: const Text(
          "IOT Device Data",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Enable Device",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                        color: Colors.black),
                  ),
                  Switch(
                    value: _isSwitched,
                    onChanged: (value) {
                      print("VALUE : $value");
                      setState(() {
                        _isSwitched = value;
                      });
                    },
                    activeColor: Colors.blue,
                    inactiveThumbColor: Colors.grey,
                    inactiveTrackColor: Colors.grey.withOpacity(0.5),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const Center(
                  child: Text(
                "Device is connected!",
                style: TextStyle(color: Colors.blue),
              )),
              ElevatedButton(
                onPressed: () async {
                  await ApiService().getSensorData();
                },
                child: const Text('click here'),
              ),
              const SizedBox(
                height: 30,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  sortColumnIndex: _currentSortColumn,
                  sortAscending: _isSortAsc,
                  showBottomBorder: true,
                  dividerThickness: 5,
                  headingTextStyle: const TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
                  headingRowColor: MaterialStateProperty.resolveWith((states) => Colors.grey),

                  // 2 min hold kr mw code copy krine aavyo maro ha

                  // border: TableBorder.all(),
                  columns: const [
                    DataColumn(
                        label: Text('Sr.no'),
                        numeric: true,
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
                    DataColumn(label: Text('Time')),
                  ],
                  rows: sensorDataList.map((element) {
                    return DataRow(selected: true, cells: [
                      DataCell(Text(element.srNo), showEditIcon: true, // placeholder: true
                      ),
                      DataCell(Align(alignment: Alignment.center, child: Text(element.sensor1Data.toString()),)),
                      DataCell(Align(alignment: Alignment.center, child: Text(element.sensor2Data.toString()),
                      )),
                      DataCell(Align(alignment: Alignment.center, child: Text(element.sensor3Data.toString()),
                      )),
                      DataCell(Align(alignment: Alignment.center, child: Text(element.time1Data.toString()),
                      )),
                    ]);
                  }).toList(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
