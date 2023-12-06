import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:memegeneraterappusingstacked/model/memes_current_data.dart';
import 'package:path_provider/path_provider.dart';

class FetchmemesdataService {
  late List<Meme> memes;
  Future<List<Map<String, dynamic>>> fetchMemes() async {
    try {
      final response = await Dio().get('https://api.imgflip.com/get_memes');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;

        if (responseData['success'] == true) {
          final List<dynamic> memesData = responseData['data']['memes'];

          return memesData.map((meme) {
            return {
              'id': meme['id'],
              'name': meme['name'],
              'box_count': meme['box_count'],
              'captions': meme['captions'],
            };
          }).toList();
        } else {
          throw Exception('Failed to fetch memes');
        }
      } else {
        throw Exception('Failed to load memes');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }

  Future<void> downloadAndSaveData() async {
    final dio = Dio();
    final response = await dio.get('https://api.imgflip.com/get_memes');

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = response.data;

      // Save the data to a file in the documents directory
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/data.json');
      await file.writeAsString(json.encode(data));
    } else {
      debugPrint('Failed to load data: ${response.statusCode}');
    }
  }

  Future<void> loadData() async {
    try {
      final dio = Dio();
      final response = await dio.get('https://api.imgflip.com/get_memes');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data;

        // Assuming 'memes' is the key containing the list of memes
        final List<dynamic> memesData = data['data']['memes'];

        // Convert the JSON data to a list of Meme objects
        memes = memesData.map((memeData) => Meme.fromJson(memeData)).toList();
        log(memes.toString());
      } else {
        print('Failed to load data: ${response.statusCode}');
        // Handle the error as needed
      }
    } catch (e) {
      print('Error loading data: $e');
      // Handle errors as needed
    }
  }
}
