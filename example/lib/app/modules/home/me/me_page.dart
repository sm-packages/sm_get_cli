import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'me_controller.dart';

/// MePage
class MePage extends GetView<MeController> {
  const MePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MePage'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'MePage is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
