import 'package:flutter/material.dart';
import 'package:memegeneraterappusingstacked/model/memes_current_data.dart';
import 'package:memegeneraterappusingstacked/ui/views/home/home_viewmodel.dart';
import 'package:stacked/stacked.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    int dummuyReward = 1;
    return ViewModelBuilder<HomeViewModel>.reactive(
      onViewModelReady: (viewModel) => viewModel.fetchMemeData(),
      viewModelBuilder: () => HomeViewModel(),
      builder: (context, viewModel, child) {
        return Scaffold(
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
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        children: [
                          Container(
                            color: Colors.black,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            height: 40,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            height: MediaQuery.of(context).size.height * 0.1,
                            child: DropdownButtonFormField<Meme>(
                              isExpanded: true,
                              // value: viewModel.selectedMeme,
                              items: viewModel.memes
                                  .map<DropdownMenuItem<Meme>>((meme) {
                                return DropdownMenuItem<Meme>(
                                  value: meme,
                                  child: RichText(
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: meme.name,
                                          style: const TextStyle(
                                            decoration: TextDecoration.none,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        TextSpan(
                                          text:
                                              ' (boxes: ${meme.boxCount}, captions: ${meme.captions})',
                                          style: const TextStyle(
                                            decoration: TextDecoration.none,
                                            color: Colors.black,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (Meme? newValue) {
                                debugPrint("Selected Meme: ${newValue?.name}");
                                // viewModel.selectedMeme = newValue;
                                viewModel.templateId =
                                    newValue?.id.toString() ?? '0';
                                debugPrint(
                                    "Updated templateId: ${viewModel.templateId}");
                              },
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30)),
                                ),
                                labelText: 'Select Meme',
                                labelStyle: TextStyle(color: Colors.blue),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            onChanged: (value) => viewModel.text0 = value,
                            decoration: const InputDecoration(
                              labelText: '1st Text',
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
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
                            onChanged: (value) => viewModel.text1 = value,
                            decoration: const InputDecoration(
                              labelText: '2nd Text',
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(30),
                                ),
                              ),
                            ),
                            validator: (value) {
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            style: ButtonStyle(
                              fixedSize: MaterialStateProperty.all(
                                  const Size(350, 60)),
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.purple),
                            ),
                            onPressed: () async {
                              if (dummuyReward > 0) {
                                await viewModel.generateMeme();
                                viewModel.navigateTOMemeView();
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
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
                                        fontSize: 24, color: Colors.white),
                                  ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            style: ButtonStyle(
                              fixedSize: MaterialStateProperty.all(
                                  const Size(350, 60)),
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.purple),
                            ),
                            onPressed: () async {
                              // await viewModel.showRewardedAd();
                            },
                            child: const Text(
                              "Earn Stars",
                              style:
                                  TextStyle(fontSize: 24, color: Colors.white),
                            ),
                          ),
                        ],
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
        );
      },
    );
  }
}
