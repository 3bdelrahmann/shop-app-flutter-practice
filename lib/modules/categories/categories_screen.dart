import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/categories_model.dart';
import 'package:shop_app/shared/cubit/cubit.dart';
import 'package:shop_app/shared/cubit/states.dart';
import 'package:shop_app/shared/styles/colors.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit = AppCubit.get(context);
    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) => Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: Text(
                  'Categories',
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              body: Container(
                color: kMainColor.withOpacity(0.1),
                child: ListView.separated(
                  itemBuilder: (context, index) => BuildCategoriesItem(
                      cubit.categoriesModel!.data!.data[index]),
                  separatorBuilder: (context, index) => SizedBox(
                    height: 5.0,
                  ),
                  itemCount: cubit.categoriesModel!.data!.data.length,
                ),
              ),
            ));
  }

  Widget BuildCategoriesItem(DataModel model) => Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Image(
                image: NetworkImage('${model.image}'),
                height: 100.0,
                width: 100.0,
                fit: BoxFit.cover,
              ),
              SizedBox(
                width: 15.0,
              ),
              Text(
                '${model.name}',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              IconButton(
                icon: Icon(Icons.arrow_forward_ios),
                onPressed: () {},
              ),
            ],
          ),
        ),
      );
}
