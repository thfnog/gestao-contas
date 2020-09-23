import 'package:flutter/material.dart';
import 'package:flutter_web_dashboard/src/commons/theme.dart';
import 'package:flutter_web_dashboard/src/model/menu.dart';
import 'package:flutter_web_dashboard/src/widget/menu_item_tile.dart';
import 'package:intl/intl.dart';

class MonthPicker extends StatefulWidget {
  final Function function;

  const MonthPicker({Key key, this.function}) : super(key: key);

  @override
  _MonthPickerState createState() => _MonthPickerState();
}

class _MonthPickerState extends State<MonthPicker> {
  PageController pageController = PageController(initialPage: 2019);
  DateTime selectedDate;
  int displayedYear;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        actions: <Widget>[cancelarButton(), okButton()],
        title: Text(
          'Competência',
        ),
        content: Container(
            width: MediaQuery.of(context).size.width / 2.4,
            height: MediaQuery.of(context).size.height / 3.2,
            child: yearMonthPicker()));
  }

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    displayedYear = selectedDate.year;
  }

  yearMonthPicker() => Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Builder(builder: (context) {
            if (MediaQuery.of(context).orientation == Orientation.portrait) {
              return IntrinsicWidth(
                child: Column(children: [
                  buildHeader(),
                  Material(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [buildPager()],
                    ),
                  )
                ]),
              );
            }
            return IntrinsicHeight(
              child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    buildHeader(),
                    Material(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [buildPager()],
                      ),
                    )
                  ]),
            );
          }),
        ],
      );

  buildHeader() {
    return Material(
      color: Theme.of(context).primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('${DateFormat.yMMM().format(selectedDate)}'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('${DateFormat.y().format(DateTime(displayedYear))}',
                    style: TextStyle(color: Colors.white)),
                Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.keyboard_arrow_up, color: Colors.white),
                      onPressed: () => pageController.animateToPage(
                          displayedYear - 1,
                          duration: Duration(milliseconds: 400),
                          curve: Curves.easeInOut),
                    ),
                    IconButton(
                      icon:
                          Icon(Icons.keyboard_arrow_down, color: Colors.white),
                      onPressed: () => pageController.animateToPage(
                          displayedYear + 1,
                          duration: Duration(milliseconds: 400),
                          curve: Curves.easeInOut),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  buildPager() => Container(
        color: Colors.white,
        height: 210.0,
        width: 500.0,
        child: Theme(
            data: Theme.of(context).copyWith(
                buttonTheme: ButtonThemeData(
                    padding: EdgeInsets.all(0.0),
                    shape: CircleBorder(),
                    minWidth: 1.0)),
            child: PageView.builder(
              controller: pageController,
              scrollDirection: Axis.vertical,
              onPageChanged: (index) {
                setState(() {
                  displayedYear = index;
                });
              },
              itemBuilder: (context, year) {
                return GridView.count(
                  padding: EdgeInsets.all(12.0),
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 5,
                  children: List<int>.generate(12, (i) => i + 1)
                      .map((month) => DateTime(year, month))
                      .map(
                        (date) => Padding(
                          padding: EdgeInsets.all(4.0),
                          child: FlatButton(
                            onPressed: () => setState(() {
                              selectedDate = DateTime(date.year, date.month);
                            }),
                            color: date.month == selectedDate.month &&
                                    date.year == selectedDate.year
                                ? Colors.orange
                                : null,
                            textColor: date.month == selectedDate.month &&
                                    date.year == selectedDate.year
                                ? Colors.white
                                : date.month == DateTime.now().month &&
                                        date.year == DateTime.now().year
                                    ? Colors.orange
                                    : null,
                            child: Text(
                              DateFormat.MMM().format(date),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                );
              },
            )),
      );

  Container okButton() {
    return Container(
        height: 50,
        padding: EdgeInsets.all(5),
        child: RaisedButton(
            color: drawerBgColor,
            onPressed: () async {
              Navigator.pop(context);
              widget.function(selectedDate);
            },
            child: Text(
              'Ok',
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            )));
  }

  Container cancelarButton() {
    return Container(
        height: 50,
        padding: EdgeInsets.all(5),
        child: RaisedButton(
            color: drawerBgColor,
            onPressed: () async {
              Navigator.pop(context);
            },
            child: Text(
              'Cancel',
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            )));
  }
}
