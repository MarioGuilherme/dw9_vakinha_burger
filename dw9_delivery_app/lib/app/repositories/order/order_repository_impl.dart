import "dart:developer";
import "package:dio/dio.dart";

import "package:dw9_delivery_app/app/core/exceptions/repository_exception.dart";
import "package:dw9_delivery_app/app/core/rest_client/custom_dio.dart";
import "package:dw9_delivery_app/app/dto/order_dto.dart";
import "package:dw9_delivery_app/app/dto/order_product_dto.dart";
import "package:dw9_delivery_app/app/models/payment_type_model.dart";
import "package:dw9_delivery_app/app/repositories/order/order_repository.dart";

class OrderRepositoryImpl extends OrderRepository {
  final CustomDio dio;

  OrderRepositoryImpl({
    required this.dio
  });

  @override
  Future<List<PaymentTypeModel>> getAllPaymentsTypes() async {
    try {
      final Response<dynamic> result = await this.dio.auth().get("/payment-types");
      return result.data.map<PaymentTypeModel>((dynamic paymentType) => PaymentTypeModel.fromMap(paymentType)).toList();
    } on DioError catch (e, s) {
      log("Erro ao buscar formas de pagamentos", error: e, stackTrace: s);
      throw RepositoryException(message: "Erro ao buscar formas de pagamentos");
    }
  }

  @override
  Future<void> saveOrder(OrderDto order) async {
    try {
      await this.dio.auth().post("/orders", data: <String, Object>{
        "products": order.products.map((OrderProductDto product) => <String, num>{
          "id": product.product.id,
          "amount": product.amount,
          "total_price": product.totalPrice
        }).toList(),
        "user_id": "#userAuthRef", // <- obtem o codigo do usuário autenticado (do token)
        "address": order.address,
        "cpf": order.document,
        "payment_method_id": order.paymentMethodId
      });
    } on DioError catch (e, s) {
      log("Erro ao registrar pedido", error: e, stackTrace: s);
      throw RepositoryException(message: "Erro ao registrar pedido");
    }
  }
}