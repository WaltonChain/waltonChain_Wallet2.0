import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/place_record_controller.dart';

class PlaceRecordView extends GetView<PlaceRecordController> {
  const PlaceRecordView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PlaceRecordView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'PlaceRecordView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
