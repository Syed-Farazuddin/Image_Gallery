import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';

class FullscreenImg extends StatefulWidget {
  final String img;
  const FullscreenImg({super.key, required this.img});

  @override
  State<FullscreenImg> createState() => _FullscreenImgState();
}

class _FullscreenImgState extends State<FullscreenImg> {
  Future<void> setwallpaper() async {
    int location = WallpaperManager.HOME_SCREEN;

    var file = await DefaultCacheManager().getSingleFile(widget.img);

    await WallpaperManager.setWallpaperFromFile(file.path, location);
    // debugPrint(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Image.network(
              widget.img,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            height: 60,
            width: double.infinity,
            child: InkWell(
              onTap: setwallpaper,
              child: const Center(
                child: Text(
                  'Set as Wallpaper',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
