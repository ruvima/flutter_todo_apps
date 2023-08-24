import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/cubits.dart';
import '../models/todo.dart';
import '../utils/debounce.dart';

class SearchAndFilterTodo extends StatelessWidget {
  SearchAndFilterTodo({Key? key}) : super(key: key);
  final debounce = Debounce(milliseconds: 1000);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          decoration: const InputDecoration(
            label: Text('Search todos...'),
            filled: true,
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: (String? newSearchTerm) {
            if (newSearchTerm != null) {
              debounce.run(
                () => context
                    .read<TodoSearchCubit>()
                    .setSearchTerm(newSearchTerm),
              );
            }
          },
        ),
        const SizedBox(height: 10.0),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FilterButton(filter: Filter.all),
            FilterButton(filter: Filter.active),
            FilterButton(filter: Filter.completed),
          ],
        ),
      ],
    );
  }

  // Widget filterButton(BuildContext context, Filter filter) {
  //   return TextButton(
  //     onPressed: () {
  //       context.read<TodoFilterCubit>().changeFilter(filter);
  //     },
  //     child: Text(
  //       filter == Filter.all
  //           ? 'All'
  //           : filter == Filter.active
  //               ? 'Active'
  //               : 'Completed',
  //       style: TextStyle(
  //         fontSize: 18,
  //         color: textColor(context, filter),
  //       ),
  //     ),
  //   );
  // }

  // Color textColor(BuildContext context, Filter filter) {
  //   final currentFilter = context.watch<TodoFilterCubit>().state.filter;
  //   return currentFilter == context.watch<TodoFilterCubit>().state.filter ? Colors.blue : Colors.grey;
  // }
}

class FilterButton extends StatelessWidget {
  final Filter filter;

  const FilterButton({super.key, required this.filter});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        context.read<TodoFilterCubit>().changeFilter(filter);
      },
      child: Text(
        filter == Filter.all
            ? 'All'
            : filter == Filter.active
                ? 'Active'
                : 'Completed',
        style: TextStyle(
          fontSize: 18,
          color: context.watch<TodoFilterCubit>().state.filter == filter
              ? Colors.blue
              : Colors.grey,
        ),
      ),
    );
  }
}
