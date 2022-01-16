import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/main_layout.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/components/constants.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class RegisterScreen extends StatelessWidget {
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var phoneController = TextEditingController();
  bool inVisiblePassword = true;
  final formGlobalKey = GlobalKey<FormState>();

  bool isPasswordValid(String password) => password.length >= 4;

  bool isEmailValid(String email) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern.toString());
    return regex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterStates>(
        listener: (BuildContext context, state) {
          if (state is RegisterOnSuccessState) {
            if (state.loginModel.status == true) {
              print(state.loginModel.data?.token);

              CacheHelper.saveData(
                      key: 'token', value: state.loginModel.data?.token)
                  .then((value) {
                token = '${state.loginModel.data?.token}';
                navigateTo(
                  context: context,
                  newRoute: MainLayout(),
                  backRoute: false,
                );
              });
            } else {
              showToast(
                text: '${state.loginModel.message}',
                states: ToastStates.ERROR,
              );
            }
          }
        },
        builder: (BuildContext context, state) {
          RegisterCubit cubit = RegisterCubit.get(context);
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Form(
                    key: formGlobalKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Register',
                          style: Theme.of(context)
                              .textTheme
                              .headline3
                              ?.copyWith(color: Colors.black),
                        ),
                        Text(
                          'Register now to browse our hot offers',
                          style:
                              Theme.of(context).textTheme.subtitle1?.copyWith(
                                    color: Colors.grey,
                                  ),
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        defaultFormField(
                          controller: nameController,
                          type: TextInputType.name,
                          validate: (name) {
                            if (name!.isEmpty) return 'Enter a name';
                          },
                          prefix: Icons.person,
                          label: 'Name',
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        defaultFormField(
                          controller: emailController,
                          type: TextInputType.emailAddress,
                          validate: (email) {
                            if (!isEmailValid(email.toString()))
                              return 'Enter a valid email address';
                          },
                          prefix: Icons.email,
                          label: 'Email Address',
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        defaultFormField(
                          controller: passwordController,
                          type: TextInputType.visiblePassword,
                          validate: (password) {
                            if (!isPasswordValid(password.toString()))
                              return 'Enter a valid password';
                          },
                          prefix: Icons.lock,
                          label: 'Password',
                          isPassword: cubit.secured,
                          suffix: cubit.visibility,
                          suffixPressed: () {
                            cubit.changePasswordVisibility();
                          },
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        defaultFormField(
                          controller: phoneController,
                          type: TextInputType.phone,
                          validate: (phone) {
                            if (phone!.isEmpty) return 'Enter a phone';
                          },
                          prefix: Icons.phone,
                          label: 'Phone',
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        ConditionalBuilder(
                          condition: state is! RegisterOnLoadingState,
                          builder: (BuildContext context) => defaultButton(
                            onPressed: () {
                              if (formGlobalKey.currentState!.validate()) {
                                RegisterCubit.get(context).userRegister(
                                  name: nameController.text,
                                  email: emailController.text,
                                  password: passwordController.text,
                                  phone: phoneController.text,
                                );
                              }
                            },
                            text: 'Register',
                          ),
                          fallback: (BuildContext context) =>
                              Center(child: CircularProgressIndicator()),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
