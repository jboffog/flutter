import 'package:flutter/material.dart';

enum ContentLineType { twoLines, threeLines }

class ContentPlaceholder extends StatelessWidget {
  final ContentLineType lineType;

  const ContentPlaceholder({super.key, required this.lineType});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(mainAxisSize: MainAxisSize.max, crossAxisAlignment: CrossAxisAlignment.center, children: [
          Container(
              width: 50.0,
              height: 50.0,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(40.0), color: Colors.white)),
          const SizedBox(width: 12.0),
          Expanded(
              child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
                width: MediaQuery.of(context).size.width * 0.40,
                height: 10.0,
                color: Colors.white,
                margin: const EdgeInsets.only(bottom: 8.0)),
            if (lineType == ContentLineType.threeLines)
              Container(
                  width: double.infinity,
                  height: 10.0,
                  color: Colors.white,
                  margin: const EdgeInsets.only(bottom: 8.0)),
            Container(width: MediaQuery.of(context).size.width * 0.20, height: 10.0, color: Colors.white)
          ]))
        ]));
  }
}
