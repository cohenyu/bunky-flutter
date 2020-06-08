import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class MyChart extends StatefulWidget {
  final Map<String, double> data;
  final bool isPercentage;

  MyChart({this.data, this.isPercentage});

  @override
  _MyChartState createState() => _MyChartState();
}

class _MyChartState extends State<MyChart> {

  @override
  Widget build(BuildContext context) {
    return PieChart(
      dataMap: widget.data,
      animationDuration: Duration(milliseconds: 0),
      chartLegendSpacing: 25.0,
      legendStyle: TextStyle(
          fontSize: 15.0,
          fontWeight: FontWeight.bold,
          color: Colors.black.withOpacity(0.8)
      ),
      chartRadius: MediaQuery.of(context).size.width / 3.0,
      showChartValuesInPercentage: this.widget.isPercentage,
      showChartValues: true,
      showChartValuesOutside: true,
      chartValueBackgroundColor: Colors.grey[200],
      colorList: [
        Colors.pink,
        Colors.lightBlue[200],
        Colors.lime[600],
        Colors.cyan,
        Colors.redAccent[200],
        Colors.amberAccent[700],
        Colors.indigo,
      ],
      showLegends: true,
      legendPosition: LegendPosition.right,
      decimalPlaces: 0,
      showChartValueLabel: true,
      initialAngle: 0,
      chartValueStyle: defaultChartValueStyle.copyWith(
          color: Colors.blueGrey[900].withOpacity(0.9),
          fontSize: 12.0,
      ),
      chartType: ChartType.disc,
    );
  }
}
