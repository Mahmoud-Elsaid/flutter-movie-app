import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/core/theme/colors.dart';
import 'package:movie_app/features/home/presentation/ui_home_screen/home_screen.dart';
import 'package:movie_app/features/search/controllers/cubit/search_cubit.dart';
import 'package:movie_app/features/search/presentation/search_screen.dart';
import 'package:movie_app/features/watchList/watchListScreen.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    BlocProvider(
      create: (_) => SearchCubit(),
      child: const SearchScreen(query: ""),
    ),
    const WatchListScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.numberscolor,
        currentIndex: selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: AppColors.hintcolor),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search, color: AppColors.hintcolor),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark, color: AppColors.hintcolor),
            label: 'Watch List',
          ),
        ],
      ),
    );
  }
}