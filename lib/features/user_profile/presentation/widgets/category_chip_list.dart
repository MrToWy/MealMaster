import 'package:flutter/material.dart';
import 'package:mealmaster/features/user_profile/domain/enum_label.dart';

//Custom Class for List of enums that implement the EnumLabel class
class CategoryChipList<T extends EnumLabel> extends StatefulWidget {
  final List<T> category;
  final String title;
  const CategoryChipList(
      {super.key, required this.title, required this.category});
  @override
  State<CategoryChipList> createState() => CategoryChipListState();
}

class CategoryChipListState<T extends EnumLabel>
    extends State<CategoryChipList> {
  Set<T> set = <T>{};

  List<Widget> categoryToList() {
    return widget.category
        .map<Widget>((T item) {
          return FilterChip(
              label: Text(item.label),
              selected: set.contains(item),
              onSelected: (bool selected) {
                setState(() {
                  if (selected) {
                    set.add(item);
                  } else {
                    set.remove(item);
                  }
                });
              });
        } as Widget Function(EnumLabel e))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(widget.title),
        Wrap(spacing: 5.0, children: categoryToList())
      ],
    );
  }
}
