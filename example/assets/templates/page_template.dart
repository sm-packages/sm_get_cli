import 'package:flutter/material.dart';
import 'package:get/get.dart';
{{import_path}}

/// {{name}}Page
class {{name}}Page extends {{controller}} {
 const {{name}}Page({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('{{name}}Page'),
        centerTitle: true,
      ),
      body:const Center(
        child: Text(
          '{{name}}Page is working',
          style: TextStyle(fontSize:20),
        ),
      ),
    );
  }
}