// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/todo_filter/todo_filter_bloc.dart';
import '../blocs/todo_search/todo_search_bloc.dart';

class SearchAndFilter extends StatelessWidget {
  const SearchAndFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _SearchWidget(),
        SizedBox(height: 12),
        _FilteredRow(),
      ],
    );
  }
}

class _SearchWidget extends StatelessWidget {
  const _SearchWidget();

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: const InputDecoration(
        label: Text('Search todo'),
        prefixIcon: Icon(Icons.search),
        border: InputBorder.none,
        filled: true,
      ),
      onChanged: (String? searchTerm) {
        if (searchTerm != null) {
          context.read<TodoSearchBloc>().add(
                SetSearchEvent(searchTerm: searchTerm),
              );
        }
      },
    );
  }
}

class _FilteredRow extends StatelessWidget {
  const _FilteredRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        Filter.values.length,
        (index) => _FilteredButton(
          filter: Filter.values[index],
          onTap: () {
            context.read<TodoFilterBloc>().add(
                  ChangeFilterEvent(filter: Filter.values[index]),
                );
          },
          isActive: context.watch<TodoFilterBloc>().state.filter ==
              Filter.values[index],
        ),
      ),
    );
  }
}

class _FilteredButton extends StatelessWidget {
  final Filter filter;
  final VoidCallback onTap;
  final bool isActive;
  const _FilteredButton({
    required this.filter,
    required this.onTap,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: Text(
        filter == Filter.all
            ? 'All'
            : filter == Filter.active
                ? 'Active'
                : 'Completed',
        style: TextStyle(
          fontSize: 20,
          color: isActive ? Colors.deepPurpleAccent : Colors.grey,
        ),
      ),
    );
  }
}
