import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:memegeneraterappusingstacked/app/app.locator.dart';
import 'package:memegeneraterappusingstacked/app/app.router.dart';
import 'package:memegeneraterappusingstacked/config/config.dart';
import 'package:memegeneraterappusingstacked/model/memes_current_data.dart';
import 'package:memegeneraterappusingstacked/services/fetchmemesdata_service.dart';
import 'package:memegeneraterappusingstacked/services/memegenerationservice_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class HomeViewModel extends BaseViewModel {
  String templateId = '';
  String text0 = '';
  String text1 = '';
  String username = Config.username;
  String password = Config.password;
  String imageUrl = '';
  late List<Meme> memes = [];

  // Getter for template names
  List<String> get templateNames => memes.map((meme) => meme.name).toList();

  final MemegenerationserviceService _memeservice =
      locator<MemegenerationserviceService>();

  final navigationService = locator<NavigationService>();
  final FetchmemesdataService _fetchmemesdataService =
      locator<FetchmemesdataService>();

  int getMemeIDbyNameFromList(String memeName) {
    final selectedMeme = memes.firstWhere(
      (meme) => meme.name == memeName,
      orElse: () => Meme(
          id: '0',
          name: '',
          url: '',
          width: 0,
          height: 0,
          boxCount: 0,
          captions: 0),
    );

    log(selectedMeme.toString());

    int selectedId = int.parse(selectedMeme.id);
    log(selectedId.toString());

    return selectedId;
  }

  navigateTOMemeView() {
    navigationService.navigateToMemeviewView();
  }

  Future<void> generateMeme() async {
    if (templateId.isEmpty || text0.isEmpty || text1.isEmpty) {
      // Perform validation and show an error message if needed
      // You may use a state variable to manage the error message in your UI
      return;
    }

    setBusy(true);

    try {
      imageUrl = await _memeservice.generateMeme(templateId, text0, text1);
      log(imageUrl);

      // Notify listeners that the data has been changed
      notifyListeners();
    } catch (e) {
      // Handle errors
      debugPrint('Error generating meme: $e');

      // You may set an error message state variable here for user feedback
    } finally {
      setBusy(false);
    }
  }

  Future<void> fetchMemeData() async {
    // fetchedMemes = await _fetchmemesdataService.fetchMemes();
    // // Use the fetchedMemes directly in your application
    // log(fetchedMemes.toString());
    await _fetchmemesdataService.loadData();
    memes = _fetchmemesdataService
        .memes; // Assign the loaded memes to the ViewModel property
  }
}
