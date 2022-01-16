import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/search_model.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/cubit/cubit.dart';
import 'package:shop_app/shared/cubit/states.dart';
import 'package:shop_app/shared/styles/colors.dart';

class SearchScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    AppCubit cubit = AppCubit.get(context);
    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) => Scaffold(
              appBar: AppBar(),
              body: Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      defaultFormField(
                        controller: searchController,
                        type: TextInputType.text,
                        validate: (value) {},
                        onSubmit: (String text) {
                          cubit.search(text: text);
                        },
                        hint: 'Search',
                        prefix: Icons.search,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      if (state is AppOnLoadingSearchState)
                        LinearProgressIndicator(),
                      SizedBox(
                        height: 10.0,
                      ),
                      if (state is AppOnSuccessSearchState)
                        Expanded(
                          child: ListView.separated(
                            itemBuilder: (context, index) => BuildSearchItem(
                                cubit.searchModel!.data!.product![index],
                                context),
                            separatorBuilder: (context, index) => SizedBox(
                              height: 20.0,
                            ),
                            itemCount: cubit.searchModel!.data!.product!.length,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ));
  }

  Widget BuildSearchItem(Product model, BuildContext context) => Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Stack(
              alignment: AlignmentDirectional.bottomStart,
              children: [
                Image(
                  height: 120.0,
                  width: 120.0,
                  image: NetworkImage('${model.image}'),
                ),
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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  height: 120,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${model.name}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(height: 1.3),
                      ),
                      Spacer(),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${model.price.round()}',
                            style: TextStyle(
                              fontSize: 16.0,
                              color: kMainColor,
                            ),
                          ),
                          Spacer(),
                          IconButton(
                            onPressed: () {
                              AppCubit.get(context).changeCart(model.id!);
                            },
                            icon: AppCubit.get(context).inCart[model.id]!
                                ? Icon(
                                    Icons.remove_shopping_cart,
                                    color: Colors.red,
                                  )
                                : Icon(
                                    Icons.add_shopping_cart,
                                    color: Colors.green,
                                  ),
                          ),
                          IconButton(
                            onPressed: () {
                              AppCubit.get(context).changeFavorites(model.id!);
                            },
                            icon: AppCubit.get(context).favourites[model.id]!
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
            ),
          ],
        ),
      );
}
