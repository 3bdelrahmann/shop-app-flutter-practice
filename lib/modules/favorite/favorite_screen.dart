import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/cubit/cubit.dart';
import 'package:shop_app/shared/cubit/states.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppCubit cubit = AppCubit.get(context);
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) => ConditionalBuilder(
          condition: state is! AppOnLoadingFavoritesState &&
              cubit.favoritesModel != null,
          builder: (context) => ConditionalBuilder(
              condition: cubit.favoritesModel!.data!.data.isEmpty,
              builder: (context) => Center(
                    child: Container(
                      height: 200,
                      width: 200,
                      child:
                          SvgPicture.asset('assets/images/empty_favorite.svg'),
                    ),
                  ),
              fallback: (context) => ListView.separated(
                    itemBuilder: (context, index) => BuildFavoritesItem(
                        cubit.favoritesModel!.data!.data[index], context),
                    separatorBuilder: (context, index) => SizedBox(
                      height: 5.0,
                    ),
                    itemCount: cubit.favoritesModel!.data!.data.length,
                  )),
          fallback: (context) => Center(child: CircularProgressIndicator())),
    );
  }
}
