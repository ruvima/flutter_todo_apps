// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/blocs.dart';

class SearchAndFilterTodo extends StatelessWidget {
  const SearchAndFilterTodo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SearchTodo(),
        const SizedBox(height: 20),
        const _FilterTodo(),
      ],
    );
  }
}

class _SearchTodo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.search),
        label: Text('Search todo'),
        border: InputBorder.none,
        filled: true,
      ),
      onChanged: (String? newSearchTerm) {
        if (newSearchTerm != null) {
          context.read<TodoSearchBloc>().add(
                SetSearchTermEvent(newSearchTerm: newSearchTerm),
              );
        }
      },
    );
  }
}

class _FilterTodo extends StatelessWidget {
  const _FilterTodo();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _ItemButton(filter: Filter.all),
        _ItemButton(filter: Filter.active),
        _ItemButton(filter: Filter.completed),
      ],
    );
  }
}

class _ItemButton extends StatelessWidget {
  final Filter filter;
  const _ItemButton({
    Key? key,
    required this.filter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        context.read<TodoFilterBloc>().add(
              ChangeFilterEvent(newFilter: filter),
            );
      },
      child: Builder(
        builder: (context) {
          return Text(
            getActiveFilterText(filter, context),
            style: TextStyle(
              fontSize: 18,
              color: _getFilterTextColor(filter, context),
            ),
          );
        },
      ),
    );
  }

  String getActiveFilterText(Filter filter, BuildContext context) {
    return filter == Filter.all
        ? 'All'
        : filter == Filter.active
            ? 'Active'
            : 'Completed';
  }

  Color _getFilterTextColor(Filter filter, BuildContext context) {
    final activeFilter = context.watch<TodoFilterBloc>().state.filter;
    return activeFilter == filter ? Colors.deepPurpleAccent : Colors.grey;
  }
}
