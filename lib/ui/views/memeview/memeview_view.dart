import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'memeview_viewmodel.dart';

class MemeviewView extends StackedView<MemeviewViewModel> {
  const MemeviewView({super.key});

  @override
  Widget builder(
    BuildContext context,
    MemeviewViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        centerTitle: true,
        title: const Text(
          "Generated Meme",
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                      // decorate the border of the container to make the container border visible
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 5,
                        ),
                      ),
                      child: Image.network(viewModel.imageUrl)),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all(const Size(200, 60)),
                      backgroundColor: MaterialStateProperty.all(Colors.purple),
                    ),
                    onPressed: () async {
                      await viewModel.shareAndSaveImage();
                    },
                    icon: const Icon(
                      Icons.share,
                      color: Colors.white,
                      size: 24,
                    ),
                    label: const Text(
                      "Share",
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            const Expanded(child: SizedBox()),
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
  }

  @override
  MemeviewViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      MemeviewViewModel();
  @override
  onViewModelReady(MemeviewViewModel viewModel) {
    viewModel.getImageURL();
    super.onViewModelReady(viewModel);
  }
}
