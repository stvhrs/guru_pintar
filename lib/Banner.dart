import 'dart:developer';

import 'package:Bupin/ApiServices.dart';
import 'package:Bupin/WebivewPolos.dart';
import 'package:Bupin/styles/PageTransitionTheme.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:url_launcher/url_launcher.dart';

class HalamanBanner extends StatefulWidget {
  const HalamanBanner({super.key});

  @override
  State<HalamanBanner> createState() => _HalamanBannerState();
}

bool closed = false;

class _HalamanBannerState extends State<HalamanBanner> {
  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return closed == true
        ? const SizedBox()
        : FutureBuilder<Map<String, dynamic>>(
            future: ApiService.checkBanner(),
            builder: (context, snapshot) {
              log("banner");
              return PopScope(
                  canPop: false,
                  child: Center(
                      child: (snapshot.connectionState !=
                                  ConnectionState.done ||
                              snapshot.data!.isEmpty)
                          ? Scaffold(
                              backgroundColor: Colors.black.withOpacity(0.7),
                              body: Center(
                                child: CircularProgressIndicator(
                                  color: Theme.of(context).primaryColor,
                                  backgroundColor:
                                      const Color.fromRGBO(236, 180, 84, 1),
                                ),
                              ))
                          : snapshot.data!["image"] == null
                              ? Builder(builder: (context) {
                                  closed = true;
                                  return const SizedBox();
                                })
                              : Scaffold(
                                  backgroundColor:
                                      Colors.black.withOpacity(0.7),
                                  body: Center(
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(25)),
                                      child: GestureDetector(
                                          onTap: () {
                                            if ((snapshot.data!["link"]
                                                    as String)
                                                .isNotEmpty) {
                                              if (snapshot.data!["external"]==true) {
                                                _launchInBrowser(Uri.parse(
                                                    snapshot.data!["link"]));
                                              } else {
                                                Navigator.of(context)
                                                    .push(CustomRoute(
                                                  builder: (context) =>
                                                      HalamanWebview(snapshot
                                                          .data!["link"]),
                                                ));
                                              }
                                            }
                                          },
                                          child: Stack(
                                            alignment: Alignment.topRight,
                                            children: [
                                              FadeInImage(
                                                imageErrorBuilder: (context,
                                                        error, stackTrace) =>
                                                    Image.asset(
                                                        "asset/place.png"),
                                                image: NetworkImage(
                                                  snapshot.data!["image"],
                                                ),
                                                placeholder: const AssetImage(
                                                  "asset/place.png",
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(0.0),
                                                child: CircleAvatar(
                                                  backgroundColor: snapshot
                                                                  .data![
                                                              "dismissable"] ==
                                                          true
                                                      ? Colors.white
                                                      : Colors.transparent,
                                                  child: IconButton(
                                                      color: Colors.red,
                                                      focusColor: Colors.red,
                                                      hoverColor: Colors.red,
                                                      onPressed: () {
                                                        if (snapshot.data![
                                                                "dismissable"] ==
                                                            true) {
                                                          closed = true;
                                                          setState(() {});
                                                        }
                                                      },
                                                      icon: Icon(
                                                        Icons.close,
                                                        color: snapshot.data![
                                                                    "dismissable"] ==
                                                                true
                                                            ? Colors.red
                                                            : Colors
                                                                .transparent,
                                                      )),
                                                ),
                                              )
                                            ],
                                          )),
                                    ),
                                  ))));
            });
  }
}
