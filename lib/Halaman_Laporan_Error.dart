import 'package:Bupin/ApiServices.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class HalamanLaporan extends StatelessWidget {
  final String id;
  const HalamanLaporan(this.id, {super.key});
  Future<void> _launchInBrowser(String num) async {
    if (!await launchUrl(
      // phone=6285174484832&text=Halo+Saya+Ada+Kode+Error+%3A%0A%2AVID222333%2A&type=phone_number&app_absent=0
      Uri.parse(
          "https://api.whatsapp.com/send/?phone=$num&text=Saya+Menemukan+Kode%20QR+yang+error+berikut+kodenya+%3A%0A%2A$id%2A&type=phone_number&app_absent=0 "),
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch ');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(15.0),
          child: GestureDetector(
              onTap: () {
                Navigator.pop(context, false);
              },
              child: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Center(
                  child: Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.green,
                    size: 15,
                    weight: 100,
                  ),
                ),
              )),
        ),
        backgroundColor: Colors.green,
        title: const Text(
          "Laporan Qr Error",
          style: TextStyle(
              color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700),
        ),
      ),
      backgroundColor: Colors.white,
      body: Stack(alignment: Alignment.center, children: [
        Container(
          color: Colors.white,
          alignment: Alignment.center,
        ),
        Positioned(
            top: 0,
            child: Image.asset(
              "asset/Halaman_Scan/Doodle Halaman Scan@4x.png",
              color: Colors.green.shade900,
              height: MediaQuery.of(context).size.height,
              fit: BoxFit.fitHeight,
              repeat: ImageRepeat.repeatY,
            )),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(
              flex: 5,
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "Mohon maaf atas ketidaknyamannya, kode QR tersebut mengalami error, jika bersedia silahkan laporkan ke CS kami, terimakasih ",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.grey.shade700, fontWeight: FontWeight.w700),
              ),
            ),
            const Spacer(),
            FutureBuilder(
              future: ApiService().fetchCs(),
              builder: (context, snapshot) {
                return ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.green)),
                    onPressed:snapshot.connectionState==ConnectionState.waiting?null: () {
                      _launchInBrowser(snapshot.data!);
                    },
                    child: const Text(
                      "Laporkan ke Whatsapp CS Kami ",
                      textAlign: TextAlign.justify,
                      style: TextStyle(color: Colors.white),
                    ));
              }
            ),
            const Spacer(
              flex: 7,
            ),
          ],
        ),
      ]),
    );
  }
}
