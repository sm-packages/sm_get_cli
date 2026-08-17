import 'package:flutter/material.dart';

import 'package:sm_getx/get.dart';

/// CustomPage
class CustomPage extends GetView {
  const CustomPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CustomPage'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'CustomPage is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
