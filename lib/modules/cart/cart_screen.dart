import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shop_app/models/cart_model.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/cubit/cubit.dart';
import 'package:shop_app/shared/cubit/states.dart';
import 'package:shop_app/shared/styles/colors.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppCubit cubit = AppCubit.get(context);
    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) => ConditionalBuilder(
              condition: cubit.cartModel!.data!.cartItems!.isEmpty,
              builder: (context) => Center(
                child: Container(
                  height: 200,
                  width: 200,
                  child: SvgPicture.asset('assets/images/empty_cart.svg'),
                ),
              ),
              fallback: (context) => ConditionalBuilder(
                  condition: state is! AppOnLoadingFavoritesState,
                  builder: (context) => Column(
                        children: [
                          Expanded(
                            child: ListView.separated(
                              itemBuilder: (context, index) => BuildCartItem(
                                cubit.cartModel!.data!.cartItems![index],
                                context,
                              ),
                              separatorBuilder: (context, index) => SizedBox(
                                height: 5.0,
                              ),
                              itemCount:
                                  cubit.cartModel!.data!.cartItems!.length,
                            ),
                          ),
                          Container(
                            color: kMainColor.withOpacity(0.1),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'SubTotal',
                                        style: TextStyle(fontSize: 24.0),
                                      ),
                                      Spacer(),
                                      Text(
                                        '${cubit.cartModel!.data!.subTotal}',
                                        style: TextStyle(fontSize: 24.0),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'Shipping',
                                        style: TextStyle(fontSize: 24.0),
                                      ),
                                      Spacer(),
                                      Text(
                                        '0',
                                        style: TextStyle(fontSize: 24.0),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'Total',
                                        style: TextStyle(fontSize: 24.0),
                                      ),
                                      Spacer(),
                                      Text(
                                        '${cubit.cartModel!.data!.subTotal}',
                                        style: TextStyle(fontSize: 24.0),
                                      ),
                                    ],
                                  ),
                                  defaultButton(
                                    onPressed: () {},
                                    text: 'Proceed To Checkout',
                                    radius: 30.0,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                  fallback: (context) =>
                      Center(child: CircularProgressIndicator())),
            ));
  }

  Widget BuildCartItem(
    CartItemsModel model,
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
                  height: 150.0,
                  width: 150.0,
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
                height: 150.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        '${model.product!.name}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Text(
                            '${model.product!.price}',
                            style: TextStyle(
                              fontSize: 16.0,
                              color: kMainColor,
                            ),
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          // if (model.product!.discount! > 0)
                          Text(
                            '${model.product!.oldPrice}',
                            style: TextStyle(
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          RoundIconButton(
                              icon: Icons.remove,
                              onPressed: () {},
                              color: kMainColor,
                              iconColor: Colors.white),
                          SizedBox(
                            width: 5.0,
                          ),
                          Text(
                            '${model.quantity}',
                            style: TextStyle(
                              fontSize: 25.0,
                            ),
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          RoundIconButton(
                              icon: Icons.add,
                              onPressed: () {},
                              color: kMainColor,
                              iconColor: Colors.white),
                          Spacer(),
                          CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.red,
                            child: IconButton(
                              onPressed: () {
                                AppCubit.get(context)
                                    .changeCart(model.product!.id);
                              },
                              icon: Icon(
                                Icons.delete_outline,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
}
