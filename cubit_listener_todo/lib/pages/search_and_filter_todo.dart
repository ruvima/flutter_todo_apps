import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/cubits.dart';
import '../utils/debounce.dart';

class SearchAndFilterTodo extends StatelessWidget {
  SearchAndFilterTodo({super.key});
  final debounce = Debounce();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          decoration: const InputDecoration(
            label: Text('Search todo'),
            border: InputBorder.none,
            filled: true,
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: (String? newSearchTerm) {
            if (newSearchTerm != null) {
              debounce.run(
                () {
                  context.read<TodoSearchCubit>().setSearchTerm(newSearchTerm);
                },
              );
            }
          },
        ),
        const SizedBox(height: 10),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _FilterButton(filter: Filter.all),
            _FilterButton(filter: Filter.active),
            _FilterButton(filter: Filter.completed),
          ],
        ),
      ],
    );
  }
}

class _FilterButton extends StatelessWidget {
  final Filter filter;
  const _FilterButton({
    required this.filter,
  });

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
              ? Colors.deepPurpleAccent
              : Colors.grey,
        ),
      ),
    );
  }
}
