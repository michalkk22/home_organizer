import 'package:flutter/material.dart';
import 'package:home_organizer/features/expenses/data/models/expenditure.dart';

class ExpenditureDetailsView extends StatelessWidget {
  const ExpenditureDetailsView({super.key, required this.expenditure});
  final Expenditure expenditure;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(expenditure.title)),
      body: Column(),
    );
  }
}
