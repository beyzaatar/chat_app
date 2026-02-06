import 'package:chat_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({super.key});

  @override
  VerificationPageState createState() => VerificationPageState();
}

class VerificationPageState extends State<VerificationPage> {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Scaffold(
      backgroundColor: colors.scaffoldBackground,
      body: LogoWithTitle(
        title: 'Doğrulama',
        subText: "SMS Doğrulama kodu gönderildi",
        children: [
          const Text("+1 18577 11111"),
          SizedBox(height: MediaQuery.of(context).size.height * 0.04),
          // OTP Form
          const OtpForm(),
        ],
      ),
    );
  }
}

class OtpForm extends StatefulWidget {
  const OtpForm({super.key});

  @override
  OtpFormState createState() => OtpFormState();
}

class OtpFormState extends State<OtpForm> {
  final _formKey = GlobalKey<FormState>();
  final List<TextInputFormatter> otpTextInputFormatters = [
    FilteringTextInputFormatter.digitsOnly,
    LengthLimitingTextInputFormatter(1),
  ];
  late FocusNode _pin1Node;
  late FocusNode _pin2Node;
  late FocusNode _pin3Node;
  late FocusNode _pin4Node;

  @override
  void initState() {
    super.initState();
    _pin1Node = FocusNode();
    _pin2Node = FocusNode();
    _pin3Node = FocusNode();
    _pin4Node = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    _pin1Node.dispose();
    _pin2Node.dispose();
    _pin3Node.dispose();
    _pin4Node.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Form(
      key: _formKey,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: OtpTextFormField(
                  focusNode: _pin1Node,
                  onChanged: (value) {
                    if (value.length == 1) _pin2Node.requestFocus();
                  },
                  onSaved: (pin) {
                    // Save it
                  },
                  autofocus: true,
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: OtpTextFormField(
                  focusNode: _pin2Node,
                  onChanged: (value) {
                    if (value.length == 1) _pin3Node.requestFocus();
                  },
                  onSaved: (pin) {
                    // Save it
                  },
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: OtpTextFormField(
                  focusNode: _pin3Node,
                  onChanged: (value) {
                    if (value.length == 1) _pin4Node.requestFocus();
                  },
                  onSaved: (pin) {
                    // Save it
                  },
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: OtpTextFormField(
                  focusNode: _pin4Node,
                  onChanged: (value) {
                    if (value.length == 1) _pin4Node.unfocus();
                  },
                  onSaved: (pin) {
                    // Save it
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                // check your code
              }
              context.go('/change-password');
            },
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: colors.primaryButton,
              foregroundColor: colors.buttonText,
              minimumSize: const Size(double.infinity, 48),
              shape: const StadiumBorder(),
            ),
            child: const Text("Devam Et"),
          ),
        ],
      ),
    );
  }
}

const InputDecoration otpInputDecoration = InputDecoration(
  filled: false,
  border: UnderlineInputBorder(),
  hintText: "0",
);

class OtpTextFormField extends StatelessWidget {
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final FormFieldSetter<String>? onSaved;
  final bool autofocus;

  const OtpTextFormField({
    super.key,
    this.focusNode,
    this.onChanged,
    this.onSaved,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      focusNode: focusNode,
      onChanged: onChanged,
      onSaved: onSaved,
      autofocus: autofocus,
      obscureText: true,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(1),
      ],
      textAlign: TextAlign.center,
      keyboardType: TextInputType.number,
      style: Theme.of(context).textTheme.headlineSmall,
      decoration: otpInputDecoration,
    );
  }
}

class LogoWithTitle extends StatelessWidget {
  final String title, subText;
  final List<Widget> children;

  const LogoWithTitle({
    super.key,
    required this.title,
    this.subText = '',
    required this.children,
  });
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                SizedBox(height: constraints.maxHeight * 0.1),
                Image.asset(
                  'assets/images/daphne_color_icon.png',
                  width: 160,
                  height: 160,
                ),
                SizedBox(
                  height: constraints.maxHeight * 0.1,
                  width: double.infinity,
                ),
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    subText,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      height: 1.5,
                      color: Theme.of(
                        context,
                      ).textTheme.bodyLarge!.color!.withValues(alpha: 0.64),
                    ),
                  ),
                ),
                ...children,
              ],
            ),
          );
        },
      ),
    );
  }
}
