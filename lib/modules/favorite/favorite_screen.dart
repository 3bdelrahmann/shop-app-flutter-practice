import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shop_app/models/favorites_model.dart';
import 'package:shop_app/shared/cubit/cubit.dart';
import 'package:shop_app/shared/cubit/states.dart';
import 'package:shop_app/shared/styles/colors.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppCubit cubit = AppCubit.get(context);
    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) => ConditionalBuilder(
              condition: cubit.favoritesModel!.data!.data.isEmpty,
              builder: (context) => Center(
                child: Container(
                  height: 200,
                  width: 200,
                  child: SvgPicture.asset('assets/images/empty_favorite.svg'),
                ),
              ),
              fallback: (context) => ConditionalBuilder(
                  condition: state is! AppOnLoadingFavoritesState,
                  builder: (context) => ListView.separated(
                        itemBuilder: (context, index) => BuildFavoritesItem(
                            cubit.favoritesModel!.data!.data[index], context),
                        separatorBuilder: (context, index) => SizedBox(
                          height: 5.0,
                        ),
                        itemCount: cubit.favoritesModel!.data!.data.length,
                      ),
                  fallback: (context) =>
                      Center(child: CircularProgressIndicator())),
            ));
  }

  Widget BuildFavoritesItem(
    FavoritesData model,
    BuildContext context,
  ) =>
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Stack(
              alignment: AlignmentDirectional.bottomStart,
              children: [
                Image(
                  height: 120.0,
                  width: 120.0,
                  image: NetworkImage('${model.product!.image}'),
                ),
                if (model.product!.discount! > 0)
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 5.0),
                      color: Colors.red,
                      child: Text(
                        'DISCOUNT',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      )),
              ],
            ),
            Expanded(
              child: Container(
                height: 120,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${model.product!.name}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(height: 1.3),
                    ),
                    Spacer(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${model.product!.price.round()}',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: kMainColor,
                          ),
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        if (model.product!.discount! > 0)
                          Text(
                            '${model.product!.oldPrice.round()}',
                            style: TextStyle(
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        Spacer(),
                        IconButton(
                          onPressed: () {
                            AppCubit.get(context)
                                .changeFavorites(model.product!.id!);
                          },
                          icon: AppCubit.get(context)
                                  .favourites[model.product!.id]!
                              ? Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                )
                              : Icon(
                                  Icons.favorite_outline,
                                ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
}
