import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<DataItem> items = [
    DataItem(
      label: "Item 1",
      value: 35,
      color: Colors.yellow,
    ),
    DataItem(
      label: "Item 2",
      value: 30,
      color: Colors.blue,
    ),
    DataItem(
      label: "Item 3",
      value: 40,
      color: Colors.cyan,
    ),
    DataItem(
      label: "Item 4",
      value: 60,
      color: Colors.deepOrange,
    ),
    DataItem(
      label: "Item 5",
      value: 55,
      color: Colors.pink,
    ),
  ];

  double getTotal() {
    double total = 0;
    items.forEach((i) {
      total += i.value;
    });
    return total;
  }

  double getGreatest() {
    double value = 0;
    items.forEach((i) {
      if (value < i.value) value = i.value;
    });
    return value;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: GestureDetector(
          onPanUpdate: (DragUpdateDetails detail) {
            double width = MediaQuery.of(context).size.width;
            Offset localPosition = detail.localPosition;

            double dx = localPosition.dx;

            int currentBar = (width / dx).ceil();
            setState(() {
              items[currentBar].value += detail.delta.dy;
            });
            print(currentBar);
          },
          child: CustomPaint(
            size: Size(width, width),
            painter: BargraphPainter(
              items: items,
              greatestValue: getGreatest(),
            ),
          ),
        ),
      ),
    );
  }
}

class BargraphPainter extends CustomPainter {
  final List<DataItem> items;
  final double greatestValue;
  double margin = 10;

  BargraphPainter({
    this.items,
    this.greatestValue,
  });
  Paint painter = Paint()
    ..strokeCap = StrokeCap.round
    ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    int bars = items.length;
    double barWidth = size.width / bars;

    double startedAt = 0;
    items.forEach((item) {
      double height =
          (item.value / greatestValue) * size.height; // Calculate this
      canvas.drawRect(
        Rect.fromLTWH(
          startedAt + margin, //OK
          size.height, //OK
          barWidth - margin * 2, // OK
          -height, // OK
        ),
        painter..color = item.color,
      );

      TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: item.label,
          style: TextStyle(color: Colors.black),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter
        ..layout()
        ..paint(
          canvas,
          Offset(
            startedAt + textPainter.width / 2,
            size.height - textPainter.height - margin,
          ),
        );
      startedAt += barWidth;
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class PieChartPainter extends CustomPainter {
  final List<DataItem> items;
  final double totalValue;

  PieChartPainter({
    this.items,
    this.totalValue,
  });
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Colors.red;
    double startingDegree = -pi / 2;
    // Loop
    items.forEach((item) {
      double ratio = item.value / totalValue;
      double sweepAngle = ratio * (2 * pi);
      // drawArc
      canvas.drawArc(
        Rect.fromLTWH(
          0,
          0,
          size.width,
          size.height,
        ), // Rect that includes a circle
        startingDegree, // starting degree
        sweepAngle, // degree of the arc
        true,
        paint..color = item.color,
      );
      startingDegree += sweepAngle;
    });
  }

  /// How angle works
  /// pi => 180 degree
  /// pi/2 => 90 degree
  /// + value rotate clock wise
  /// - value rotate anti clock wise

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class DataItem {
  final String label;
  double value;
  final Color color;

  DataItem({
    this.label,
    this.value,
    this.color,
  });
}
