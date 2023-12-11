import 'package:flutter/material.dart';

// link-- http://humble-winding.000webhostapp.com/api.php method :-Get

class Sensor {
  String srNo;
  String? sensor1Data;
  String? sensor2Data;
  String? sensor3Data;
  String? time1Data;

  Sensor({
    required this.srNo,
    this.sensor1Data,
    this.sensor2Data,
    this.sensor3Data,
    this.time1Data,
  });
}
