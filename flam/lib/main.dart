import 'package:flutter/material.dart';
import 'package:book_my_seat/book_my_seat.dart';
import 'package:flutter/material.dart';
import 'package:stock_ui/http_service.dart';
import 'package:stock_ui/stock.dart';
import 'package:stock_ui/stock_list.dart';
import 'package:intl/intl.dart';


void main() {
  runApp(const BusApp());
}

class BusApp extends StatelessWidget {
  const BusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Hide debug banner
      title: 'book_my_seat Flam Ma3 app',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen, // Use light green as the primary color
        brightness: Brightness.dark, // Dark theme
      ),
      home: const BusApp(),
    );
  }
}

class BusApp extends StatefulWidget {
  const BusApp({Key? key}) : super(key: key);

  @override
  State<BusApp> createState() => _BusAppState();
}

class _BusAppState extends State<BusApp> {
  Set<SeatNumber> selectedSeats = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 16,
            ),
            const Text("Front of bus is this side"),
            const SizedBox(
              height: 32,
            ),
            Flexible(
              child: SizedBox(
                width: double.maxFinite,
                height: 500,
                child: SeatLayoutWidget(
                  onSeatStateChanged: (rowI, colI, seatState) {
                    if (seatState == SeatState.selected) {
                      selectedSeats.add(SeatNumber(rowI: rowI, colI: colI));
                    } else {
                      selectedSeats.remove(SeatNumber(rowI: rowI, colI: colI));
                    }
                  },
                  stateModel: const SeatLayoutStateModel(
                    rows: 10,
                    cols: 7,
                    seatSvgSize: 45,
                    pathSelectedSeat: 'assets/seat_selected.svg',
                    pathDisabledSeat: 'assets/seat_disabled.svg',
                    pathSoldSeat: 'assets/seat_sold.svg',
                    pathUnSelectedSeat: 'assets/seat_unselected.svg',
                    currentSeatsState: [
                      [
                        SeatState.disabled,
                        SeatState.unselected,
                        SeatState.unselected,
                        SeatState.empty,
                        SeatState.unselected,
                        SeatState.unselected,
                        SeatState.sold,
                      ],
                      [
                        SeatState.unselected,
                        SeatState.unselected,
                        SeatState.unselected,
                        SeatState.empty,
                        SeatState.unselected,
                        SeatState.unselected,
                        SeatState.unselected,
                      ],
                      [
                        SeatState.unselected,
                        SeatState.unselected,
                        SeatState.unselected,
                        SeatState.empty,
                        SeatState.sold,
                        SeatState.sold,
                        SeatState.sold,
                      ],
                      [
                        SeatState.unselected,
                        SeatState.unselected,
                        SeatState.unselected,
                        SeatState.empty,
                        SeatState.unselected,
                        SeatState.unselected,
                        SeatState.unselected,
                      ],
                      [
                        SeatState.unselected,
                        SeatState.unselected,
                        SeatState.unselected,
                        SeatState.empty,
                        SeatState.unselected,
                        SeatState.sold,
                        SeatState.sold,
                      ],
                      [
                        SeatState.sold,
                        SeatState.unselected,
                        SeatState.unselected,
                        SeatState.empty,
                        SeatState.unselected,
                        SeatState.unselected,
                        SeatState.unselected,
                      ],
                      [
                        SeatState.unselected,
                        SeatState.unselected,
                        SeatState.unselected,
                        SeatState.empty,
                        SeatState.unselected,
                        SeatState.unselected,
                        SeatState.unselected,
                      ],
                      [
                        SeatState.sold,
                        SeatState.sold,
                        SeatState.unselected,
                        SeatState.empty,
                        SeatState.unselected,
                        SeatState.unselected,
                        SeatState.unselected,
                      ],
                      [
                        SeatState.empty,
                        SeatState.empty,
                        SeatState.empty,
                        SeatState.empty,
                        SeatState.unselected,
                        SeatState.unselected,
                        SeatState.sold,
                      ],
                      [
                        SeatState.unselected,
                        SeatState.unselected,
                        SeatState.sold,
                        SeatState.sold,
                        SeatState.sold,
                        SeatState.unselected,
                        SeatState.unselected,
                      ],
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 15,
                        height: 15,
                        color: Colors.grey.shade700,
                      ),
                      const SizedBox(width: 2),
                      const Text('Disabled')
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 15,
                        height: 15,
                        color: Colors.lightBlueAccent,
                      ),
                      const SizedBox(width: 2),
                      const Text('Sold')
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(border: Border.all(color: const Color(0xff0FFF50))),
                      ),
                      const SizedBox(width: 2),
                      const Text('Available')
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 15,
                        height: 15,
                        color: const Color(0xff0FFF50),
                      ),
                      const SizedBox(width: 2),
                      const Text('Selected by you')
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {});
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith((states) => const Color(0xFFfc4c4e)),
              ),
              child: const Text('Show my selected seat numbers'),
            ),
            const SizedBox(height: 12),
            Text(selectedSeats.join(" , "))
          ],
        ),
      ),
    );
  }
}

class SeatNumber {
  final int rowI;
  final int colI;

  const SeatNumber({required this.rowI, required this.colI});

  @override
  bool operator ==(Object other) {
    return rowI == (other as SeatNumber).rowI && colI == other.colI;
  }

  @override
  int get hashCode => rowI.hashCode;

  @override
  String toString() {
    return '[$rowI][$colI]';
  }
}

class MyHomePage extends StatelessWidget {
  final title;
  HttpService httpService = HttpService();

  MyHomePage({this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: <Widget>[
      Container(
        padding: EdgeInsets.all(15),
        width: MediaQuery.of(context).size.width,
        color: Colors.black,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Text(
                      "Watch List",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      DateFormat('dd MMMM yyyy').format(DateTime.now()),
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    DateFormat().add_jm().format(DateTime.now()),
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: FutureBuilder(
                  future: httpService.getStocks(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Stock>> snapshot) {
                    if (snapshot.hasData) {
                      List<Stock> stocks = snapshot.data;
                      return SizedBox(
                          height: MediaQuery.of(context).size.height - 310,
                          child: StockList(
                            stocks: stocks,
                          ));
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              )
            ],
          ),
        ),
      )
    ]));
  }
}