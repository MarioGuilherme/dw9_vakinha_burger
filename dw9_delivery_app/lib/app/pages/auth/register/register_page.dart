import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:validatorless/validatorless.dart";

import "package:dw9_delivery_app/app/core/ui/base_state/base_state.dart";
import "package:dw9_delivery_app/app/pages/auth/register/register_controller.dart";
import "package:dw9_delivery_app/app/pages/auth/register/register_state.dart";
import "package:dw9_delivery_app/app/core/ui/styles/text_styles.dart";
import "package:dw9_delivery_app/app/core/ui/widgets/delivery_app_bar.dart";
import "package:dw9_delivery_app/app/core/ui/widgets/delivery_button.dart";

class RegisterPage extends StatefulWidget {
  const RegisterPage({ super.key });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends BaseState<RegisterPage, RegisterController> {
  final GlobalKey<FormState>_formKey = GlobalKey<FormState>();
  final TextEditingController _nameEC = TextEditingController();
  final TextEditingController _emailEC = TextEditingController();
  final TextEditingController _passwordEC = TextEditingController();

  @override
  void dispose() {
    this._nameEC.dispose();
    this._emailEC.dispose();
    this._passwordEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterController, RegisterState>(
      listener: (BuildContext context, RegisterState state) {
        state.status.matchAny(
          any: () => this.hideLoader(),
          register: () => this.showLoader(),
          error: () {
            this.hideLoader();
            showError("Erro ao registrar o usuário!");
          },
          success: () {
            this.hideLoader();
            showSuccess("Cadastro realizado com sucesso!");
            Navigator.pop(context);
          }
        );
      },
      child: Scaffold(
        appBar: DeliveryAppBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: this._formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Cadastro", style: context.textStyles.textTitle),
                  Text("Preencha os campos abaixo para criar o seu cadastro.", style: context.textStyles.textMedium.copyWith(fontSize: 18)),
                  const SizedBox(height: 30),
                  TextFormField(
                    decoration: const InputDecoration(labelText: "Nome"),
                    controller: this._nameEC,
                    validator: Validatorless.required("Nome obrigatório")
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    decoration: const InputDecoration(labelText: "E-mail"),
                    controller: this._emailEC,
                    validator: Validatorless.multiple(<String? Function(String?)>[
                      Validatorless.required("E-mail obrigatório"),
                      Validatorless.email("E-mail inválido")
                    ])
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(labelText: "Senha"),
                    controller: this._passwordEC,
                    validator: Validatorless.multiple(<String? Function(String?)>[
                      Validatorless.required("Senha obrigatória"),
                      Validatorless.min(6, "A senha deve conter 6 caracteres")
                    ])
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(labelText: "Confirmar Senha"),
                    validator: Validatorless.multiple(<String? Function(String?)>[
                      Validatorless.required("Confirmação de senha é obrigatória"),
                      Validatorless.compare(this._passwordEC, "As senhas não coincidem")
                    ])
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: DeliveryButton(
                      label: "Cadastrar",
                      width: double.infinity,
                      onPressed: () {
                        final bool valid = this._formKey.currentState?.validate() ?? false;
                        if (valid) {
                          this.controller.register(
                            this._nameEC.text,
                            this._emailEC.text,
                            this._passwordEC.text
                          );
                        }
                      }
                    )
                  )
                ]
              )
            )
          )
        )
      )
    );
  }
}