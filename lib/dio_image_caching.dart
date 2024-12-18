// các bước làm của dio.
// thêm package dio vào pubspec.yaml
// kiếm 1 api để call trên google  -> http://54.255.204.181:5212/swagger/index.html
// tạo model product
// tạo service call api -> ở đây chọn phương thức get.
// map service với product -> product fromJson
// show data product lên .

// các bước làm của cached_network_image.
// thêm package
// sử dụng product ở trên dio
// trong product có phàn imageProduct. Dùng luôn. khi map ra.
// sử dụng widget  cached_network_image cho việc hiển thị url image.
// chuyển qua màn hình khác. và quay lại, thấy hình ảnh ko bị load lại. Done ()>

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'connectivity_plus_infor_plus.dart';

class DioImageCaching extends StatefulWidget {
  const DioImageCaching({super.key});

  @override
  State<DioImageCaching> createState() => _DioImageCachingState();
}

class FishModel {
  int? id;
  String? productName;
  double? price;
  String? description;
  int? stockQuantity;
  bool? isVisible;
  String? createdAt;
  List<ProductImages>? productImages;

  FishModel(
      {this.id,
      this.productName,
      this.price,
      this.description,
      this.stockQuantity,
      this.isVisible,
      this.createdAt,
      this.productImages});

  FishModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productName = json['productName'];
    price = json['price'];
    description = json['description'];
    stockQuantity = json['stockQuantity'];
    isVisible = json['isVisible'];
    createdAt = json['createdAt'];
    if (json['productImages'] != null) {
      productImages = <ProductImages>[];
      json['productImages'].forEach((v) {
        productImages!.add(ProductImages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['productName'] = productName;
    data['price'] = price;
    data['description'] = description;
    data['stockQuantity'] = stockQuantity;
    data['isVisible'] = isVisible;
    data['createdAt'] = createdAt;
    if (productImages != null) {
      data['productImages'] = productImages!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductImages {
  int? id;
  String? imageUrl;
  int? productId;

  ProductImages({this.id, this.imageUrl, this.productId});

  ProductImages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    imageUrl = json['imageUrl'];
    productId = json['productId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['imageUrl'] = imageUrl;
    data['productId'] = productId;
    return data;
  }
}

// tạo service call api -> hàm lấy mấy con cá chà bặc từ đường link http://54.255.204.181:5212/swagger/index.html
Future<List<FishModel>> apiCallInHere({required String url}) async {
  Response response = await Dio().get(url); // bước này là call api
  // map js

  List<FishModel> fishes = [];
  if (response.statusCode! >= 200 && response.statusCode! <= 299) {
    // map data cho con cá chà bặc được kéo về. Từ json thành model!
    fishes =
        List<FishModel>.from(response.data.map((x) => FishModel.fromJson(x)));
  }

  return fishes;
}

class _DioImageCachingState extends State<DioImageCaching> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Text('Dio Image Caching'),
            TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const InfoScreen(),
                      ));
                },
                child: const Text('Qua màn hình thông tin ứng dụng')),
            Expanded(
                child: FutureBuilder<List<FishModel>>(
              // chỗ này gọi api để call.
              future: apiCallInHere(
                  url:
                      'http://54.255.204.181:5212/api/products?Page=1&PageSize=30'),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      String iamgging =
                          'http://54.255.204.181:5212${snapshot.data![index].productImages![0].imageUrl!}';
                      return Container(
                        height: 120,
                        width: 120,
                        margin: const EdgeInsets.all(12),
                        child: Column(
                          children: [
                            Text(snapshot.data![index].productName!),
                            // image cached network :v
                            SizedBox(
                              width: 100,
                              height: 100,
                              child: CachedNetworkImage(
                                imageUrl: iamgging,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                      // colorFilter: const ColorFilter.mode(
                                      //     Colors.red, BlendMode.colorBurn)
                                    ),
                                  ),
                                ),
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                            // Image.network(
                            //   iamgging,
                            //   width: 100,
                            //   height: 100,
                            //   fit: BoxFit.cover,
                            // ),
                          ],
                        ),
                      );
                    },
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ))
          ],
        ),
      ),
    );
  }
}
