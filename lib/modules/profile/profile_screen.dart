import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/user_model.dart';
import 'package:shop_app/modules/user_management/user_management_screen.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/components/constants.dart';
import 'package:shop_app/shared/cubit/cubit.dart';
import 'package:shop_app/shared/cubit/states.dart';
import 'package:shop_app/shared/styles/colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppCubit cubit = AppCubit.get(context);
    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) => ConditionalBuilder(
            condition: state is! AppOnLoadingProfileState &&
                cubit.profileModel!.data != null,
            builder: (context) =>
                ProfileBuilder(context, cubit.profileModel!.data!),
            fallback: (context) => Center(child: CircularProgressIndicator())));
  }
}

Widget ProfileBuilder(BuildContext context, UserModel model) => Container(
      color: kMainColor.withOpacity(0.1),
      child: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 90,
                        backgroundColor: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(5), // Border radius
                          child:
                              ClipOval(child: Image.network('${model.image}')),
                        ),
                      ),
                      Text(
                        '${model.name}',
                        style: TextStyle(fontSize: 24.0),
                      ),
                      Text(
                        'ID: ${model.id}',
                        style: TextStyle(fontSize: 12.0),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(30.0),
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(60),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(child: Icon(Icons.settings)),
                      title: Text('Settings'),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: CircleAvatar(child: Icon(Icons.credit_card)),
                      title: Text('Billing Details'),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: CircleAvatar(child: Icon(Icons.person_pin)),
                      title: Text('User Management'),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        navigateTo(
                            context: context,
                            newRoute: UserManagementScreen(
                              name: '${model.name}',
                              email: '${model.email}',
                              phone: '${model.phone}',
                            ),
                            backRoute: true);
                      },
                    ),
                    Container(
                      height: 1.0,
                      color: Colors.grey[400],
                      margin: EdgeInsets.symmetric(vertical: 10.0),
                    ),
                    ListTile(
                      leading: CircleAvatar(child: Icon(Icons.logout)),
                      title: Text('Log Out'),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        logout(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
