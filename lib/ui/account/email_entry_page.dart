import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:vit_parking/ui/account/ott_verification_page.dart';
import 'package:vit_parking/ui/components/dynamic_fab.dart';

class EmailEntryPage extends StatefulWidget {
  const EmailEntryPage({super.key});

  @override
  State<EmailEntryPage> createState() => _EmailEntryPageState();
}

class _EmailEntryPageState extends State<EmailEntryPage> {
  final _passwordController1 = TextEditingController();
  final _passwordController2 = TextEditingController();

  final bool _emailIsValid = false;
  bool _password1Visible = false;
  bool _password2Visible = false;
  bool _password1InFocus = false;
  bool _password2InFocus = false;
  final bool _passwordIsValid = false;
  bool _passwordsMatch = false;

  String _email = "";
  String _password = "";
  String _cnfPassword = '';

  final _password1FocusNode = FocusNode();
  final _password2FocusNode = FocusNode();

  final Color _validFieldValueColor = const Color.fromRGBO(45, 194, 98, 0.2);
  final Color _checkIconColor = const Color.fromRGBO(45, 194, 98, 1.0);
  Color fillFaint = const Color.fromRGBO(0, 0, 0, 0.04);

  @override
  void initState() {
    _password1FocusNode.addListener(() {
      setState(() {
        _password1InFocus = _password1FocusNode.hasFocus;
      });
    });
    _password2FocusNode.addListener(() {
      setState(() {
        _password2InFocus = _password2FocusNode.hasFocus;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _password1FocusNode.dispose();
    _password2FocusNode.dispose();
    _passwordController1.dispose();
    _passwordController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isKeypadOpen = MediaQuery.of(context).viewInsets.bottom > 100;

    FloatingActionButtonLocation? fabLocation() {
      if (isKeypadOpen) {
        return null;
      } else {
        return FloatingActionButtonLocation.centerFloat;
      }
    }

    final appBar = AppBar(
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        color: Theme.of(context).iconTheme.color,
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      title: const Material(
        type: MaterialType.transparency,
        child: StepProgressIndicator(
          totalSteps: 2,
          currentStep: 1,
          selectedColor: Color.fromRGBO(45, 194, 98, 1.0),
          roundedEdges: Radius.circular(10),
          unselectedColor: Color.fromRGBO(196, 196, 196, 0.6),
        ),
      ),
    );
    return Scaffold(
      resizeToAvoidBottomInset: isKeypadOpen,
      appBar: appBar,
      body: _getBody(),
      floatingActionButton: DynamicFAB(
        isKeypadOpen: isKeypadOpen,
        isFormValid: true,
        buttonText: "Create account",
        onPressedFunction: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const OTTVerificationPage(),
            ),
          );
          FocusScope.of(context).unfocus();
        },
      ),
      floatingActionButtonLocation: fabLocation(),
      floatingActionButtonAnimator: NoScalingAnimation(),
    );
  }

  Widget _getBody() {
    return Column(
      children: [
        Expanded(
          child: AutofillGroup(
            child: ListView(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                  child: Text(
                    "Create new account",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: TextFormField(
                    style: Theme.of(context).textTheme.titleMedium,
                    autofillHints: const [AutofillHints.email],
                    decoration: InputDecoration(
                      fillColor:
                          _emailIsValid ? _validFieldValueColor : fillFaint,
                      filled: true,
                      hintText: "Email",
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      suffixIcon: _emailIsValid
                          ? Icon(
                              Icons.check,
                              size: 20,
                              color: Theme.of(context)
                                  .inputDecorationTheme
                                  .focusedBorder!
                                  .borderSide
                                  .color,
                            )
                          : null,
                    ),
                    onChanged: (value) {
                      setState(() {
                        _email = value.trim();
                      });
                      // if (_emailIsValid != EmailValidator.validate(_email!)) {
                      //   setState(() {
                      //     _emailIsValid = EmailValidator.validate(_email!);
                      //   });
                      // }
                    },
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    initialValue: _email,
                    textInputAction: TextInputAction.next,
                  ),
                ),
                const Padding(padding: EdgeInsets.all(4)),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    controller: _passwordController1,
                    obscureText: !_password1Visible,
                    enableSuggestions: true,
                    autofillHints: const [AutofillHints.newPassword],
                    decoration: InputDecoration(
                      fillColor:
                          _passwordIsValid ? _validFieldValueColor : fillFaint,
                      filled: true,
                      hintText: "Password",
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      suffixIcon: _password1InFocus
                          ? IconButton(
                              icon: Icon(
                                _password1Visible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Theme.of(context).iconTheme.color,
                                size: 20,
                              ),
                              onPressed: () {
                                setState(() {
                                  _password1Visible = !_password1Visible;
                                });
                              },
                            )
                          : _passwordIsValid
                              ? Icon(
                                  Icons.check,
                                  color: _checkIconColor,
                                )
                              : null,
                      border: UnderlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    focusNode: _password1FocusNode,
                    // Use to check for password
                    onChanged: (password) {
                      if (password != _password) {
                        setState(() {
                          _password = password;
                          _passwordsMatch = _password == _cnfPassword;
                        });
                      }
                    },
                    onEditingComplete: () {
                      _password1FocusNode.unfocus();
                      _password2FocusNode.requestFocus();
                      TextInput.finishAutofillContext();
                    },
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    controller: _passwordController2,
                    obscureText: !_password2Visible,
                    autofillHints: const [AutofillHints.newPassword],
                    onEditingComplete: () => TextInput.finishAutofillContext(),
                    decoration: InputDecoration(
                      fillColor: _passwordsMatch && _passwordIsValid
                          ? _validFieldValueColor
                          : fillFaint,
                      filled: true,
                      hintText: "Confirm Password",
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      suffixIcon: _password2InFocus
                          ? IconButton(
                              icon: Icon(
                                _password2Visible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Theme.of(context).iconTheme.color,
                                size: 20,
                              ),
                              onPressed: () {
                                setState(() {
                                  _password2Visible = !_password2Visible;
                                });
                              },
                            )
                          : _passwordsMatch
                              ? Icon(
                                  Icons.check,
                                  color: _checkIconColor,
                                )
                              : null,
                      border: UnderlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    focusNode: _password2FocusNode,
                    onChanged: (cnfPassword) {
                      setState(() {
                        _cnfPassword = cnfPassword;
                        if (_password != '') {
                          _passwordsMatch = _password == _cnfPassword;
                        }
                      });
                    },
                  ),
                ),
                // Opacity(
                //   opacity: (_password != '') && _password1InFocus ? 1 : 0,
                //   child: Padding(
                //     padding:
                //         const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                //     child: Text(
                //       context.l10n.passwordStrength(passwordStrengthText),
                //       style: TextStyle(
                //         color: passwordStrengthColor,
                //         fontWeight: FontWeight.w500,
                //         fontSize: 12,
                //       ),
                //     ),
                //   ),
                // ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
