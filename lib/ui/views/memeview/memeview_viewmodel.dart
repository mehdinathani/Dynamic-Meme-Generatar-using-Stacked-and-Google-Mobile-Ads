import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:memegeneraterappusingstacked/app/app.locator.dart';
import 'package:memegeneraterappusingstacked/services/memegenerationservice_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stacked/stacked.dart';

class MemeviewViewModel extends BaseViewModel {
  final MemegenerationserviceService _memeservice =
      locator<MemegenerationserviceService>();

  String imageUrl = "";
  String localImagePath = "";

  getImageURL() {
    imageUrl = _memeservice.imageUrl;
    log(imageUrl);
  }

  Future saveImageToGallery() async {
    try {
      // Create a Dio instance
      Dio dio = Dio();

      // Fetch the image bytes
      Response<List<int>> response = await dio.get<List<int>>(imageUrl,
          options: Options(responseType: ResponseType.bytes));

      // Get the app's documents directory
      Directory appDocumentsDirectory =
          await getApplicationDocumentsDirectory();

      // Create a unique file name based on the current timestamp
      String fileName = "${DateTime.now().millisecondsSinceEpoch}.jpg";

      // Create the file path
      String filePath = "${appDocumentsDirectory.path}/$fileName";

      // Write the image bytes to the file
      File file = File(filePath);
      await file.writeAsBytes(response.data!);

      // Save the image to the gallery
      await ImageGallerySaver.saveFile(filePath);
      localImagePath = filePath;
      debugPrint('Image saved to gallery to $filePath ');
      return filePath;
    } catch (e) {
      debugPrint('Error saving image to gallery: $e');
    }
  }

  Future<void> shareAndSaveImage() async {
    try {
      // Download and get the local file path
      String localFilePath = await saveImageToGallery();

      if (localFilePath.isNotEmpty) {
        // Share the image using share_plus
        await Share.shareFiles([localFilePath], text: 'Check out this meme!');
      } else {
        // Handle the case when the image download fails
        debugPrint('Failed to download and save image');
      }
    } catch (e) {
      // Handle errors
      if (kDebugMode) {
        debugPrint('Error sharing and saving image: $e');
      }
    }
  }
}
