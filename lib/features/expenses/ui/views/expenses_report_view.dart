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
import 'package:home_organizer/widgets/form_row.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class ExpensesReportView extends StatefulWidget {
  const ExpensesReportView({super.key, required this.allExpenses});
  final List<Expenditure> allExpenses;

  @override
  State<ExpensesReportView> createState() => _ExpensesReportViewState();
}

class _ExpensesReportViewState extends State<ExpensesReportView> {
  late DateTime date;

  final groupByOptions = ['Categories', 'Users', 'Months'];
  late String groupByValue;

  late List<ExpenditureCategory> categories;
  late List<User> users;
  late Iterable<Expenditure> expenses;

  late Map<String, double> map;
  late double avg;
  late double total;
  late BarChartData chartData;

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();
    date = DateTime(now.year, now.month);

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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () => _addMonth(-1),
                    icon: Icon(Icons.arrow_left),
                  ),
                  TextButton(
                    onPressed: _pickMonth,
                    child: Text(date.yearMonthFormat),
                  ),
                  IconButton(
                    onPressed: () => _addMonth(1),
                    icon: Icon(Icons.arrow_right),
                  ),
                ],
              ),
              Text('Total this period: $total'),
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
              SizedBox(height: 30),
              if (groupByValue == 'Users')
                Text('Average per user: ${avg.toStringAsFixed(2)}'),
              if (groupByValue == 'Users')
                DataTable(
                  columns: const [
                    DataColumn(label: Text('User')),
                    DataColumn(label: Text('Expenses')),
                    DataColumn(label: Text('Balance')),
                  ],
                  rows:
                      map.entries
                          .map(
                            (entry) => DataRow(
                              cells: [
                                DataCell(Text(entry.key)),
                                DataCell(Text('${entry.value}')),
                                DataCell(
                                  Text((avg - entry.value).toStringAsFixed(2)),
                                ),
                              ],
                            ),
                          )
                          .toList(),
                ),
            ],
          ),
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

  Future<void> _pickMonth() async {
    date =
        await showMonthPicker(
          context: context,
          initialDate: date,
          firstDate: DateTime(2020),
          lastDate: DateTime.now().add(Duration(days: 356)),
        ) ??
        date;
    _updateChart();
  }

  void _addMonth(int value) {
    date = date.addMonth(value: value);
    _updateChart();
  }

  void _updateChart() {
    _getMapAndTotal();
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
    avg = _averageY(barGroups);
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

  _getMapAndTotal() {
    total = 0;
    map = <String, double>{};
    switch (groupByValue) {
      case 'Months':
        expenses = widget.allExpenses.toList();
        for (final e in expenses) {
          total += e.amount;
          final date = e.date.yearMonthFormat;
          map[date] = (map[date] ?? 0) + e.amount;
        }
        break;
      case 'Users':
        expenses = _expensesByDates();
        for (final e in expenses) {
          total += e.amount;
          final userName = e.user?.name ?? 'deleted user';
          map[userName] = (map[userName] ?? 0) + e.amount;
        }
        break;
      case 'Categories':
        expenses = _expensesByDates();
        for (final e in expenses) {
          total += e.amount;
          final category = e.category?.name ?? 'Other';
          map[category] = (map[category] ?? 0) + e.amount;
        }
        break;
    }
  }

  Iterable<Expenditure> _expensesByDates() => widget.allExpenses.where(
    (expenditre) => expenditre.date.isBetween(date, date.addMonth()),
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
