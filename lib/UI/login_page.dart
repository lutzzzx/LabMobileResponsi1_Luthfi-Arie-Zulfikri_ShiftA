import 'package:flutter/material.dart';
import '../bloc/login_bloc.dart';
import '../helpers/user_info.dart';
import '../widget/warning_dialog.dart';
import 'registrasi_page.dart';
import 'mental_health_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final _emailTextboxController = TextEditingController();
  final _passwordTextboxController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Login',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Arial',
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Hai, selamat datang kembali!',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Arial',
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 40),
              _emailTextField(),
              const SizedBox(height: 20),
              _passwordTextField(),
              const SizedBox(height: 30),
              _buttonLogin(),
              const SizedBox(height: 30),
              _menuRegistrasi(),
            ],
          ),
        ),
      ),
    );
  }

  // Membuat Textbox email
  Widget _emailTextField() {
    return TextFormField(
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.pink[50],
        hintText: 'Masukkan Email',
        prefixIcon: const Icon(Icons.email, color: Colors.red),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide.none,
        ),
      ),
      keyboardType: TextInputType.emailAddress,
      controller: _emailTextboxController,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Email harus diisi';
        }
        return null;
      },
    );
  }

  // Membuat Textbox password
  Widget _passwordTextField() {
    return TextFormField(
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.pink[50],
        hintText: 'Masukkan Password',
        prefixIcon: const Icon(Icons.lock, color: Colors.red),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide.none,
        ),
      ),
      obscureText: true,
      controller: _passwordTextboxController,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Password harus diisi';
        }
        return null;
      },
    );
  }

  // Membuat Tombol Login
  Widget _buttonLogin() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ).copyWith(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.hovered)) {
              return Colors.red[800];
            }
            return Colors.red;
          }),
        ),
        child: const Text(
          'Login',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontFamily: 'Arial',
          ),
        ),
        onPressed: () {
          var validate = _formKey.currentState!.validate();
          if (validate) {
            if (!_isLoading) _submit();
          }
        },
      ),
    );
  }

  void _submit() {
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    LoginBloc.login(
      email: _emailTextboxController.text,
      password: _passwordTextboxController.text,
    ).then((value) async {
      if (value.code == 200) {
        await UserInfo().setToken(value.token!);
        await UserInfo().setUserID(value.userID!);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MentalHealthPage()),
        );
      } else {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => const WarningDialog(
            description: 'Login gagal, silahkan coba lagi',
          ),
        );
      }
    }).whenComplete(() {
      setState(() {
        _isLoading = false;
      });
    });
  }

  // Membuat menu untuk membuka halaman registrasi
  Widget _menuRegistrasi() {
    return Center(
      child: InkWell(
        child: const Text(
          'Belum mempunyai akun? Registrasi',
          style: TextStyle(color: Colors.red),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RegistrasiPage()),
          );
        },
      ),
    );
  }
}
