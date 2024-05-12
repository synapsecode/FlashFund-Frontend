import 'package:flutter/material.dart';
import 'package:frontend/components/labeltextfield.dart';
import 'package:frontend/components/standardbutton.dart';
import 'package:frontend/extensions/extensions.dart';
import 'package:intl/intl.dart';

class RoadshowModel {
  final int id;
  final String companyName;
  final String prospectusURL;
  double companyValuation;
  final double loanAmount;
  final String status;

  double get loanPercentageAgainstValuation {
    return companyValuation == 0 ? 0 : (loanAmount / companyValuation) * 100;
  }

  String get getValueOfEachShare {
    const MICROSHARE_COUNT = 1000000; //1 Million
    final ves = loanAmount / MICROSHARE_COUNT;
    return ves.toStringAsFixed(5);
  }

  int get numberOfShares => 1000000;

  RoadshowModel({
    required this.id,
    required this.companyName,
    required this.prospectusURL,
    required this.companyValuation,
    required this.loanAmount,
    required this.status,
  });
}

class CurrentRoadshowsPage extends StatefulWidget {
  const CurrentRoadshowsPage({super.key});

  @override
  State<CurrentRoadshowsPage> createState() => _CurrentRoadshowsPageState();
}

class _CurrentRoadshowsPageState extends State<CurrentRoadshowsPage> {
  List<RoadshowModel> roadshows = [
    RoadshowModel(
      id: 0,
      companyName: 'Acme Corp',
      prospectusURL: 'https://www.google.com',
      companyValuation: 4853858585,
      loanAmount: 240000,
      status: 'active',
    ),
    RoadshowModel(
      id: 1,
      companyName: 'Bagmane Group',
      prospectusURL: 'https://www.bagmane.com',
      companyValuation: 5999858585,
      loanAmount: 320000,
      status: 'active-negotiation',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Current Roadshows')
                .size(40)
                .weight(FontWeight.bold)
                .color(Colors.purple[200]!)
                .addBottomMargin(40),
            ...roadshows
                .map((x) => RoadshowWidget(
                      model: x,
                    ))
                .toList(),
          ],
        ).center(),
      ),
    );
  }
}

class RoadshowWidget extends StatefulWidget {
  final RoadshowModel model;
  const RoadshowWidget({super.key, required this.model});

  @override
  State<RoadshowWidget> createState() => _RoadshowWidgetState();
}

class _RoadshowWidgetState extends State<RoadshowWidget> {
  TextEditingController valuationC = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12),
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('${widget.model.companyName}').size(30),
              ElevatedButton(onPressed: () {}, child: Text('View Prospectus'))
                  .addLeftMargin(20),
              Expanded(child: Container()),
              LableTextField(
                      lableText: 'Estimated Valuation', controller: valuationC)
                  .limitSize(200),
              ElevatedButton(onPressed: () {}, child: Text('Submit Valuation'))
                  .addLeftMargin(20),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  "Proposed Valuation before next funding: ₹${NumberFormat('#,##,000').format(widget.model.companyValuation)}"),
              Text(
                  "Loan Amount: ₹${NumberFormat('#,##,000').format(widget.model.loanAmount)}"),
              Text("Status: ${widget.model.status}"),
            ],
          )
        ],
      ),
    ).addBottomMargin(10);
  }
}
