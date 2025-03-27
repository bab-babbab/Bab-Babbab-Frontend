// ranking.dart
import 'package:flutter/material.dart';

class RankingPage extends StatelessWidget {
  const RankingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF7F8F9),
      body: const _RankingMainContent(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        child: const Icon(Icons.add, color: Colors.white),
        elevation: 0,
        backgroundColor: Color(0xffFFAD0A),
        shape: CircleBorder(),
      ),
    );
  }
}

class _RankingMainContent extends StatelessWidget {
  const _RankingMainContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 33, top: 100, right: 33),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 322,
            height: 164,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(15)
              )
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 40, bottom: 16),
            child: Text(
              '이번 주 랭킹',
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 20
              ),
            ),
          )
          ,
          Column(
            children: [
              Container(
                width: 322,
                height: 75,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(15)
                  ) 
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
