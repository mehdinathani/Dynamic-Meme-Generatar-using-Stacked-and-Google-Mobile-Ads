import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:memegeneraterappusingstacked/app/app.locator.dart';
import 'package:memegeneraterappusingstacked/app/app.router.dart';
import 'package:memegeneraterappusingstacked/config/config.dart';
import 'package:memegeneraterappusingstacked/model/memes_current_data.dart';
import 'package:memegeneraterappusingstacked/services/fetchmemesdata_service.dart';
import 'package:memegeneraterappusingstacked/services/memegenerationservice_service.dart';
import 'package:memegeneraterappusingstacked/ui/dialogs/info_alert/info_alert_dialog_model.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class HomeViewModel extends BaseViewModel {
  String templateId = '';
  String templateURL = "";
  String text0 = '';
  String text1 = '';
  String text2 = 'someone with text 2';
  String text3 = 'someone with text 3';
  String text4 = 'someone with text 4';
  String username = Config.username;
  String password = Config.password;
  String imageUrl = '';
  int selectedBoxCount = 2;
  late List<Meme> memes = [];
  late List<Meme> filteredmemes = [];
  int minCaption = 0;
  int maxCaption = 0;

  // Getter for template names
  List<String> get templateNames => memes.map((meme) => meme.name).toList();
  List<int> get captionslist => memes.map((meme) => meme.captions).toList();
  int getMaxCaptions(List<int> captions) {
    return captions
        .reduce((value, element) => value > element ? value : element);
  }

  int getMinCaptions(List<int> captions) {
    return captions
        .reduce((value, element) => value < element ? value : element);
  }

  getMaxMinCaptions() {
    List<int> captions = memes.map((meme) => meme.captions).toList();
    maxCaption = getMaxCaptions(captions);
    minCaption = getMinCaptions(captions);

    log(maxCaption.toString());
    log(minCaption.toString());
  }

  final BottomSheetService _bottomSheetService = locator<BottomSheetService>();
  final DialogService _dialogService = locator<DialogService>();

  showAboutUS() async {
    await _dialogService.showDialog(
      title: 'About us',
      description:
          'This App is created just for fun and learning purpose. \n \n All Rights are reserved.',
      dialogPlatform: DialogPlatform.Cupertino,
    );
  }

  Future showExitAppMsg() async {
    DialogResponse? response = await _dialogService.showDialog(
      title: 'Are you sure',
      description: "Are you sure want to exit the App",
      buttonTitle: 'Ok',
      cancelTitle: 'Cancel',
      dialogPlatform: DialogPlatform.Cupertino,
    );
    if (response!.confirmed) {
      exit(0);
    }
    debugPrint('DialogResponse: ${response?.confirmed}');
  }

  showInstructions() async {
    var sheetResponse = await _bottomSheetService.showBottomSheet(
      title: 'Instruction to use',
      description:
          '1- Select box count to select your Meme Category.\n \n2- Pick you Meme theme based on name and popularity Rating. \n \n3- You need atleast 1 start to generate your meme. \n \n4- Do watch some Ads to earn rewarded Stars. \n \n5- Each ad you see will give you 1 star. \n \n 6- You can share your Meme as many time as you can. ',
    );
  }

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
    templateURL = selectedMeme.url;
    log(templateURL);

    return selectedId;
  }

  navigateToHome() {
    navigationService.navigateToHomeView();
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
      switch (selectedBoxCount) {
        case 2:
          imageUrl = await _memeservice.generateMemeWith2Boxes(
              templateId, text0, text1);
          break;
        case 3:
          imageUrl = await _memeservice.generateMeme3boxesArray(
              templateId, text0, text1, text2);
          break;
        case 4:
          imageUrl = await _memeservice.generateMeme4boxesArray(
              templateId, text0, text1, text2, text3);
          break;

        case 5:
          imageUrl = await _memeservice.generateMeme5boxesArray(
              templateId, text0, text1, text2, text3, text4);
          break;
        default:
          imageUrl = await _memeservice.generateMemeWith2Boxes(
              templateId, text0, text1);
      }
      // imageUrl =
      //     await _memeservice.generateMeme(templateId, text0, text1, text2);
      //     await _memeservice.generateMeme(templateId, text0, text1, text2);
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
    setBusy(true);
    // fetchedMemes = await _fetchmemesdataService.fetchMemes();
    // // Use the fetchedMemes directly in your application
    // log(fetchedMemes.toString());
    await _fetchmemesdataService.loadData();
    memes = _fetchmemesdataService
        .memes; // Assign the loaded memes to the ViewModel property

    getMaxMinCaptions();

    setBusy(false);
  }

  updateSelectedBoxes(int n) {
    setBusy(true);
    selectedBoxCount = n;
    filteredmemes =
        memes.where((meme) => meme.boxCount == selectedBoxCount).toList();
    setBusy(false);
  }

  List<int> getUniqueSortedBoxCounts(List<Meme> memes) {
    if (memes.isEmpty) {
      // Handle the case when the list is empty
      return [];
    }

    // Step 1: Collect box counts
    List<int> boxCounts = memes.map((meme) => meme.boxCount).toList();

    // Step 2: Convert to set (unique values)
    Set<int> uniqueBoxCounts = boxCounts.toSet();

    // Step 3: Sort the set
    List<int> sortedUniqueBoxCounts = uniqueBoxCounts.toList()..sort();

    return sortedUniqueBoxCounts;
  }

  double normalizeRating(int caption, int max, int min) {
    // Ensure that the min and max values are different to avoid division by zero
    if (max == min) {
      return 0.0; // or any default value
    }

    // Normalize the caption value between 0 and 1 based on the range of max and min
    double normalizedValue = (caption - min) / (max - min);

    // Map the normalized value to the range between 1 and 5
    double rating = normalizedValue * 4 + 1;

    return rating;
  }

  // Add a new method in your HomeViewModel to create the widget
  Widget memeRatingWidget(String memeName, double rating) {
    return Row(
      children: [
        Text('$memeName - Rating:'),
        RatingBar.builder(
          initialRating: rating,
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
          itemBuilder: (context, _) => const Icon(
            Icons.star,
            color: Colors.amber,
          ),
          onRatingUpdate: (rating) {
            debugPrint(rating.toString());
          },
        ),
      ],
    );
  }
}
