// Copyright 2020 Sarbagya Dhaubanjar. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:developer';

import 'package:Bupin/ApiServices.dart';
import 'package:Bupin/Halaman_Laporan_Error.dart';
import 'package:Bupin/models/Video.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import 'widgets/play_pause_button_bar.dart';

///
class HalamanVideo extends StatefulWidget {
  final String link;

  const HalamanVideo(this.link, {super.key});
  @override
  HalamanVideoState createState() => HalamanVideoState();
}

class HalamanVideoState extends State<HalamanVideo>
    with TickerProviderStateMixin {
  late final AnimationController _controller2 = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..animateTo(1);
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller2,
    curve: Curves.easeIn,
  );

  @override
  void dispose() {
    _controller2.dispose();

    super.dispose();
  }

  double aspectRatio = 16 / 9;
  late YoutubePlayerController _controller;
  String linkQrVideo = "";
  Video? video;
  bool noInternet = true;

  Future<void> fetchApi() async {
    final dio = Dio();

    linkQrVideo = widget.link
        .replaceAll("buku.bupin.id/?", "bupin.id/api/apibarang.php?kodeQR=");
    final response = await dio.get(linkQrVideo);

    log(response.statusCode.toString());
    if (response.statusCode != 200) {
      noInternet = true;
      return;
    }
    noInternet = false;
    if (response.data[0]["ytid"] == null &&
        response.data[0]["ytidDmp"] == null) {
      return;
    } else {
      video = Video.fromMap(response.data[0]);
    }
    if (video != null) {
      _controller = YoutubePlayerController(
        params: const YoutubePlayerParams(
            mute: false,
            showFullscreenButton: false,
            color: "red",
            loop: false,
            strictRelatedVideos: true),
      );

      _controller.setFullScreenListener(
        (isFullScreen) {},
      );

      _controller.loadVideo(video!.linkVideo!);

      final isVertical = await ApiService.isVertical(video!);

      if (isVertical) {
        aspectRatio = 9 / 16;
      } else {
        aspectRatio = 16 / 9;
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    log("Video");
    // ignore: deprecated_member_use
    return WillPopScope(
     onWillPop: () {
       Navigator.pop(context, false);
       if(  noInternet==false){
        _controller.stopVideo();
       }
       return Future.value(true);
     
     },

      
      child: FutureBuilder<void>(
          future: fetchApi(),
          builder: (context, snapshot) {
            return (noInternet == true)
                ? Scaffold(
                    appBar: AppBar(
                      centerTitle: true,
                      automaticallyImplyLeading: false,
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    backgroundColor: Colors.white,
                    body: Center(
                        child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor,
                      backgroundColor: const Color.fromRGBO(236, 180, 84, 1),
                    )),
                  )
                : video == null
                    ? HalamanLaporan(
                        linkQrVideo.replaceAll(
                          "https://bupin.id/api/apibarang.php?kodeQR=",
                          "",
                        ),
                      )
                    : YoutubePlayerScaffold(
                        backgroundColor: Colors.black,
                        aspectRatio: aspectRatio,
                        controller: _controller,
                        builder: (context, player) {
                          return Scaffold(
                              backgroundColor: Colors.white,
                              appBar: AppBar(
                                centerTitle: true,
                                leading: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: GestureDetector(
                                      onTap: () {
                                        _controller.stopVideo();
                                        // _controller.close();
                                        Navigator.pop(context, false);
                                      },
                                      child: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        child: Center(
                                          child: Icon(
                                            Icons.arrow_back_rounded,
                                            color:
                                                Theme.of(context).primaryColor,
                                            size: 15,
                                            weight: 100,
                                          ),
                                        ),
                                      )),
                                ),
                                backgroundColor: Theme.of(context).primaryColor,
                                title: Text(
                                  video!.namaVideo!,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                              body: LayoutBuilder(
                                builder: (context, constraints) {
                                  return Column(
                                    children: [
                                      Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Image.asset(
                                              "asset/logo.png",
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.5,
                                            ),
                                            FadeTransition(
                                                opacity: _animation,
                                                child: player)
                                          ]),
                                      aspectRatio == 9 / 16
                                          ? const SizedBox()
                                          : Stack(
                                              children: [
                                                aspectRatio == 9 / 16
                                                    ? const SizedBox()
                                                    : Image.asset(
                                                        "asset/Halaman_Scan/Doodle Halaman Scan@4x.png",
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                      ),
                                                const Padding(
                                                  padding: EdgeInsets.only(
                                                      right: 0.0),
                                                  child: PlayPauseButtonBar(),
                                                ),
                                              ],
                                            ),
                                    ],
                                  );
                                },
                              ));
                        },
                      );
          }),
    );
  }
}

class Controls extends StatelessWidget {
  const Controls({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PlayPauseButtonBar(),
        ],
      ),
    );
  }
}

///

