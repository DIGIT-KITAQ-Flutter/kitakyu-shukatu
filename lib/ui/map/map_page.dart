import 'package:flutter/material.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

// マーカー情報を格納するクラス
class MarkerInfo {
  final LatLng position;
  final String title;
  final String description;

  MarkerInfo({
    required this.position,
    required this.title,
    required this.description,
  });
}

class _MapPageState extends State<MapPage> with TickerProviderStateMixin {
  // 定義済みマーカー情報リスト
  final List<MarkerInfo> markers = [
    MarkerInfo(
      position: const LatLng(35.170915, 136.881537),
      title: '名古屋城',
      description: '名古屋の中心にある歴史的なお城です。徳川家康により1612年に建てられました。',
    ),
    MarkerInfo(
      position: const LatLng(35.185944, 136.898911),
      title: '名古屋市科学館',
      description: 'プラネタリウムや実験などが楽しめる科学館です。',
    ),
    MarkerInfo(
      position: const LatLng(35.160751, 136.915744),
      title: 'オアシス21',
      description: '名古屋の栄にある複合施設です。水の宇宙船と呼ばれるガラス屋根が特徴的です。',
    ),
    MarkerInfo(
      position: const LatLng(35.133118, 136.899180),
      title: '熱田神宮',
      description: '名古屋の南部にある由緒ある神社です。草薙剣を御神体としています。',
    ),
  ];

  // MapControllerのインスタンス作成
  late final _animatedMapController = AnimatedMapController(vsync: this);

  // マーカー情報表示ダイアログ
  void _showMarkerInfo(MarkerInfo info) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(info.title),
            content: Text(info.description),
            actions: <Widget>[
              TextButton(
                child: const Text('閉じる'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
    );
  }

  // マーカーウィジェットを作成
  List<Marker> _buildMarkers() {
    List<Marker> allMarkers = [];

    // 定義済みのマーカー
    for (var info in markers) {
      allMarkers.add(
        Marker(
          width: 50.0,
          height: 50.0,
          point: info.position,
          child: GestureDetector(
            onTap: () {
              _showMarkerInfo(info);
              _animatedMapController.animateTo(dest: info.position, zoom: 15);
            },
            child: const Icon(Icons.location_on, color: Colors.red, size: 40),
          ),
        ),
      );
    }

    return allMarkers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('名古屋観光マップ'),
      ),
      body: FlutterMap(
        mapController: _animatedMapController.mapController,
        options: MapOptions(
          initialCenter: const LatLng(35.170915, 136.881537),
          initialZoom: 12.0,
          maxZoom: 18.0,
          minZoom: 3.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: const ['a', 'b', 'c'],
          ),
          MarkerLayer(markers: _buildMarkers()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.home),
        onPressed: () {
          // 名古屋市周辺を表示するように戻る
          _animatedMapController.animateTo(
            dest: const LatLng(35.170915, 136.881537),
            zoom: 12,
          );
        },
      ),
    );
  }
}
