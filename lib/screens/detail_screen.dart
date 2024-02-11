import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:my_pa/keys/admob_key.dart';
import 'package:my_pa/provider/db_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({
    super.key,
    required this.content,
    required this.id,
    required this.question,
  });
  final String content;
  final String id;
  final String question;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  TextEditingController controller = TextEditingController();

  InterstitialAd? _ad;
  void loadInterstitialAd() {
    final bannerAdsUnitId = Platform.isAndroid ? androidKey : iosKey;

    InterstitialAd.load(
        adUnitId: bannerAdsUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(onAdLoaded: (ad) {
          _ad = ad;
        }, onAdFailedToLoad: (LoadAdError error) async {
          _ad = null;
          await Share.share(controller.text);
        }));
  }

  void showInterstitialAd() {
    if (_ad == null) return;
    _ad!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (aD) {
        debugPrint("Ad showed full screen");
      },
      onAdFailedToShowFullScreenContent: (aD, err) async {
        debugPrint("Ad failed to show full screen");

        await Share.share(controller.text);
        loadInterstitialAd();
      },
      onAdDismissedFullScreenContent: (aD) async {
        debugPrint("Ad has been dismissed");
        await Share.share(controller.text);

        aD.dispose();
        loadInterstitialAd();
      },
      onAdClicked: (aD) {},
    );
    _ad!.show();
  }

  @override
  void initState() {
    super.initState();
    loadInterstitialAd();
    controller = TextEditingController();
    controller.text = widget.content;
  }

  @override
  void didChangeDependencies() {
    loadInterstitialAd();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            titleSpacing: 0,
            title: const Text("Edit Response"),
            actions: [
              IconButton(
                onPressed: () async {
                  if (widget.content == controller.text) {
                    Navigator.of(context).pop();
                    return;
                  }
                  await Future.value(
                          Provider.of<DBProvider>(context, listen: false)
                              .editResponse(widget.id, controller.text))
                      .then((_) {
                    Navigator.of(context).pop();
                  });
                },
                icon: const Icon(Icons.check_outlined),
              ),
              IconButton(
                onPressed: () async {
                  controller.text.isEmpty ? null : showInterstitialAd();
                },
                icon: const Icon(Icons.share_outlined),
              ),
            ]),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: Colors.tealAccent,
                  child: Text("Question:\n${widget.question}"),
                ),
                Container(color: Colors.amber, child: const Text("Response:")),
                TextField(
                  maxLines: null,
                  controller: controller,
                  textInputAction: TextInputAction.newline,
                  decoration: const InputDecoration(
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
