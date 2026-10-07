import 'package:flutter/material.dart';
import 'package:veer_gatha/widgets/app_background.dart';
import 'package:go_router/go_router.dart';
import 'package:veer_gatha/widgets/custom_card.dart';

class ErasGridScreen extends StatelessWidget {
  const ErasGridScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final eras = <Map<String, dynamic>>[
      {
        'text': 'Ancient India',
        'stories': '12 Stories',
        'img': 'assets/images/ancient.png',
        'cardColor': const Color.fromRGBO(255, 234, 205, 1),
        'borderColor': const Color.fromRGBO(227, 162, 59, 1),
        'comingSoon': true,
      },
      {
        'text': 'Medieval India',
        'stories': '18 Stories',
        'img': 'assets/images/medieval.png',
        'cardColor': const Color.fromRGBO(232, 241, 239, 1),
        'borderColor': const Color.fromRGBO(140, 227, 208, 1),
        'comingSoon': false,
      },
      {
        'text': 'Freedom Fighters',
        'stories': '24 Stories',
        'img': 'assets/images/freedom.png',
        'cardColor': const Color.fromRGBO(234, 244, 220, 1),
        'borderColor': const Color.fromRGBO(155, 175, 122, 1),
        'comingSoon': false,
      },
      {
        'text': 'Women of Valor',
        'stories': '10 Stories',
        'img': 'assets/images/women.png',
        'cardColor': const Color.fromRGBO(248, 236, 232, 1),
        'borderColor': const Color.fromRGBO(208, 170, 160, 1),
        'comingSoon': true,
      },
    ];

    return AppBackground(
      child: GridView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: eras.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          mainAxisExtent: 220,
        ),
        itemBuilder: (context, index) {
          final era = eras[index];
          return GestureDetector(
            onTap: era['comingSoon'] == true
                ? () => context.push(
                    '/coming-soon?title=${Uri.encodeComponent(era['text'] as String)}',
                  )
                : null,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: CustomCard(
                text: era['text'] as String,
                stories: era['stories'] as String,
                img: era['img'] as String,
                cardColor: era['cardColor'] as Color,
                borderColor: era['borderColor'] as Color,
              ),
            ),
          );
        },
      ),
    );
  }
}
