import "package:equatable/equatable.dart";
import "package:match/match.dart";

import "package:dw9_delivery_app/app/dto/order_product_dto.dart";
import "package:dw9_delivery_app/app/models/payment_type_model.dart";

part "order_state.g.dart";

@match
enum OrderStatus {
  initial,
  loading,
  loaded,
  error,
  updateOrder,
  confirmRemoveProduct,
  emptyBag,
  success
}

class OrderState extends Equatable {
  final OrderStatus status;
  final List<OrderProductDto> orderProducts;
  final List<PaymentTypeModel> paymentsTypes;
  final String? errorMessage;

  const OrderState({
    required this.status,
    required this.orderProducts,
    required this.paymentsTypes,
    this.errorMessage,
  });

  const OrderState.initial() :
    this.status = OrderStatus.initial,
    this.orderProducts = const <OrderProductDto>[],
    this.paymentsTypes = const <PaymentTypeModel>[],
    this.errorMessage = null;

  double get totalOrder => this.orderProducts.fold(0.0, (double previousValue, OrderProductDto element) => previousValue + element.totalPrice);

  @override
  List<Object?> get props => <Object?>[this.status, this.orderProducts, this.paymentsTypes, this.errorMessage];

  OrderState copyWith({
    OrderStatus? status,
    List<OrderProductDto>? orderProducts,
    List<PaymentTypeModel>? paymentsTypes,
    String? errorMessage
  }) {
    return OrderState(
      status: status ?? this.status,
      orderProducts: orderProducts ?? this.orderProducts,
      paymentsTypes: paymentsTypes ?? this.paymentsTypes,
      errorMessage: errorMessage ?? this.errorMessage
    );
  }
}

class OrderConfirmDeleteProductState extends OrderState {
  final OrderProductDto orderProduct;
  final int index;

  const OrderConfirmDeleteProductState({
    required this.orderProduct,
    required this.index,
    required super.status,
    required super.orderProducts,
    required super.paymentsTypes,
    super.errorMessage
  });
}