import 'package:exd_social_app/controllers/signin_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({Key? key}) : super(key: key);

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();


  
  
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return GetBuilder<SigninController>(
      init: SigninController(),
      initState: (_) {},
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: Text('SignIn Screen'),
          ),
          body: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(
                        left: width * 0.05, right: width * 0.05),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Email",
                                style: TextStyle(fontFamily: "Josefin Sans"),
                              ),
                            ]),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: _.emailController,
                          validator: _.validateEmail,
                          decoration: InputDecoration(
                              hintText: _.hintEmail.value,
                              hintStyle: TextStyle(fontFamily: "Josefin Sans")),
                        ),
                        SizedBox(
                          height: height * 0.02,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Password",
                                style: TextStyle(fontFamily: "Josefin Sans"),
                              ),
                            ]),
                        Obx(() => TextFormField(
                              keyboardType: TextInputType.phone,
                              obscureText: _.secure.value,
                              controller: _.passwordController,
                              validator: _.validatePassword,
                              decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                      onPressed: () {
                                        _.isSecure();
                                      },
                                      icon: _.secure.value
                                          ? Icon(
                                              CupertinoIcons.eye_slash,
                                              color: Color.fromARGB(
                                                  255, 46, 23, 15),
                                            )
                                          : Icon(
                                              CupertinoIcons.eye,
                                              color: Color.fromARGB(
                                                  255, 46, 23, 15),
                                            )),
                                  hintText: _.hintPass.value,
                                  hintStyle:
                                      TextStyle(fontFamily: "Josefin Sans")),
                            )),
                        SizedBox(
                          height: height * 0.05,
                        ),
                        GestureDetector(
                          onTap: () async {
                            if (_formKey.currentState!.validate()) {
                              _.onPressed();
                              Get.snackbar("", "message");
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Color.fromARGB(255, 176, 254, 236),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30))),
                            height: height * 0.09,
                            width: width * 0.3,
                            child: Container(
                              margin: EdgeInsets.only(bottom: height * 0.008),
                              child: Text(
                                textAlign: TextAlign.center,
                                "Signin..",
                                style: TextStyle(
                                    fontSize: 28, fontFamily: "Pacifico"),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              )),
        );
      },
    );
  }
}
