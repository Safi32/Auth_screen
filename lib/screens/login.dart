import 'package:auth_screen/screens/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final _firebase = FirebaseAuth.instance;

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final _formKey = GlobalKey<FormState>();
  var _enteredEmail = '';
  var _enteredPassword = '';

  void _submit() {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      _formKey.currentState!.save();

      try {
        final UserCredential = _firebase.signInWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);
        print(UserCredential);
      } on FirebaseAuthException catch (e) {
        if (e.code == "Email or password wrong") {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(e.message ?? "Login Failed")));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("LogIn"),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: SizedBox(
                width: 380,
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  textCapitalization: TextCapitalization.none,
                  decoration: const InputDecoration(
                    hintText: "Email Address",
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value!.trim().isEmpty || !value.trim().contains("@")) {
                      return "Please enter a valid email address";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _enteredEmail = value!;
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: 380,
              child: TextFormField(
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: "Password",
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value!.trim().length < 4) {
                    return "Password must contains atleast 4 characters";
                  }
                  return null;
                },
                onSaved: (value) {
                  _enteredPassword = value!;
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: _submit,
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.purple),
                  child: const Text(
                    "LogIn",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, SignUpScreen.routeName);
                  },
                  child: const Text(
                    "Create an Account",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
