import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNav({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Color(0xffFFFFFF),
      type: BottomNavigationBarType.fixed, 
      currentIndex: currentIndex, 
      onTap: onTap,  
      selectedLabelStyle: const TextStyle(
        fontSize: 12,
        fontFamily: 'Pretendard'), 
      unselectedLabelStyle: const TextStyle(
        fontSize: 12,
        fontFamily: 'Pretendard'),  
      selectedItemColor: Color(0xffFFAD0A), 
      unselectedItemColor: Color(0xffD1D2D1), 

      items: [
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/icon/home.svg',
            colorFilter: ColorFilter.mode(
              currentIndex == 0 ? Color(0xffFFAD0A) : Color(0xffD1D2D1),
              BlendMode.srcIn,
            ),
            width: 24,  
            height: 24, 
          ),
          label: '홈',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/icon/badge.svg',
            colorFilter: ColorFilter.mode(
              currentIndex == 1 ? Color(0xffFFAD0A) : Color(0xffD1D2D1), 
              BlendMode.srcIn,
            ),
            width: 24,  
            height: 24, 
          ),
          label: '게시물',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/icon/ranking.svg',
            colorFilter: ColorFilter.mode(
              currentIndex == 2 ? Color(0xffFFAD0A) : Color(0xffD1D2D1), 
              BlendMode.srcIn,
            ),
            width: 24,  
            height: 24,
          ),
          label: '랭킹',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/icon/profile.svg',
            colorFilter: ColorFilter.mode(
              currentIndex == 3 ? Color(0xffFFAD0A) : Color(0xffD1D2D1), 
              BlendMode.srcIn,
            ),
            width: 24, 
            height: 24, 
          ),
          label: '마이페이지',
        ),
      ],
    );
  }
}
