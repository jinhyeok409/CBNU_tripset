import 'package:flutter/material.dart';

void main() {
  runApp(DetailPage());
}

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "글 제목!",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 35,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Text("글내용 !!!" * 5),
            ),
          )
        ],
      ),
    );
  }
}
