import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_organizer/features/expenses/bloc/expenses_bloc.dart';
import 'package:home_organizer/features/expenses/data/models/expenditure.dart';
import 'package:home_organizer/features/expenses/data/models/expenditure_category.dart';
import 'package:home_organizer/features/home/bloc/home_bloc.dart';
import 'package:home_organizer/features/home/data/models/user.dart';
import 'package:home_organizer/utils/extensions/date_time_format.dart';
import 'package:home_organizer/utils/extensions/date_time_operations.dart';
import 'package:home_organizer/widgets/date_picker_button.dart';
import 'package:home_organizer/widgets/form_row.dart';

class ExpensesReportView extends StatefulWidget {
  const ExpensesReportView({super.key, required this.allExpenses});
  final List<Expenditure> allExpenses;

  @override
  State<ExpensesReportView> createState() => _ExpensesReportViewState();
}

class _ExpensesReportViewState extends State<ExpensesReportView> {
  final now = DateTime.now();
  late final ValueNotifier<DateTime> _fromDate;
  late final ValueNotifier<DateTime> _toDate;

  final groupByOptions = ['Categories', 'Users', 'Months'];
  late String groupByValue;

  late List<ExpenditureCategory> categories;
  late List<User> users;

  late BarChartData chartData;

  @override
  void initState() {
    super.initState();

    int year = now.year;
    int month = now.month;
    _fromDate = ValueNotifier(DateTime(year, month));
    if (month == 12) {
      year++;
      month = 0;
    }
    _toDate = ValueNotifier(DateTime(year, month + 1));

    _fromDate.addListener(() => _updateChart());
    _toDate.addListener(() => _updateChart());

    groupByValue = groupByOptions[0];

    categories = context.read<ExpensesBloc>().categories;
    users = context.read<HomeBloc>().home.members.keys.toList();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateChart();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(title: Text('Expenses report')),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DatePickerButton(controller: _fromDate),
                Text('to'),
                DatePickerButton(controller: _toDate),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () => _addMonth(-1),
                  icon: Icon(Icons.arrow_left),
                ),
                Text('month'),
                IconButton(
                  onPressed: () => _addMonth(1),
                  icon: Icon(Icons.arrow_right),
                ),
              ],
            ),
            FormRow(
              label: 'Group by',
              child: DropdownMenu<String>(
                initialSelection: groupByOptions[0],
                dropdownMenuEntries:
                    groupByOptions
                        .map(
                          (value) => DropdownMenuEntry<String>(
                            value: value,
                            label: value,
                          ),
                        )
                        .toList(),
                onSelected: (value) => _onGoupByChanged(value),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: SizedBox(
                width: width * 0.9,
                height: height * 0.5,
                child: BarChart(chartData),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onGoupByChanged(String? value) {
    if (value != null) {
      groupByValue = value;
      _updateChart();
    }
  }

  void _addMonth(int value) {
    _toDate.value = _toDate.value.addMonth(value: value);
    _fromDate.value = _toDate.value.addMonth(value: value);
    _updateChart();
  }

  void _updateChart() {
    _validateDates();

    final map = _getMap();
    List<String> keys = map.keys.toList();
    keys.sort((a, b) {
      for (var i = 0; i < a.length; i++) {
        if (a.codeUnits[i] != b.codeUnits[i]) {
          return b.codeUnits[i] - a.codeUnits[i];
        }
      }
      return 0;
    });

    final barGroups = _toBarGroups(map, keys);
    final avg = _averageY(barGroups);
    final titlesData = _titlesData(keys);

    setState(() {
      chartData = BarChartData(
        barGroups: barGroups,
        extraLinesData: ExtraLinesData(
          horizontalLines: [
            HorizontalLine(
              y: avg,
              strokeWidth: 1,
              dashArray: [8, 6],
              label: HorizontalLineLabel(
                show: true,
                alignment: Alignment.topRight,
                labelResolver: (_) => 'Avg: ${avg.toStringAsFixed(2)}',
              ),
            ),
          ],
        ),
        titlesData: titlesData,
        barTouchData: barTouchData,
        borderData: FlBorderData(
          border: Border(left: BorderSide(), bottom: BorderSide()),
        ),
        gridData: const FlGridData(show: false),
        alignment: BarChartAlignment.spaceAround,
      );
    });
  }

  void _validateDates() {
    if (_fromDate.value.isAfter(_toDate.value)) {
      _toDate.value = _fromDate.value.add(Duration(days: 30));
    }
  }

  Map<String, double> _getMap() {
    Iterable<Expenditure> expenses;
    final map = <String, double>{};
    switch (groupByValue) {
      case 'Months':
        expenses = widget.allExpenses.toList();
        for (final e in expenses) {
          final date = e.date.yearMonthFormat;
          map[date] = (map[date] ?? 0) + e.amount;
        }
        break;
      case 'Users':
        expenses = _expensesByDates();
        for (final e in expenses) {
          final userName = e.user?.name ?? 'deleted user';
          map[userName] = (map[userName] ?? 0) + e.amount;
        }
        break;
      case 'Categories':
        expenses = _expensesByDates();
        for (final e in expenses) {
          final category = e.category?.name ?? 'Other';
          map[category] = (map[category] ?? 0) + e.amount;
        }
        break;
    }
    return map;
  }

  Iterable<Expenditure> _expensesByDates() => widget.allExpenses.where(
    (expenditre) =>
        expenditre.date.isAfter(_fromDate.value) &&
        expenditre.date.isBefore(_toDate.value),
  );

  List<BarChartGroupData> _toBarGroups(
    Map<String, double> data,
    List<String> keys,
  ) =>
      data.entries.map((e) {
        return BarChartGroupData(
          x: keys.indexOf(e.key),
          barRods: [
            BarChartRodData(
              toY: e.value,
              width: 16,
              borderRadius: BorderRadius.zero,
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.secondary,
                  Theme.of(context).colorScheme.inversePrimary,
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ],
          showingTooltipIndicators: [0],
        );
      }).toList();

  double _averageY(List<BarChartGroupData> groups) {
    final values = groups.expand((g) => g.barRods).map((r) => r.toY).toList();

    return values.isEmpty ? 0 : values.reduce((a, b) => a + b) / values.length;
  }

  FlTitlesData _titlesData(List<String> keys) => FlTitlesData(
    show: true,
    bottomTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 30,
        getTitlesWidget:
            (value, meta) =>
                SideTitleWidget(meta: meta, child: Text(keys[value.toInt()])),
      ),
    ),
    leftTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 40,
        getTitlesWidget: _leftTitles,
      ),
    ),
    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
  );

  Widget _leftTitles(double value, TitleMeta meta) {
    if (value == meta.max) {
      return Container();
    }
    return SideTitleWidget(
      meta: meta,
      child: Text(
        meta.formattedValue,
        style: Theme.of(context).textTheme.labelSmall,
      ),
    );
  }

  BarTouchData get barTouchData => BarTouchData(
    enabled: false,
    touchTooltipData: BarTouchTooltipData(
      getTooltipColor: (group) => Colors.transparent,
      tooltipPadding: EdgeInsets.zero,
      tooltipMargin: 2,
      getTooltipItem: (
        BarChartGroupData group,
        int groupIndex,
        BarChartRodData rod,
        int rodIndex,
      ) {
        return BarTooltipItem(
          rod.toY.round().toString(),
          Theme.of(context).textTheme.labelMedium ??
              const TextStyle(fontWeight: FontWeight.bold),
        );
      },
    ),
  );
}
