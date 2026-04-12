import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ridesharing/common/constant/assets.dart';
import 'package:ridesharing/common/theme.dart';
import 'package:ridesharing/feature/dashboard/favourite/favourite_widget.dart';
import 'package:ridesharing/feature/dashboard/homeScreen/home_page_widget.dart';
import 'package:ridesharing/feature/dashboard/offer/offer_widget.dart';
import 'package:ridesharing/feature/dashboard/profile/profile_widget.dart';
import 'package:ridesharing/feature/dashboard/wallet/wallet_widget.dart';
import 'package:ridesharing/feature/dashboard/fuel_widget.dart';
import 'package:ridesharing/feature/notifications/notifications_widget.dart';
import 'package:ridesharing/feature/trips/trips_widget.dart';

class DashboardWidget extends StatefulWidget {
  const DashboardWidget({super.key});

  @override
  State<DashboardWidget> createState() => _DashboardWidgetState();
}

class _DashboardWidgetState extends State<DashboardWidget> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List pages = [
    const HomePageWidget(),
    const FavouriteWidget(),
    const WalletWidget(),
    const OfferWidget(),
    const ProfileWidget(),
    const DashboardFuelWidget(),
    const NotificationsWidget(),
    const TripsWidget(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomTheme.lightColor,
      body: Padding(
        padding: const EdgeInsets.only(bottom: 50.0),
        child: Center(child: pages.elementAt(_selectedIndex)),
      ),
      bottomSheet: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: CustomTheme.lightColor,
        ),
        padding: const EdgeInsets.all(8),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          unselectedFontSize: 12,
          unselectedItemColor: CustomTheme.darkColor.withOpacity(0.7),
          showUnselectedLabels: true,
          selectedFontSize: 13,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                _selectedIndex == 0 ? Assets.houseFillIcon : Assets.houseIcon,
                color: _selectedIndex == 0
                    ? CustomTheme.appColor
                    : CustomTheme.darkColor.withOpacity(0.7),
                width: 30,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                _selectedIndex == 1 ? Assets.heartFillIcon : Assets.heartIcon,
                color: _selectedIndex == 1
                    ? CustomTheme.appColor
                    : CustomTheme.darkColor.withOpacity(0.7),
                width: 30,
              ),
              label: 'Favourite',
            ),
            const BottomNavigationBarItem(
              icon: SizedBox(width: 30, height: 30),
              label: 'Wallet',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                _selectedIndex == 3
                    ? Assets.discountFillIcon
                    : Assets.discountIcon,
                color: _selectedIndex == 3
                    ? CustomTheme.appColor
                    : CustomTheme.darkColor.withOpacity(0.7),
                width: 30,
              ),
              label: 'Offer',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                _selectedIndex == 4 ? Assets.userFillIcon : Assets.userIcon,
                color: _selectedIndex == 4
                    ? CustomTheme.appColor
                    : CustomTheme.darkColor.withOpacity(0.7),
                width: 30,
              ),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                _selectedIndex == 5 ? Assets.localFillIcon : Assets.localIcon,
                color: _selectedIndex == 5
                    ? CustomTheme.appColor
                    : CustomTheme.darkColor.withOpacity(0.7),
                width: 30,
              ),
              label: 'Fuel',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                _selectedIndex == 6
                    ? Icons.notifications_active
                    : Icons.notifications_none,
                color: _selectedIndex == 6
                    ? CustomTheme.appColor
                    : CustomTheme.darkColor.withOpacity(0.7),
              ),
              label: 'Notifications',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                _selectedIndex == 7
                    ? Icons.directions_car_filled
                    : Icons.directions_car,
                color: _selectedIndex == 7
                    ? CustomTheme.appColor
                    : CustomTheme.darkColor.withOpacity(0.7),
              ),
              label: 'Trips',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: Colors.green,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        margin: const EdgeInsets.only(top: 10),
        height: 64,
        width: 64,
        child: FloatingActionButton(
          backgroundColor: CustomTheme.appColor,
          elevation: 0,
          onPressed: () {
            setState(() {
              _selectedIndex = 2;
            });
          },
          child: SvgPicture.asset(
            Assets.walletIcon,
            color: CustomTheme.lightColor,
          ),
        ),
      ),
    );
  }
}
