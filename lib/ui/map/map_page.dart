import 'package:flutter/material.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:kitakyushu_shukatu/models/marker_info.dart';
import 'package:kitakyushu_shukatu/ui/map/map_page_view_model.dart';
import 'package:url_launcher/url_launcher.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> with TickerProviderStateMixin {
  final MapPageViewModel _viewModel = MapPageViewModel();
  late final _animatedMapController = AnimatedMapController(vsync: this);
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    await _viewModel.fetchMarkers();

    setState(() {
      _isLoading = false;
    });
  }

  // URLを開く関数
  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('URLを開けませんでした: $urlString')));
    }
  }

  // マーカー情報表示ダイアログ
  void _showMarkerInfo(MarkerInfo info) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Row(
              children: [
                if (info.imageUrl != null)
                  Container(
                    width: 40,
                    height: 40,
                    margin: const EdgeInsets.only(right: 10),
                    child: Image.network(
                      info.imageUrl!,
                      errorBuilder:
                          (context, error, stackTrace) =>
                              const Icon(Icons.business, size: 40),
                    ),
                  ),
                Expanded(child: Text(info.title)),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(info.description),
                  const SizedBox(height: 16),
                  if (info.websiteUrl != null)
                    TextButton.icon(
                      icon: const Icon(Icons.language),
                      label: const Text('企業サイトを見る'),
                      onPressed: () {
                        _launchUrl(info.websiteUrl!);
                      },
                    ),
                ],
              ),
            ),
            actions: <Widget>[
              if (info.documentId != null)
                TextButton(
                  child: const Text('詳細'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    // 詳細ページへ遷移する処理
                    // Navigator.of(context).push(MaterialPageRoute(
                    //   builder: (context) => CompanyDetailPage(companyId: info.documentId!),
                    // ));
                  },
                ),
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

    for (var info in _viewModel.markers) {
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
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Icon(Icons.location_on, color: Colors.red, size: 50),
                if (info.imageUrl != null)
                  Positioned(
                    bottom: 25,
                    child: Container(
                      width: 25,
                      height: 25,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.red, width: 1),
                      ),
                      child: ClipOval(
                        child: Image.network(
                          info.imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (context, error, stackTrace) =>
                                  const Icon(Icons.business, size: 20),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    }

    return allMarkers;
  }

  @override
  Widget build(BuildContext context) {
    // 初期表示位置（北九州市）
    final LatLng initialPosition = const LatLng(33.883379, 130.875049);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('北九州就活マップ'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadData),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _viewModel.errorMessage != null
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('エラー: ${_viewModel.errorMessage}'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadData,
                      child: const Text('再読み込み'),
                    ),
                  ],
                ),
              )
              : FlutterMap(
                mapController: _animatedMapController.mapController,
                options: MapOptions(
                  initialCenter: initialPosition,
                  initialZoom: 12.0,
                  maxZoom: 18.0,
                  minZoom: 3.0,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    subdomains: const ['a', 'b', 'c'],
                  ),
                  MarkerLayer(markers: _buildMarkers()),
                ],
              ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.home),
        onPressed: () {
          _animatedMapController.animateTo(dest: initialPosition, zoom: 12);
        },
      ),
    );
  }
}
