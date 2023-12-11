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

  Future<String> generateMeme3boxesArray(
      String templateId, String text0, String text1, String text2) async {
    try {
      var url = 'https://api.imgflip.com/caption_image';

      // Define an array of text boxes
      var boxes = [
        {'text': text0},
        {'text': text1},
        {'text': text2} //, 'x': 10, 'y': 340, 'width': 548, 'height': 100},
      ];

      // Encode the boxes parameter
      var encodedBoxes = boxes.map((box) {
        return {
          'text': Uri.encodeQueryComponent(box['text'] as String),
          'x': box['x'],
          'y': box['y'],
          'width': box['width'],
          'height': box['height'],
        };
      }).toList();

      // Define request parameters
      var params = {
        'template_id': templateId,
        'username': username,
        'password': password,
        'boxes': encodedBoxes,
      };

      // Add the boxes parameter to the URL
      var response = await Dio().post(url, queryParameters: params);
      log(response.toString());

      imageUrl = response.data['data']['url'];
      return imageUrl;
    } catch (e) {
      // Handle errors
      debugPrint('Error generating meme: $e');
      throw Exception('Error generating meme: $e');
    }
  }

  Future<String> generateMeme4boxesArray(String templateId, String text0,
      String text1, String text2, String text3) async {
    try {
      var url = 'https://api.imgflip.com/caption_image';

      // Define an array of text boxes
      var boxes = [
        {'text': text0},
        {'text': text1},
        {'text': text2},
        {'text': text3}, //, 'x': 10, 'y': 340, 'width': 548, 'height': 100},
      ];

      // Encode the boxes parameter
      var encodedBoxes = boxes.map((box) {
        return {
          'text': Uri.encodeQueryComponent(box['text'] as String),
          'x': box['x'],
          'y': box['y'],
          'width': box['width'],
          'height': box['height'],
        };
      }).toList();

      // Define request parameters
      var params = {
        'template_id': templateId,
        'username': username,
        'password': password,
        'boxes': encodedBoxes,
      };

      // Add the boxes parameter to the URL
      var response = await Dio().post(url, queryParameters: params);
      log(response.toString());

      imageUrl = response.data['data']['url'];
      return imageUrl;
    } catch (e) {
      // Handle errors
      debugPrint('Error generating meme: $e');
      throw Exception('Error generating meme: $e');
    }
  }

  Future<String> generateMeme5boxesArray(
    String templateId,
    String text0,
    String text1,
    String text2,
    String text3,
    String text4,
  ) async {
    try {
      var url = 'https://api.imgflip.com/caption_image';

      // Define an array of text boxes
      var boxes = [
        {'text': text0},
        {'text': text1},
        {'text': text2},
        {'text': text3},
        {'text': text4}, //, 'x': 10, 'y': 340, 'width': 548, 'height': 100},
      ];

      // Encode the boxes parameter
      var encodedBoxes = boxes.map((box) {
        return {
          'text': Uri.encodeQueryComponent(box['text'] as String),
          'x': box['x'],
          'y': box['y'],
          'width': box['width'],
          'height': box['height'],
        };
      }).toList();

      // Define request parameters
      var params = {
        'template_id': templateId,
        'username': username,
        'password': password,
        'boxes': encodedBoxes,
      };

      // Add the boxes parameter to the URL
      var response = await Dio().post(url, queryParameters: params);
      log(response.toString());

      imageUrl = response.data['data']['url'];
      return imageUrl;
    } catch (e) {
      // Handle errors
      debugPrint('Error generating meme: $e');
      throw Exception('Error generating meme: $e');
    }
  }
}
