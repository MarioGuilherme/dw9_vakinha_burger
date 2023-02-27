import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:validatorless/validatorless.dart";

import "package:dw9_delivery_app/app/core/ui/base_state/base_state.dart";
import "package:dw9_delivery_app/app/core/ui/styles/text_styles.dart";
import "package:dw9_delivery_app/app/core/ui/widgets/delivery_app_bar.dart";
import "package:dw9_delivery_app/app/core/ui/widgets/delivery_button.dart";
import "package:dw9_delivery_app/app/pages/auth/login/login_controller.dart";
import "package:dw9_delivery_app/app/pages/auth/login/login_state.dart";

class LoginPage extends StatefulWidget {
  const LoginPage({ super.key });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends BaseState<LoginPage, LoginController> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailEC = TextEditingController();
  final TextEditingController _passwordEC = TextEditingController();

  @override
  void dispose() {
    this._emailEC.dispose();
    this._passwordEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginController, LoginState>(
      listener: (BuildContext context, LoginState state) {
        state.status.matchAny(
          any: () => this.hideLoader(),
          login: () => this.showLoader(),
          loginError: () {
            this.hideLoader();
            this.showError(state.errorMessage!);
          },
          error: () {
            this.hideLoader();
            this.showError(state.errorMessage!);
          },
          suceess: () {
            this.hideLoader();
            Navigator.pop(context, true);
          }
        );
      },
      child: Scaffold(
        appBar: DeliveryAppBar(),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: this._formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Login", style: context.textStyles.textTitle),
                      const SizedBox(height: 30),
                      TextFormField(
                        controller: this._emailEC,
                        decoration: const InputDecoration(labelText: "E-mail"),
                        validator: Validatorless.multiple(<String? Function(String?)>[
                          Validatorless.required("Email obrigatório"),
                          Validatorless.email("Email inválido")
                        ])
                      ),
                      const SizedBox(height: 30),
                      TextFormField(
                        controller: this._passwordEC,
                        obscureText: true,
                        decoration: const InputDecoration(labelText: "Senha"),
                        validator: Validatorless.multiple(<String? Function(String?)>[
                          Validatorless.required("Senha obrigatória")
                        ])
                      ),
                      const SizedBox(height: 50),
                      Center(
                        child: DeliveryButton(
                          label: "ENTRAR",
                          width: double.infinity,
                          onPressed: () {
                            final bool valid = this._formKey.currentState?.validate() ?? false;
                            if (valid)
                              this.controller.login(this._emailEC.text, this._passwordEC.text);
                          }
                        )
                      )
                    ]
                  )
                )
              )
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Não possui uma conta", style: context.textStyles.textBold),
                      TextButton(
                        onPressed: () => Navigator.of(context).pushNamed("/auth/register"),
                        child: Text(
                          "Cadastre-se",
                          style: context.textStyles.textBold.copyWith(color: Colors.blue)
                        )
                      )
                    ]
                  )
                )
              )
            )
          ]
        )
      )
    );
  }
}