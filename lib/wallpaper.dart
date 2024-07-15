import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:wallpaper_app/fullscreen_img.dart';

class Wallpaper extends StatefulWidget {
  const Wallpaper({super.key});

  @override
  State<Wallpaper> createState() => _WallpaperState();
}

class _WallpaperState extends State<Wallpaper> {
  int page = 1;
  List images = [];
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    var response = await http.get(
      Uri.parse("https://api.pexels.com/v1/curated?per_page=80"),
      headers: {
        "Authorization":
            "oJMb6hW1mrdVsPH18U3qELRqnFPQL7HNBJOoVn4pSjQS9xhYbNzUvOnz"
      },
    );
    Map<String, dynamic> map = jsonDecode(response.body);
    setState(() {
      images = map['photos'];
    });
  }

  void loadMore() async {
    setState(() {
      page = page + 1;
    });
    String url = 'https://api.pexels.com/v1/curated?per_page=80&page=$page';
    var response = await http.get(
      Uri.parse(url),
      headers: {
        "Authorization":
            "oJMb6hW1mrdVsPH18U3qELRqnFPQL7HNBJOoVn4pSjQS9xhYbNzUvOnz"
      },
    );
    Map<String, dynamic> map = jsonDecode(response.body);
    List newImages = map['photos'];
    setState(() {
      images.addAll(newImages);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(2),
              // color: Colors.white,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: 2,
                  crossAxisCount: 3,
                  childAspectRatio: 2 / 3,
                  mainAxisSpacing: 2,
                ),
                itemCount: images.length,
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => FullscreenImg(
                            img: images[index]['src']['large2x'])));
                  },
                  child: Container(
                    color: Colors.white,
                    child: Image.network(
                      images[index]['src']['tiny'],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 60,
            width: double.infinity,
            child: InkWell(
              onTap: loadMore,
              child: const Center(
                child: Text(
                  'Load More',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
