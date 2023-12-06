import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:memegeneraterappusingstacked/config/config.dart';

class MemegenerationserviceService {
  String username = Config.username;
  String password = Config.password;
  String imageUrl = '';

  Future<String> generateMeme(
      String templateId, String text0, String text1) async {
    try {
      var response = await Dio().get(
        'https://api.imgflip.com/caption_image?template_id=$templateId&text0=$text0&text1=$text1&username=$username&password=$password',
      );
      log(
        'https://api.imgflip.com/caption_image?template_id=$templateId&text0=$text0&text1=$text1&username=$username&password=$password',
      );
      imageUrl = response.data['data']['url'];
      return imageUrl;
    } catch (e) {
      // Handle errors
      debugPrint('Error generating meme: $e');
      throw Exception('Error generating meme: $e');
    }
  }
}
