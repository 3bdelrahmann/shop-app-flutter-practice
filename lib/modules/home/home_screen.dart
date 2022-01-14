import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/categories_model.dart';
import 'package:shop_app/models/home_model.dart';
import 'package:shop_app/modules/categories/categories_screen.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/cubit/cubit.dart';
import 'package:shop_app/shared/cubit/states.dart';
import 'package:shop_app/shared/styles/colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit = AppCubit.get(context);
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) => ConditionalBuilder(
        condition: cubit.homeModel != null && cubit.categoriesModel != null,
        builder: (context) =>
            HomeBuilder(cubit.homeModel!, cubit.categoriesModel!, context),
        fallback: (context) => Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget HomeBuilder(
    HomeModel model,
    CategoriesModel categoriesModel,
    BuildContext context,
  ) =>
      SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10.0,
          ),
          child: Column(
            children: [
              CarouselSlider(
                items: model.data?.banners
                    ?.map(
                      (banner) => Image(
                        image: NetworkImage('${banner.image}'),
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    )
                    .toList(),
                options: CarouselOptions(
                  aspectRatio: 16 / 9,
                  viewportFraction: 1,
                  initialPage: 0,
                  enableInfiniteScroll: true,
                  reverse: false,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 3),
                  autoPlayAnimationDuration: Duration(seconds: 1),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                  scrollDirection: Axis.horizontal,
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Categories',
                          style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          navigateTo(
                            context: context,
                            newRoute: CategoriesScreen(),
                            backRoute: true,
                          );
                        },
                        icon: Icon(Icons.list),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    height: 100.0,
                    child: ListView.separated(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) =>
                          BuildCategoryItem(categoriesModel.data!.data[index]),
                      separatorBuilder: (context, index) => SizedBox(
                        width: 10.0,
                      ),
                      itemCount: categoriesModel.data!.data.length,
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    'New products',
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                color: Colors.grey[300],
                child: GridView.count(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 2.0,
                  crossAxisSpacing: 2.0,
                  childAspectRatio: 1 / 1.87,
                  children: List.generate(
                    model.data!.products!.length,
                    (index) => ProductsGridBuilder(
                        model.data!.products![index], context),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Widget BuildCategoryItem(DataModel model) => Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          Image(
            image: NetworkImage('${model.image}'),
            height: 100.0,
            width: 100.0,
            fit: BoxFit.cover,
          ),
          Container(
              color: Colors.black.withOpacity(0.8),
              width: 100,
              child: Text(
                '${model.name}',
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                ),
              )),
        ],
      );

  Widget ProductsGridBuilder(ProductModel model, BuildContext context) =>
      Container(
        color: Colors.white,
        child: Column(
          children: [
            Stack(
              alignment: AlignmentDirectional.bottomStart,
              children: [
                Image(
                  height: 200.0,
                  image: NetworkImage('${model.image}'),
                  width: double.infinity,
                ),
                if (model.discount > 0)
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
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Text(
                      '${model.name}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(height: 1.3),
                    ),
                    height: 35.0,
                  ),
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
                      SizedBox(
                        width: 5.0,
                      ),
                      if (model.discount > 0)
                        Text(
                          '${model.oldPrice.round()}',
                          style: TextStyle(
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      Spacer(),
                      IconButton(
                        padding: EdgeInsets.zero,
                        alignment: AlignmentDirectional.bottomEnd,
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
                  SizedBox(
                    height: 10.0,
                  ),
                  defaultButton(
                    onPressed: () {
                      AppCubit.get(context).changeCart(model.id!);
                    },
                    text: AppCubit.get(context).inCart[model.id]!
                        ? 'Remove From Cart'
                        : 'Add to Cart',
                    textSize: 12.0,
                    height: 40.0,
                    background: AppCubit.get(context).inCart[model.id]!
                        ? Colors.red
                        : kMainColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
