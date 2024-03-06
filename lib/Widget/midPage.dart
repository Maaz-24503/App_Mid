import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:app/Model/Launch.dart';
import 'package:http/http.dart' as http;

class MidPage extends StatefulWidget {
  const MidPage({Key? key}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _MidPageState createState() => _MidPageState();
}

class _MidPageState extends State<MidPage> {

  bool isPressed = true;

  void _changePressed() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      isPressed = !isPressed;
    });
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Space Missions',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color.fromARGB(255, 13, 92, 15),
        ),
        body: FutureBuilder(
          future: fetchProducts(),
          builder: (context, snapshot) {
            // for(int i = 0; i<snapshot.data!.length; i++){
            //   for(int j = 0; j<snapshot.data![i].payloadIds!.length; j++){
            //     print(snapshot.data![i].payloadIds![j]);
            //   }
            // }
            if (snapshot.hasData) {
              var arr = snapshot.data!;
              return ListView.builder(
                itemCount: arr.length,
                itemBuilder: (context, index) {
                  
                  return Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      elevation: 5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              arr[index].missionName!,
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.w700),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              arr[index].description!,
                              style: const TextStyle(
                                  overflow: TextOverflow.ellipsis),
                              maxLines: isPressed?1:999,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                const Expanded(flex: 7, child: SizedBox()),
                                Expanded(
                                  flex: 3,
                                  child: ElevatedButton(
                                    onPressed: () {_changePressed();},
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(isPressed?'Less ':'More '),
                                        Icon(isPressed?Icons.arrow_downward: Icons.arrow_upward)
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // GridView.builder(
                          //   itemCount: snapshot.data![index].payloadIds?.length,
                          //   gridDelegate:
                          //       SliverGridDelegateWithMaxCrossAxisExtent(
                          //           maxCrossAxisExtent:
                          //               MediaQuery.of(context).size.width,
                          //           crossAxisSpacing: 4.0,
                          //           mainAxisSpacing: 4.0),
                          //   itemBuilder: (context, i) {
                          //     return Card(
                          //         color: Color(
                          //                 (Random().nextDouble() * 0xFFFFFF)
                          //                     .toInt())
                          //             .withOpacity(1.0),
                          //         child: Text(snapshot.data![index].payloadIds?[i] ?? ""));
                          //   },
                          // )
                        ],
                      ),
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('Error fetching data'),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }

  Future<List<Launch>> fetchProducts() async {
    final response =
        await http.get((Uri.parse('https://api.spacexdata.com/v3/missions')));

    if (response.statusCode == 200) {
      var parsedListJson = json.decode(response.body);

      List<Launch> itemsList = List<Launch>.from(
          parsedListJson.map<Launch>((dynamic user) => Launch.fromJson(user)));

      return itemsList;
    } else {
      throw Exception();
    }
  }
}
