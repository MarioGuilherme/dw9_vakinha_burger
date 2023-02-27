import "package:equatable/equatable.dart";
import "package:match/match.dart";

import "package:dw9_delivery_app/app/models/product_model.dart";
import "package:dw9_delivery_app/app/dto/order_product_dto.dart";

part "home_state.g.dart";

@match
enum HomeStateStatus {
  initial,
  loading,
  loaded,
  error
}

class HomeState extends Equatable {
  final HomeStateStatus status;
  final List<ProductModel> products;
  final String? errorMessage;
  final List<OrderProductDto> shoppingBag;

  const HomeState({
    required this.status,
    required this.products,
    required this.shoppingBag,
    this.errorMessage
  });

  const HomeState.initial()
    : this.status = HomeStateStatus.initial,
      this.products = const <ProductModel>[],
      this.shoppingBag = const <OrderProductDto>[],
      this.errorMessage = null;

  @override
  List<Object?> get props => <Object?>[this.status, this.products, this.errorMessage, this.shoppingBag];

  HomeState copyWith({
    HomeStateStatus? status,
    List<ProductModel>? products,
    String? errorMessage,
    List<OrderProductDto>? shoppingBag
  }) {
    return HomeState(
      status: status ?? this.status,
      products: products ?? this.products,
      errorMessage: errorMessage ?? this.errorMessage,
      shoppingBag: shoppingBag ?? this.shoppingBag
    );
  }
}