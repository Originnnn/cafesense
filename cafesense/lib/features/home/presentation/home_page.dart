import 'package:flutter/material.dart';
import "package:cafesense/core/widgets/custom_bottom_nav.dart";
import "package:cafesense/features/explore/presentation/explore_screen.dart";
import "package:cafesense/features/match/presentation/match_screen.dart";
import "package:cafesense/features/saved/presentation/saved_screen.dart";
import "package:cafesense/features/profile/presentation/user_profile_screen.dart";

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const ExploreScreen(),
    const MatchScreen(),
    const SavedScreen(),
    const MainAppScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // The selected tab's body
          IndexedStack(
            index: _currentIndex,
            children: _screens,
          ),

          // Reusable Bottom Navigation overlays the content
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: CustomBottomNav(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
