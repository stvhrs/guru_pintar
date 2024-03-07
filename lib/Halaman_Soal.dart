
import 'dart:developer';

import 'package:Bupin/Halaman_Laporan_Error.dart';
import 'package:Bupin/styles/PageTransitionTheme.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HalamanSoal extends StatefulWidget {
  final String url;
  final String jenjang;
  final bool soalScan;
  final String cbtSdSmpSma;
  const HalamanSoal(this.url, this.jenjang, this.soalScan, this.cbtSdSmpSma, {super.key});

  @override
  State<HalamanSoal> createState() => _HalamanSoalState();
}

class _HalamanSoalState extends State<HalamanSoal>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  );
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeIn,
  );
  late final AnimationController _controller2 = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  )..repeat(reverse: true);
  late final Animation<double> _animation2 = CurvedAnimation(
    parent: _controller2,
    curve: Curves.easeIn,
  );
  @override
  void dispose() {
    _controller.dispose();
    _controller2.dispose();
    super.dispose();
  }

  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(NavigationDelegate(
        onProgress: (int progress) {
          // Update loading bar.
        },
        onPageStarted: (String url) {},
        onWebResourceError: (e) {},
        onPageFinished: (String url) {
          _controller2.animateBack(0);
          _controller.forward();
        },
      ))
      ..loadRequest(
        Uri.parse(widget.url),
      );
    controller.setBackgroundColor(Colors.white);
  }

  @override
  Widget build(BuildContext context) {log("Soal");
    // ignore: deprecated_member_use
    return  WillPopScope(
     onWillPop: () {
       Navigator.pop(context, false);
       return Future.value(true);
     },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: widget.jenjang.contains("SD/MI")
              ? const Color.fromRGBO(205, 32, 49, 0.8)
              : widget.jenjang.contains("SMP/MTS")
                  ? const Color.fromRGBO(58, 88, 167, 0.8)
                  : const Color.fromRGBO(120, 163, 215, 0.8),
          actions: [
            widget.soalScan == true
                ? Container(
                    padding:
                        const EdgeInsets.only(right: 10, left: 10, top: 5, bottom: 5),
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50)),
                    child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(CustomRoute(
                                builder: (context) => widget.jenjang.contains("SD/MI")
                                    ? HalamanLaporan(widget.url.replaceAll(
                                        "https://cbtsd.bupin.id/login.php?",
                                        ""))
                                    : HalamanLaporan(widget.url.replaceAll(
                                        "https://tim.bupin.id/${widget.cbtSdSmpSma}/login.php?",
                                        "")),
                              ));
                            },
                            child: const Row(
                      children: [
                        Text(
                          "Laporkan Bug",
                          style: TextStyle(color: Colors.red),
                        ),
                        Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Icon(
                                Icons.warning_rounded,
                                color: Colors.red,
                                size: 16,
                              ),
                            ),
                      ],
                    ),
                    ))
                : const SizedBox()
          ],
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              icon: const Icon(
                Icons.arrow_back_rounded,
                color: Colors.white,
              )),
          title: Text(
            widget.jenjang,
            style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
          ),
        ),
        body: Stack(
          alignment: Alignment.center,
          children: [
            FadeTransition(
              opacity: _animation,
              child: WebViewWidget(controller: controller),
            ),
            FadeTransition(
              opacity: _animation2,
              child: Image.asset(
                "asset/logo.png",
                width: MediaQuery.of(context).size.width * 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
