import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:memegeneraterappusingstacked/config/config.dart';

class MemegenerationserviceService {
  String username = Config.username;
  String password = Config.password;
  String imageUrl = '';

  Future<String> generateMemeWith2Boxes(
    String templateId,
    String text0,
    String text1,
  ) async {
    try {
      var url =
          'https://api.imgflip.com/caption_image?template_id=$templateId&text0=$text0&text1=$text1&username=$username&password=$password';
      var response = await Dio().get(url);
      log(url);
      imageUrl = response.data['data']['url'];
      return imageUrl;
    } catch (e) {
      // Handle errors
      debugPrint('Error generating meme: $e');
      throw Exception('Error generating meme: $e');
    }
  }

  Future<String> generateMemeWith3Boxes(
      String templateId, String text0, String text1, String text2) async {
    try {
      var url =
          'https://api.imgflip.com/caption_image?template_id=$templateId&text0=$text0&text1=$text1&text2=$text2&username=$username&password=$password';
      var response = await Dio().get(url);
      log(url);
      imageUrl = response.data['data']['url'];
      return imageUrl;
    } catch (e) {
      // Handle errors
      debugPrint('Error generating meme: $e');
      throw Exception('Error generating meme: $e');
    }
  }

  Future<String> generateMemeWith4Boxes(String templateId, String text0,
      String text1, String text2, String text3) async {
    try {
      var url =
          'https://api.imgflip.com/caption_image?template_id=$templateId&text0=$text0&text1=$text1&text2=$text2&text3=$text3&username=$username&password=$password';
      var response = await Dio().get(url);
      log(url);
      imageUrl = response.data['data']['url'];
      return imageUrl;
    } catch (e) {
      // Handle errors
      debugPrint('Error generating meme: $e');
      throw Exception('Error generating meme: $e');
    }
  }

  Future<String> generateMemeWith5Boxes(
    String templateId,
    String text0,
    String text1,
    String text2,
    String text3,
    String text4,
  ) async {
    try {
      var url =
          'https://api.imgflip.com/caption_image?template_id=$templateId&text0=$text0&text1=$text1&text2=$text2&text3=$text3&text4=$text4&username=$username&password=$password';
      var response = await Dio().get(url);
      log(url);
      imageUrl = response.data['data']['url'];
      return imageUrl;
    } catch (e) {
      // Handle errors
      debugPrint('Error generating meme: $e');
      throw Exception('Error generating meme: $e');
    }
  }

  Future<String> generateMeme3boxes(
      String templateId, String text0, String text1, String text2) async {
    try {
      var url =
          'https://api.imgflip.com/caption_image?template_id=$templateId&username=$username&password=$password';

      // Define an array of text boxes
      var boxes = [
        {'text': text0, 'x': 10, 'y': 10, 'width': 548, 'height': 100},
        {'text': text1, 'x': 10, 'y': 225, 'width': 548, 'height': 100},
        {'text': text2, 'x': 10, 'y': 340, 'width': 548, 'height': 100},
      ];

      // Add the boxes parameter to the URL
      url += '&boxes=${Uri.encodeComponent(boxes.toString())}';

      var response = await Dio().get(url);
      log(url);
      imageUrl = response.data['data']['url'];
      return imageUrl;
    } catch (e) {
      // Handle errors
      debugPrint('Error generating meme: $e');
      throw Exception('Error generating meme: $e');
    }
  }
}
