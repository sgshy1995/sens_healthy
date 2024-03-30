import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:sens_healthy/components/toast.dart';
import 'gallery_photo_view_item.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../iconfont/icon_font.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';

class GalleryPhotoViewWrapper extends StatefulWidget {
  GalleryPhotoViewWrapper({
    super.key,
    this.loadingBuilder,
    this.backgroundDecoration,
    this.minScale,
    this.maxScale,
    this.initialIndex = 0,
    required this.galleryItems,
    this.scrollDirection = Axis.horizontal,
  }) : pageController = PageController(initialPage: initialIndex);

  final LoadingBuilder? loadingBuilder;
  final BoxDecoration? backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;
  final int initialIndex;
  final PageController pageController;
  final List<GalleryExampleItem> galleryItems;
  final Axis scrollDirection;

  @override
  State<StatefulWidget> createState() {
    return _GalleryPhotoViewWrapperState();
  }
}

class _GalleryPhotoViewWrapperState extends State<GalleryPhotoViewWrapper> {
  late int currentIndex = widget.initialIndex;

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  void downLoadImage(int index) async {
    var response = await Dio().get(widget.galleryItems[index].resource,
        options: Options(responseType: ResponseType.bytes));
    final result =
        await ImageGallerySaver.saveImage(Uint8List.fromList(response.data));
    if (result['isSuccess']) {
      showToast('保存成功');
    } else {
      showToast('保存失败，请重试');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context); // 返回上一页
        },
        child: Container(
          decoration: widget.backgroundDecoration,
          constraints: BoxConstraints.expand(
            height: MediaQuery.of(context).size.height,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              PhotoViewGallery.builder(
                scrollPhysics: const BouncingScrollPhysics(),
                builder: _buildItem,
                itemCount: widget.galleryItems.length,
                loadingBuilder: widget.loadingBuilder ??
                    (context, event) {
                      return const Center(
                        child: SizedBox(
                          width: 36,
                          height: 36,
                          child: CircularProgressIndicator(
                              color: Color.fromRGBO(255, 255, 255, 1),
                              strokeWidth: 2),
                        ),
                      );
                    },
                backgroundDecoration: widget.backgroundDecoration,
                pageController: widget.pageController,
                onPageChanged: onPageChanged,
                scrollDirection: widget.scrollDirection,
              ),
              Positioned(
                  top: MediaQuery.of(context).padding.top + 12,
                  child: Container(
                    width: 60,
                    height: 30,
                    decoration: const BoxDecoration(
                        color: Color.fromRGBO(0, 0, 0, 0.6),
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    child: Center(
                      child: Text(
                        "${currentIndex + 1} / ${widget.galleryItems.length}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                          decoration: null,
                        ),
                      ),
                    ),
                  )),
              Positioned(
                  bottom: MediaQuery.of(context).padding.bottom + 24,
                  right: 24,
                  child: widget.galleryItems[currentIndex].canBeDownloaded
                      ? InkWell(
                          onTap: () => downLoadImage(currentIndex),
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: const BoxDecoration(
                                color: Color.fromRGBO(0, 0, 0, 0.6),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12))),
                            child: Center(
                              child: IconFont(
                                IconNames.xiazai,
                                size: 32,
                                color: '#fff',
                              ),
                            ),
                          ),
                        )
                      : const SizedBox.shrink())
            ],
          ),
        ),
      ),
    );
  }

  PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {
    final GalleryExampleItem item = widget.galleryItems[index];
    return item.isSvg
        ? PhotoViewGalleryPageOptions.customChild(
            child: Container(
              width: 300,
              height: 300,
              child: SvgPicture.asset(
                item.resource,
                height: 200.0,
              ),
            ),
            childSize: const Size(300, 300),
            initialScale: PhotoViewComputedScale.contained,
            minScale: PhotoViewComputedScale.contained * (0.5 + index / 10),
            maxScale: PhotoViewComputedScale.covered * 4.1,
            heroAttributes: PhotoViewHeroAttributes(tag: item.id),
          )
        : item.imageType == 'network'
            ? PhotoViewGalleryPageOptions(
                imageProvider: CachedNetworkImageProvider(item.resource),
                initialScale: PhotoViewComputedScale.contained,
                minScale: PhotoViewComputedScale.contained * (0.5 + index / 10),
                maxScale: PhotoViewComputedScale.covered * 4.1,
                heroAttributes: PhotoViewHeroAttributes(tag: item.id),
              )
            : PhotoViewGalleryPageOptions(
                imageProvider: AssetImage(item.resource),
                initialScale: PhotoViewComputedScale.contained,
                minScale: PhotoViewComputedScale.contained * (0.5 + index / 10),
                maxScale: PhotoViewComputedScale.covered * 4.1,
                heroAttributes: PhotoViewHeroAttributes(tag: item.id),
              );
  }
}
