import 'package:flutter/material.dart';
import 'package:google_place/google_place.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PlaceSearchScreen extends StatefulWidget {
  @override
  _PlaceSearchScreenState createState() => _PlaceSearchScreenState();
}

class _PlaceSearchScreenState extends State<PlaceSearchScreen> {
  late GooglePlace googlePlace;
  List<AutocompletePrediction> predictions = [];
  DetailsResult? selectedPlace;
  late GoogleMapController mapController;
  final TextEditingController _searchController = TextEditingController(); // TextEditingController 추가
  Set<Marker> _markers = {}; // 마커 세트 추가

  CameraPosition initialCameraPosition = CameraPosition(
    target: LatLng(36.6284, 127.4574), // 초기 위치 (현재 충북대로 설정)
    zoom: 15,
  );

  @override
  void initState() {
    super.initState();
    String google_api_key = dotenv.env["GOOGLE_API_KEY"]!;
    googlePlace = GooglePlace(google_api_key); // API KEY 대입
  }

  // 자동완성 함수
  void autoCompleteSearch(String value) async {
    var result = await googlePlace.autocomplete.get(value);
    if (result != null && result.predictions != null) {
      setState(() {
        predictions = result.predictions!;
      });
    } else {
      setState(() {
        predictions = [];
      });
    }
  }

  void getPlaceDetails(String placeId) async {
    var result = await googlePlace.details.get(placeId);
    if (result != null && result.result != null) {
      setState(() {
        selectedPlace = result.result!;
        moveToLocation(LatLng(selectedPlace!.geometry!.location!.lat!, selectedPlace!.geometry!.location!.lng!));
        // 선택된 장소가 있을 때 자동완성 리스트 초기화
        predictions = [];
        // 선택된 후 키보드 숨기기
        FocusScope.of(context).requestFocus(FocusNode());
        // 선택된 위치에 마커 추가
        _markers.clear(); // 기존 마커 삭제
        _markers.add(Marker(
          markerId: MarkerId('selected_place'),
          position: LatLng(selectedPlace!.geometry!.location!.lat!, selectedPlace!.geometry!.location!.lng!),
          infoWindow: InfoWindow(
            title: selectedPlace!.formattedAddress ?? '', // null일 경우 빈 문자열로 설정
          ),
        ));
        // 선택된 주소를 검색창 텍스트로 설정
        _searchController.text = selectedPlace!.formattedAddress ?? ''; // null일 경우 빈 문자열로 설정
      });
    }
  }



  void moveToLocation(LatLng location) {
    mapController.animateCamera(CameraUpdate.newLatLngZoom(location, 15));
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text("위치 선택"),
    ),
    body: Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              GoogleMap(
                initialCameraPosition: initialCameraPosition,
                onMapCreated: (GoogleMapController controller) {
                  mapController = controller;
                },
                markers: _markers,
              ),
              Column(
                children: [
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: "주소를 검색하세요.",
                        suffixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          autoCompleteSearch(value);
                        } else {
                          setState(() {
                            predictions = [];
                          });
                        }
                      },
                    ),
                  ),
                  if (predictions.isNotEmpty)
                    Expanded(
                      child: Container(
                        color: Colors.white,
                        child: ListView.builder(
                          itemCount: predictions.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(predictions[index].description!),
                              onTap: () {
                                getPlaceDetails(predictions[index].placeId!);
                              },
                            );
                          },
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
        if (selectedPlace != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context, selectedPlace);
              },
              child: Text("선택 완료"),
            ),
          ),
      ],
    ),
  );
}

}