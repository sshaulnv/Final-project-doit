import 'package:doit_app/shared/widgets/round_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import '../constants/constants.dart';

class ForgotPasswordDialog extends StatefulWidget {
  @override
  _ForgotPasswordDialogState createState() => _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends State<ForgotPasswordDialog> {
  TextEditingController textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Wrap(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Ink(
                  decoration: const ShapeDecoration(
                    shape: CircleBorder(),
                  ),
                  child: Icon(
                    Icons.password,
                    size: 70,
                  ),
                ),
                Text(
                  'Forgot Password?',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Please enter your email address',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: textEditingController,
                  style: kTextStyleTextFiled,
                  decoration: kTextFieldInputDecoration.copyWith(
                    prefixIcon: Icon(
                      Icons.email,
                      color: kColorBlueText,
                    ),
                    labelText: 'Email Address',
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                RoundIconButton(
                  icon: const Icon(
                    Icons.verified,
                    color: Colors.white,
                  ),
                  text: const Text(
                    'Done',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () async {
                    // Note that using a username and password for gmail only works if
                    // you have two-factor authentication enabled and created an App password.
                    // Search for "gmail app password 2fa"
                    // The alternative is to use oauth.
                    String username = 'doitappmail@gmail.com';
                    String password = 'Aa123456!';

                    final smtpServer = gmail(username, password);
                    // Use the SmtpServer class to configure an SMTP server:
                    // final smtpServer = SmtpServer('smtp.domain.com');
                    // See the named arguments of SmtpServer for further configuration
                    // options.

                    // Create our message.
                    final message = Message()
                      ..from = Address(username, 'Your name')
                      ..recipients.add('aneel01ammar@gmail.com')
                      ..ccRecipients.addAll([])
                      ..bccRecipients.addAll([])
                      ..subject =
                          'Test Dart Mailer library :: 😀 :: ${DateTime.now()}'
                      ..text =
                          'This is the plain text.\nThis is line 2 of the text part.'
                      ..html =
                          "<h1>Test</h1>\n<p>Hey! Here's some HTML content</p>";

                    try {
                      final sendReport = await send(message, smtpServer);
                      print('Message sent: ' + sendReport.toString());
                    } on MailerException catch (e) {
                      print('Message not sent.');
                      for (var p in e.problems) {
                        print('Problem: ${p.code}: ${p.msg}');
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
