import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/modules/search/search_screen.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/cubit/cubit.dart';
import 'package:shop_app/shared/cubit/states.dart';

class MainLayout extends StatelessWidget {
  const MainLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit = AppCubit.get(context);
    return BlocConsumer<AppCubit, AppStates>(
      listener: (BuildContext context, state) {},
      builder: (BuildContext context, state) => Scaffold(
        appBar: AppBar(
          title: Text(
            'Shop App',
          ),
          actions: [
            IconButton(
              onPressed: () {
                navigateTo(
                    context: context,
                    newRoute: SearchScreen(),
                    backRoute: true);
              },
              icon: Icon(Icons.search),
            ),
          ],
        ),
        body: cubit.bottomScreens[cubit.currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: cubit.currentIndex,
          onTap: (index) {
            cubit.changeNavBar(index);
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Favorites',
            ),
            BottomNavigationBarItem(
              icon: cartIcon(context),
              label: 'Cart',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  Widget cartIcon(BuildContext context) => Stack(
        alignment: AlignmentDirectional.topEnd,
        children: [
          Icon(Icons.shopping_cart),
          CircleAvatar(
            child: Text(
              '${AppCubit.get(context).cartLength}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 6,
              ),
            ),
            radius: 6,
            backgroundColor: Colors.red,
          ),
        ],
      );
}
