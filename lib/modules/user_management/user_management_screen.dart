import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/cubit/cubit.dart';
import 'package:shop_app/shared/cubit/states.dart';

class UserManagementScreen extends StatelessWidget {
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();

  final formGlobalKey = GlobalKey<FormState>();

  final String name;
  final String email;
  final String phone;

  UserManagementScreen(
      {required this.name, required this.email, required this.phone});

  bool isEmailValid(String email) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern.toString());
    return regex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    nameController.text = name;
    emailController.text = email;
    phoneController.text = phone;
    AppCubit cubit = AppCubit.get(context);
    return BlocConsumer<AppCubit, AppStates>(
      listener: (BuildContext context, state) {},
      builder: (BuildContext context, state) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text('User Management'),
            actions: [
              if (!cubit.nonEditableField)
                IconButton(
                  onPressed: () {
                    if (formGlobalKey.currentState!.validate()) {
                      cubit.updateProfileData(
                        name: nameController.text,
                        email: emailController.text,
                        phone: phoneController.text,
                      );
                      if (state is! AppOnLoadingUpdateState)
                        Navigator.pop(context);
                    }
                  },
                  icon: Icon(Icons.save_outlined),
                )
            ],
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Form(
                  key: formGlobalKey,
                  child: Column(
                    children: [
                      if (state is AppOnLoadingUpdateState)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: LinearProgressIndicator(),
                        ),
                      defaultFormField(
                        controller: nameController,
                        type: TextInputType.name,
                        validate: (name) {
                          if (name!.isEmpty) return 'Enter a name';
                        },
                        prefix: Icons.person,
                        label: 'Name',
                        readOnly: cubit.nonEditableField,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      defaultFormField(
                        controller: emailController,
                        type: TextInputType.emailAddress,
                        validate: (email) {
                          if (!isEmailValid(email.toString()))
                            return 'Enter a valid email address';
                        },
                        prefix: Icons.email,
                        label: 'Email',
                        readOnly: cubit.nonEditableField,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      defaultFormField(
                        controller: phoneController,
                        type: TextInputType.number,
                        validate: (phone) {
                          if (phone!.isEmpty) return 'Enter a phone';
                        },
                        prefix: Icons.phone,
                        label: 'Phone',
                        readOnly: cubit.nonEditableField,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      if (cubit.nonEditableField)
                        defaultButton(
                          onPressed: () {
                            cubit.changeUserManagementScreen();
                            showToast(
                              text: 'You can edit your data now',
                              states: ToastStates.GREY,
                            );
                          },
                          text: 'edit',
                        )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
