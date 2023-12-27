import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wallpers_app/clickwall.dart';

class WallpaperScreen extends StatefulWidget {
  const WallpaperScreen({super.key});

  @override
  State<WallpaperScreen> createState() => _WallpaperScreenState();
}

class _WallpaperScreenState extends State<WallpaperScreen> {
// api key =  nEvqBxGR4E27nj7qBFCiEiPU8fdDSCJUJSjWiKOv6lZCF7szv3ngfssi

  List images = [];
  int page = 1;

  requestApi() async {
    http.Response response = await http.get(
        Uri.parse('https://api.pexels.com/v1/curated?per_page=80'),
        headers: {
          'Authorization':
              'nEvqBxGR4E27nj7qBFCiEiPU8fdDSCJUJSjWiKOv6lZCF7szv3ngfssi'
        });
    //     .then((value) {
    //   debugPrint(value.body);
    // }
    // );
    final result = jsonDecode(response.body);

    setState(() {
      images = result['photos'];
      debugPrint(images.toString());
    });
  }

  @override
  void initState() {
    super.initState();
    requestApi();
  }

  loadMore() async {
    setState(() {
      page = page + 1;
    });

    String url = "https://api.pexels.com/v1/curated?per_page=80&page=$page";

    http.Response response = await http.get(Uri.parse(url), headers: {
      'Authorization':
          'nEvqBxGR4E27nj7qBFCiEiPU8fdDSCJUJSjWiKOv6lZCF7szv3ngfssi'
    });
    final result = jsonDecode(response.body);
    setState(() {
      images.addAll(result['photos']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      body: Column(
        children: [
          Expanded(
              child: GridView.builder(
                  itemCount: images.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 2 / 3,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ClickWall(
                                imgUrl: images[index]['src']['large2x']),
                          ),
                        );
                      },
                      child: Container(
                          color: const Color.fromARGB(255, 101, 100, 100),
                          child: Image.network(
                            images[index]['src']['tiny'],
                            fit: BoxFit.cover,
                          )),
                    );
                  })),
          InkWell(
            onTap: () {
              loadMore();
            },
            child: Container(
                color: Theme.of(context).cardColor,
                height: 60,
                width: double.infinity,
                child: const Center(
                    child: Text(
                  "Load More...",
                  style: TextStyle(fontSize: 17),
                ))),
          )
        ],
      ),
    );
  }
}
