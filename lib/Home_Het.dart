import 'package:Bupin/models/Het.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

import 'package:url_launcher/url_launcher.dart';

const List<String> list = <String>[
  'SD/MI  I',
  'SD/MI  II',
  'SD/MI  III',
  'SD/MI  IV',
  'SD/MI  V',
  'SD/MI  VI',
  'SMP/MTS  VII',
  "SMP/MTS  VIII",
  "SMP/MTS  IX",
  "SMA/MA  X",
  "SMA/MA  XI",
  "SMA/MA  XII"
];
List<String> listKelas = <String>[
  'I',
  'II',
  'III',
  'IV',
  'V',
  'VI',
  'VII',
  "VIII",
  "IX",
  "X",
  "XI",
  "XII"
];

class HalmanHet extends StatefulWidget {
  const HalmanHet({super.key});

  @override
  State<HalmanHet> createState() => _HalmanHetState();
}

class _HalmanHetState extends State<HalmanHet> {
  List<Het> listHET = [];

  Future<void> fetchApi() async {
    try {
      listHET.clear();
      final dio = Dio();
      int data = list.indexOf(dropdownValue);
      final response = await dio
          .get("https://bupin.id/api/het?kelas=${listKelas[data]}");

      if (response.statusCode == 200) {
        for (Map<String, dynamic> element in response.data) {
          log(element.toString());
          listHET.add(Het.fromMap(element));
        }

        setState(() {});
      }
    } catch (e) {
      log("errrorrr");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchApi();
  }

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  String dropdownValue = list.first;
  @override
  Widget build(BuildContext context) {
    log("het");
    return SafeArea(
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Image.asset("asset/Halaman_HET/Doodle HET-8.png"),
              Positioned(
                  right: 20,
                  bottom: 10,
                  child: Image.asset(
                    "asset/Halaman_HET/Bukut Het-9.png",
                    width: MediaQuery.of(context).size.width * 0.3,
                  )),
              const Positioned(
                  left: 10,
                  bottom: 10,
                  child: Text(
                    "Katalog\nBuku Sekolah\nElektronik (BSE)",
                    style: TextStyle(
                        height: 1.22,
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        fontStyle: FontStyle.italic),
                  )),
              Positioned(
                  left: 5,
                  top: 5,
                  child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Image.asset(
                          "asset/Halaman_HET/kemendikbud.png",
                          width: MediaQuery.of(context).size.width * 0.19,
                        ),
                      ))),
            ],
          ),
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.only(right: 7, left: 7, top: 7, bottom: 7),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    "asset/Halaman_HET/Logo Kurmer.png",
                    width: MediaQuery.of(context).size.width * 0.21,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.width * 0.19 * 9 / 16,
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10)),
                    child: DropdownButton<String>(
                      padding: EdgeInsets.zero,
                      value: dropdownValue,
                      dropdownColor: Colors.white,
                      iconEnabledColor: const Color.fromARGB(255, 66, 66, 66),
                      icon: const Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Icon(
                          Icons.arrow_downward_rounded,
                          size: 16,
                          weight: 10,
                        ),
                      ),
                      elevation: 16,
                      style: const TextStyle(
                          fontFamily: "Nunito",
                          fontWeight: FontWeight.w900,
                          color: Color.fromARGB(255, 66, 66, 66)),
                      underline: Container(
                        height: 0,
                        color: Colors.transparent,
                      ),
                      onChanged: (String? value) {
                        // This is called when the user selects an item.

                        dropdownValue = value!;
                        setState(() {});
                        fetchApi();
                      },
                      items: list.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          listHET.isEmpty
              ? Expanded(
                  child: Container(
                    color: Colors.white,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).primaryColor,
                        backgroundColor: const Color.fromRGBO(236, 180, 84, 1),
                      ),
                    ),
                  ),
                )
              : Expanded(
                  flex: 10,
                  child: Container(
                    color: Colors.white,
                    child: GridView.builder(
                      padding: const EdgeInsets.only(top: 20),
                      itemCount: listHET.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              mainAxisSpacing: 0,
                              crossAxisCount: 2,
                              childAspectRatio: 0.8),
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                            splashColor: Theme.of(context).primaryColor,
                            hoverColor: Theme.of(context).primaryColor,
                            highlightColor: Theme.of(context).primaryColor,
                            focusColor: Theme.of(context).primaryColor,
                            onTap: () {
                              _launchInBrowser(Uri.parse(listHET[index].pdf));
                            },
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                    margin: const EdgeInsets.only(bottom: 8),
                                    child: Container(
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          child: FadeInImage(
                                            imageErrorBuilder:
                                                (context, error, stackTrace) {
                                              return Image.asset(
                                                "asset/place.png",
                                              );
                                            },
                                            image: NetworkImage(
                                              listHET[index].imgUrl,
                                            ),
                                            placeholder: const AssetImage(
                                              "asset/place.png",
                                            ),
                                          )),
                                    ),
                                  ),
                                  Center(
                                      child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10.0, right: 10),
                                    child: Text(
                                      listHET[index].namaBuku,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: Color.fromARGB(255, 66, 66, 66),
                                        fontSize: 10,
                                        overflow: TextOverflow.fade,
                                      ),
                                    ),
                                  )),
                                ])),
                      ),
                    ),
                  ),
                )
        ],
      ),
    );
  }
}
