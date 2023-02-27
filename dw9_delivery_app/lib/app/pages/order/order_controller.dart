import "dart:developer";
import "package:bloc/bloc.dart";

import "package:dw9_delivery_app/app/dto/order_dto.dart";
import "package:dw9_delivery_app/app/dto/order_product_dto.dart";
import "package:dw9_delivery_app/app/models/payment_type_model.dart";
import "package:dw9_delivery_app/app/pages/order/order_state.dart";
import "package:dw9_delivery_app/app/repositories/order/order_repository.dart";

class OrderController extends Cubit<OrderState> {
  final OrderRepository _orderRepository;

  OrderController(this._orderRepository) : super(const OrderState.initial());

  void load(List<OrderProductDto> products) async {
    try {
      this.emit(this.state.copyWith(status: OrderStatus.loading));
      final List<PaymentTypeModel> paymentsTypes = await this._orderRepository.getAllPaymentsTypes();
      this.emit(this.state.copyWith(
        status: OrderStatus.loaded,
        orderProducts: products,
        paymentsTypes: paymentsTypes
      ));
    } catch (e, s) {
      log("Erro ao carregar página", error: e, stackTrace: s);
      this.emit(this.state.copyWith(status: OrderStatus.error, errorMessage: "Erro ao carregar página"));
    }
  }

  void incrementProduct(int index) {
    final List<OrderProductDto> orders = <OrderProductDto>[...this.state.orderProducts];
    final OrderProductDto order = orders[index];
    orders[index] = orders[index].copyWith(amount: order.amount + 1);
    this.emit(this.state.copyWith(orderProducts: orders, status: OrderStatus.updateOrder));
  }

  void decrementProduct(int index) {
    final List<OrderProductDto> orders = <OrderProductDto>[...this.state.orderProducts];
    final OrderProductDto order = orders[index];
    final int amount = order.amount;

    if (amount == 1) {
      if (state.status != OrderStatus.confirmRemoveProduct) {
        this.emit(OrderConfirmDeleteProductState(
          orderProduct: order,
          index: index,
          status: OrderStatus.confirmRemoveProduct,
          orderProducts: this.state.orderProducts,
          paymentsTypes: this.state.paymentsTypes,
          errorMessage: this.state.errorMessage
        ));
        return;
      } else
        orders.removeAt(index);
    } else
      orders[index] = order.copyWith(amount: order.amount - 1);

    if (orders.isEmpty) {
      this.emit(this.state.copyWith(status: OrderStatus.emptyBag));
      return;
    }

    this.emit(this.state.copyWith(orderProducts: orders, status: OrderStatus.updateOrder));
  }

  void cancelDeleteProcess() {
    this.emit(this.state.copyWith(status: OrderStatus.loaded));
  }

  emptyBag() {
    this.emit(this.state.copyWith(status: OrderStatus.emptyBag));
  }

  void saveOrder({
    required String address,
    required String document,
    required int paymentMethodId
  }) async {
    this.emit(this.state.copyWith(status: OrderStatus.loading));
    await this._orderRepository.saveOrder(
      OrderDto(
        products: this.state.orderProducts,
        address: address,
        document: document,
        paymentMethodId: paymentMethodId
      )
    );
    this.emit(this.state.copyWith(status: OrderStatus.success));
  }
}