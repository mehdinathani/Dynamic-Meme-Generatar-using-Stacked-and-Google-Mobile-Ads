import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:memegeneraterappusingstacked/model/memes_current_data.dart';
import 'package:memegeneraterappusingstacked/ui/common/custom_drawer_buttons.dart';
import 'package:memegeneraterappusingstacked/ui/views/home/home_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:intl/intl.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    int dummuyReward = 1;
    final oCcy = NumberFormat("#,##0", "en_US");

    return ViewModelBuilder<HomeViewModel>.reactive(
      onViewModelReady: (viewModel) => viewModel.fetchMemeData(),
      viewModelBuilder: () => HomeViewModel(),
      builder: (context, viewModel, child) {
        return Scaffold(
          drawer: Drawer(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              children: [
                const DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.purple,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(20),
                      top: Radius.circular(0),
                    ),
                  ),
                  child: SizedBox(
                      width: double.infinity,
                      child: Text(
                        "Ultimate Meme Generator",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30),
                      )),
                ),
                CustomDrawerButton(
                  onTap: () {
                    viewModel.navigateToHome();
                  },
                  icon: Icons.home,
                  text: "Home",
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomDrawerButton(
                    onTap: () {
                      viewModel.showInstructions();
                    },
                    icon: Icons.document_scanner_outlined,
                    text: "Instrunctions"),
                const SizedBox(
                  height: 20,
                ),
                CustomDrawerButton(
                    onTap: () {
                      viewModel.showAboutUS();
                    },
                    icon: Icons.app_shortcut,
                    text: 'About US'),
                const SizedBox(
                  height: 20,
                ),
                CustomDrawerButton(
                    onTap: () async {}, icon: Icons.share, text: 'Share'),
                const SizedBox(
                  height: 20,
                ),
                CustomDrawerButton(
                    onTap: () async {
                      await viewModel.showExitAppMsg();
                    },
                    icon: Icons.exit_to_app,
                    text: "Exit")
              ],
            ),
          ),
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            actions: [
              IconButton(
                  onPressed: () {
                    viewModel.fetchMemeData();
                  },
                  icon: const Icon(Icons.sync))
            ],
            backgroundColor: Colors.purple,
            centerTitle: true,
            title: const Text(
              "Meme Generator",
              style: TextStyle(color: Colors.white),
            ),
          ),
          body: SafeArea(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    opacity: 0.3,
                    image: NetworkImage(
                      viewModel.templateURL == ""
                          ? "https://imgflip.com/s/meme/Success-Kid.jpg"
                          : viewModel.templateURL,
                    ),
                    fit: BoxFit.fill),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: viewModel.isBusy
                            ? CircularProgressIndicator()
                            : Visibility(
                                visible: !viewModel.isBusy,
                                child: Column(
                                  children: [
                                    Container(
                                      color: Colors.black,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "GuestName",
                                            //"   ${viewModel.guestUserName}",
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 24.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            "Stars",
                                            //'Stars ${viewModel.admobService.rewardedScore} ⭐  ',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 24.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    DropdownSearch<int>(
                                      dropdownDecoratorProps:
                                          DropDownDecoratorProps(
                                              dropdownSearchDecoration:
                                                  InputDecoration(
                                                      label: const Text(
                                                          "Select Boxes"),
                                                      hintText: "Boxes",
                                                      border:
                                                          OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          30)))),
                                      popupProps: const PopupProps.menu(
                                        menuProps: MenuProps(
                                            barrierLabel: "Search Here"),
                                        searchFieldProps: TextFieldProps(
                                          autocorrect: true,
                                          autofocus: true,
                                          enableSuggestions: true,
                                          decoration: InputDecoration(
                                              label: Text("Search"),
                                              hintText: "Start Typing",
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(30),
                                                ),
                                              )),
                                        ),
                                      ),

                                      items: viewModel.getUniqueSortedBoxCounts(
                                          viewModel.memes),
                                      onChanged: (int? newValue) {
                                        viewModel
                                            .updateSelectedBoxes(newValue ?? 2);
                                      },
                                      // Add any other necessary properties
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      // height: MediaQuery.of(context).size.height * 0.1,
                                      child: DropdownSearch<Meme>(
                                        popupProps: PopupProps.menu(
                                          showSearchBox: true,
                                          itemBuilder: (BuildContext context,
                                              Meme meme, bool isSelected) {
                                            double rating =
                                                viewModel.normalizeRating(
                                              meme.captions,
                                              viewModel.maxCaption,
                                              viewModel.minCaption,
                                            );

                                            return ListTile(
                                              title: Text(
                                                '${meme.name} - Rating:',
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              subtitle: RatingBar.builder(
                                                initialRating: rating,
                                                minRating: 1,
                                                direction: Axis.horizontal,
                                                allowHalfRating: true,
                                                itemCount: 5,
                                                itemPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 4.0),
                                                itemBuilder: (context, _) =>
                                                    Icon(
                                                  Icons.star,
                                                  color: Colors.amber,
                                                ),
                                                onRatingUpdate: (rating) {
                                                  print(rating);
                                                },
                                              ),
                                            );
                                          },
                                          menuProps: MenuProps(
                                              barrierLabel: "Search Here"),
                                          searchFieldProps: TextFieldProps(
                                            autocorrect: true,
                                            autofocus: true,
                                            enableSuggestions: true,
                                            decoration: InputDecoration(
                                                label: Text("Search"),
                                                hintText: "Start Typing",
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(30),
                                                  ),
                                                )),
                                          ),
                                        ),
                                        items: viewModel.filteredmemes,
                                        // viewModel.memes
                                        //     .where((meme) =>
                                        //         meme.boxCount ==
                                        //         viewModel.selectedBoxCount)
                                        //     .toList(),
                                        itemAsString: (Meme meme) {
                                          double rating =
                                              viewModel.normalizeRating(
                                                  meme.captions,
                                                  viewModel.maxCaption,
                                                  viewModel.minCaption);
                                          return '${meme.name} - Rating:  ${rating.toStringAsFixed(2)}';
                                        },
                                        onChanged: (Meme? newValue) {
                                          debugPrint(
                                              "Selected Meme: ${newValue?.name}");
                                          // viewModel.selectedMeme = newValue;
                                          viewModel.templateId =
                                              newValue?.id.toString() ?? '0';
                                          debugPrint(
                                              "Updated templateId: ${viewModel.templateId}");
                                          viewModel.templateURL =
                                              newValue?.url.toString() ?? "";
                                          debugPrint(
                                              "Updated templateUrl: ${viewModel.templateURL}");
                                        },
                                        dropdownDecoratorProps:
                                            const DropDownDecoratorProps(
                                                dropdownSearchDecoration:
                                                    InputDecoration(
                                          label: Text("Search Meme"),
                                          hintText: "Search Meme",
                                          border: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.blue),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(30)),
                                          ),
                                        )),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    TextFormField(
                                      onChanged: (value) =>
                                          viewModel.text0 = value,
                                      decoration: const InputDecoration(
                                        labelText: '1st Text',
                                        border: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(30),
                                          ),
                                        ),
                                      ),
                                      validator: (value) {
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 16),
                                    TextFormField(
                                      onChanged: (value) =>
                                          viewModel.text1 = value,
                                      decoration: const InputDecoration(
                                        labelText: '2nd Text',
                                        border: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(30),
                                          ),
                                        ),
                                      ),
                                      validator: (value) {
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 16),
                                    // show 3rd text box if selected box is 3 or more
                                    Visibility(
                                      visible: viewModel.selectedBoxCount > 2,
                                      child: TextFormField(
                                        onChanged: (value) =>
                                            viewModel.text2 = value,
                                        decoration: const InputDecoration(
                                          labelText: '3rd Text',
                                          border: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.white),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(30),
                                            ),
                                          ),
                                        ),
                                        validator: (value) {
                                          return null;
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    // show 3rd text box if selected box is 4 or more
                                    Visibility(
                                      visible: viewModel.selectedBoxCount > 3,
                                      child: TextFormField(
                                        onChanged: (value) =>
                                            viewModel.text3 = value,
                                        decoration: const InputDecoration(
                                          labelText: '4th Text',
                                          border: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.white),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(30),
                                            ),
                                          ),
                                        ),
                                        validator: (value) {
                                          return null;
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    // show 3rd text box if selected box is 4 or more
                                    Visibility(
                                      visible: viewModel.selectedBoxCount > 4,
                                      child: TextFormField(
                                        onChanged: (value) =>
                                            viewModel.text4 = value,
                                        decoration: const InputDecoration(
                                          labelText: '5th Text',
                                          border: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.white),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(30),
                                            ),
                                          ),
                                        ),
                                        validator: (value) {
                                          return null;
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 46),
                                    ElevatedButton(
                                      style: ButtonStyle(
                                        fixedSize: MaterialStateProperty.all(
                                            const Size(350, 60)),
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.purple),
                                      ),
                                      onPressed: () async {
                                        if (dummuyReward > 0) {
                                          await viewModel.generateMeme();
                                          viewModel.navigateTOMemeView();
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  "You Need at least 1 Star to generate this meme. Please see some Ads to earn Stars"),
                                            ),
                                          );
                                        }
                                      },
                                      child: viewModel.isBusy
                                          ? const CircularProgressIndicator()
                                          : const Text(
                                              'Generate Meme',
                                              style: TextStyle(
                                                  fontSize: 24,
                                                  color: Colors.white),
                                            ),
                                    ),
                                    const SizedBox(height: 16),
                                    ElevatedButton(
                                      style: ButtonStyle(
                                        fixedSize: MaterialStateProperty.all(
                                            const Size(350, 60)),
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.purple),
                                      ),
                                      onPressed: () async {
                                        // await viewModel.showRewardedAd();
                                      },
                                      child: const Text(
                                        "Earn Stars",
                                        style: TextStyle(
                                            fontSize: 24, color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 1,
                    color: Colors.purple,
                    alignment: Alignment.bottomCenter,
                    child: const Center(
                        child: Column(
                      children: [
                        Text(
                          'Made with ❤️ by mehdinathani',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          'Copyright © 2023 All rights reserved.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    )),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
