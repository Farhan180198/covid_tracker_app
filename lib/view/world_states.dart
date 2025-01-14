import 'package:covid_tracker_app/Model/WorldStatesModel.dart';
import 'package:covid_tracker_app/Services/states_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pie_chart/pie_chart.dart';

import 'countries_list.dart';

class WorldStatesScreen extends StatefulWidget {
  const WorldStatesScreen({super.key});

  @override
  State<WorldStatesScreen> createState() => _WorldStatesScreenState();
}

class _WorldStatesScreenState extends State<WorldStatesScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(duration: const Duration(seconds: 03), vsync: this)
        ..repeat();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  final colorList = <Color>[
    const Color(0xff4285f4),
    const Color(0xff1aa260),
    const Color(0xffde5246),
  ];

  @override
  Widget build(BuildContext context) {
    StatesServices statesServices = StatesServices();
    return Scaffold(
      // appBar: AppBar(
      //   centerTitle: true,
      //   automaticallyImplyLeading: false,
      //   backgroundColor: Colors.blue,
      //   title: Text('Data Screen', style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w600),),
      // ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * .01,
              ),
              FutureBuilder(
                  future: statesServices.fetchworkedStatesRecord(),
                  builder: (context, AsyncSnapshot<WorldStatesModel> snapshot) {
                    if (!snapshot.hasData) {
                      return Expanded(
                          flex: 1,
                          child: SpinKitCircle(
                            color: Colors.white,
                            size: 50,
                            controller: _controller,
                          ));
                    } else {
                      return Column(
                        children: [
                          PieChart(
                            dataMap: {
                              "Total":
                                  double.parse(snapshot.data!.cases.toString()),
                              "Recovered": double.parse(
                                  snapshot.data!.recovered.toString()),
                              "Deaths": double.parse(
                                  snapshot.data!.deaths.toString()),
                            },
                            chartValuesOptions: const ChartValuesOptions(
                                showChartValuesInPercentage: true),
                            chartRadius:
                                MediaQuery.of(context).size.width / 3.2,
                            legendOptions: LegendOptions(
                                legendPosition: LegendPosition.left),
                            animationDuration: Duration(milliseconds: 1200),
                            chartType: ChartType.ring,
                            colorList: colorList,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical:
                                    MediaQuery.of(context).size.height * .06),
                            child: Card(
                              child: Column(
                                children: [
                                  ReuseableRow(
                                    title: 'Total',
                                    value: snapshot.data!.cases.toString(),
                                  ),
                                  ReuseableRow(
                                    title: 'Deaths',
                                    value: snapshot.data!.deaths.toString(),
                                  ),
                                  ReuseableRow(
                                    title: 'Recovered',
                                    value: snapshot.data!.recovered.toString(),
                                  ),
                                  ReuseableRow(
                                    title: 'Active',
                                    value: snapshot.data!.active.toString(),
                                  ),
                                  ReuseableRow(
                                    title: 'Critical',
                                    value: snapshot.data!.critical.toString(),
                                  ),
                                  // when i was runing this code it give me issue(bottom overflow issue) here,
                                  // and when i change safe area widget with singlechildScroll view then it returns black screen,
                                  // what the solution is ??
                                  // ReuseableRow( title: 'TodayDeaths', value: snapshot.data!.todayDeaths.toString(),),
                                  // ReuseableRow( title: 'TodayRecovered', value: snapshot.data!.todayRecovered.toString(),),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CountriesList()));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Color(0xff1aa260),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              height: 50,
                              width: 300,
                              child: Center(
                                child: Text(
                                  'Track Countries',
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          )
                        ],
                      );
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

class ReuseableRow extends StatelessWidget {
  String title, value;

  ReuseableRow({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(title),
              Text(value),
            ],
          ),
          SizedBox(
            height: 3,
          ),
          Divider(),
        ],
      ),
    );
  }
}
