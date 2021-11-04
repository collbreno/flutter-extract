import 'package:business/business.dart';
import 'package:flutter/material.dart';
import 'package:ui/common/tag_chip.dart';

class TagChipDemo extends StatelessWidget {
  TagChipDemo({Key? key}) : super(key: key);

  final tags = [
    Tag(
      id: 'a',
      color: Colors.purple,
      name: 'Crédito',
      icon: Icons.credit_card,
    ),
    Tag(
      id: 'b',
      color: Colors.green,
      name: 'Dinheiro',
    ),
    Tag(
      id: 'c',
      color: Colors.grey,
      name: 'Almoço',
    ),
    Tag(
      id: 'd',
      color: Colors.amber,
      name: 'Ouro',
      icon: Icons.star,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tag Chip'),
      ),
      // body: Center(
      //   child: TagChip(
      //     tag: tags[1],
      //   ),
      // ),
      body: Transform.scale(
        scale: 1,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: tags
                .map((e) => Padding(
                      padding: EdgeInsets.all(8),
                      child: TagChip.fromTag(
                        e,
                      ),
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }
}
