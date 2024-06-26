import 'package:flutter/material.dart';
import 'package:frontend/backend/auth.dart';
import 'package:frontend/backend/roadshow.dart';
import 'package:frontend/backend/wallet.dart';
import 'package:frontend/components/labeltextfield.dart';
import 'package:frontend/components/standardbutton.dart';
import 'package:frontend/extensions/extensions.dart';
import 'package:frontend/main.dart';
import 'package:frontend/screens/investor/currentroadshows.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class IPOMarketplacePage extends StatefulWidget {
  const IPOMarketplacePage({super.key});

  @override
  State<IPOMarketplacePage> createState() => _IPOMarketplacePageState();
}

class _IPOMarketplacePageState extends State<IPOMarketplacePage> {
  List<RoadshowModel> ipos = [];

  @override
  void initState() {
    RoadshowBackend.getAllIPOs().then((x) {
      if (x == null) return print('NULLLLLL');
      setState(() {
        ipos = [...x];
        setState(() {});
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Current IPOS')
                .size(40)
                .weight(FontWeight.bold)
                .color(Colors.purple[200]!)
                .addBottomMargin(40),
            ...ipos
                .map((x) => IPOWidget(
                      model: x,
                    ))
                .toList(),
          ],
        ).center(),
      ),
    );
  }
}

class IPOWidget extends StatefulWidget {
  final RoadshowModel model;
  const IPOWidget({super.key, required this.model});

  @override
  State<IPOWidget> createState() => _IPOWidgetState();
}

class _IPOWidgetState extends State<IPOWidget> {
  TextEditingController unitsC = TextEditingController();

  @override
  void initState() {
    unitsC.addListener(() {
      final double units = double.tryParse(unitsC.value.text) ?? 0;
      if (units > widget.model.numberOfShares) {
        print('exceeded!');
        unitsC.text = widget.model.numberOfShares.toString();
      }
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double units = double.tryParse(unitsC.value.text) ?? 0;

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
              LableTextField(lableText: 'Number of units', controller: unitsC)
                  .limitSize(200)
                  .addRightMargin(10),
              Text(
                  "Price: ₹${NumberFormat('#,##,###').format(units * double.parse(widget.model.getValueOfEachShare))}"),
              ElevatedButton(
                      onPressed: () async {
                        final amount = (units *
                                double.parse(widget.model.getValueOfEachShare))
                            .toInt();

                        final id = gpc.read(investorUserIDProvider)!;
                        final success = await VirtualWallet.withdraw(
                          type: 'investor',
                          amount: amount,
                          id: id,
                        );
                        if (success) {
                          //todo: call the buy share route

                          final succ = await RoadshowBackend.placeOrder(
                            businessID: widget.model.businessID,
                            units: units.toInt(),
                          );
                          if (succ) {
                            print('MOGGGGGEDDDDDD');
                            context.pop();
                          } else {
                            print('UUUUUUUUUUUU');
                          }
                        }
                      },
                      child: Text('Place Order'))
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
              Text("Value Per Share: ${widget.model.getValueOfEachShare}"),
              Text("Status: ${widget.model.status}"),
              Text("Shares Left: ${widget.model.sharesLeft}"),
            ],
          )
        ],
      ),
    ).addBottomMargin(10);
  }
}
