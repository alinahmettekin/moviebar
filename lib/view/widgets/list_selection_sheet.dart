import 'package:flutter/material.dart';
import 'package:moviebar/core/models/watch_list.dart';

class ListSelectionSheet extends StatelessWidget {
  final List<WatchList> lists;
  final Function(int) onListSelected;

  const ListSelectionSheet({
    super.key,
    required this.lists,
    required this.onListSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 40,
          height: 4,
          margin: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey[700],
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Listeye Ekle',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        if (lists.isEmpty)
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Henüz liste oluşturmadınız',
              style: TextStyle(color: Colors.grey),
            ),
          )
        else
          Expanded(
            child: ListView.builder(
              itemCount: lists.length,
              itemBuilder: (context, index) {
                final list = lists[index];
                return ListTile(
                  title: Text(
                    list.name,
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    '${list.itemCount} içerik',
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                  onTap: () => onListSelected(list.id),
                );
              },
            ),
          ),
      ],
    );
  }
}
