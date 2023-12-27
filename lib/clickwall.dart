import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';
import 'package:wallpers_app/toastmessage.dart';

class ClickWall extends StatefulWidget {
  const ClickWall({super.key, required this.imgUrl});

  final String imgUrl;

  @override
  State<ClickWall> createState() => _ClickWallState();
}

class _ClickWallState extends State<ClickWall> {
  Future<void> setWallpaper(int screen) async {
    int wallpaperLocation = screen;
    var filePath = await DefaultCacheManager().getSingleFile(widget.imgUrl);
    await WallpaperManager.setWallpaperFromFile(
        filePath.path, wallpaperLocation);
    // Util().toastMessage("Wallpaper set Successfuly");
    debugPrint("wallpaper set succesfully");
  }

  void _showModalSheet() {
    showModalBottomSheet(
        isDismissible: true,
        showDragHandle: true,
        context: context,
        builder: (builder) {
          return Container(
              decoration: BoxDecoration(color: Theme.of(context).canvasColor),
              height: 170.0,
              child: ListView(
                children: [
                  ListTile(
                      title: const Text("Set as Home Screen"),
                      onTap: () {
                        setWallpaper(WallpaperManager.HOME_SCREEN)
                            .then((value) {
                          Util()
                              .toastMessage("Set to Home Screen Successfuly!");
                          Navigator.pop(context);
                        });
                      }),
                  ListTile(
                      splashColor: Colors.white,
                      title: const Text("Set as Lock Screen"),
                      onTap: () {
                        setWallpaper(WallpaperManager.LOCK_SCREEN)
                            .then((value) {
                          Util()
                              .toastMessage("Set to Lock Screen Successfuly!");
                          Navigator.pop(context);
                        });
                      }),
                  ListTile(
                      title: const Text("Set as Both"),
                      onTap: () {
                        setWallpaper(WallpaperManager.BOTH_SCREEN)
                            .then((value) {
                          Util()
                              .toastMessage("Set to Both Screen Successfuly!");
                          Navigator.pop(context);
                        });
                      }),
                ],
              ));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 700,
            child: Center(
              child: Image.network(
                widget.imgUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          InkWell(
            onTap: () {
              _showModalSheet();
            },
            child: Container(
              height: 50,
              width: 300,
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).dividerColor),
                borderRadius: BorderRadius.circular(20),
                // color: const Color.fromARGB(255, 1, 38, 68)
              ),
              child: const Center(
                child: Text(
                  "Set Wallpaper",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
