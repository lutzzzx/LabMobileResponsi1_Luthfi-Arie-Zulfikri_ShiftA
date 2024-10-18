import 'package:flutter/material.dart';
import '../bloc/registrasi_bloc.dart';
import '../widget/success_dialog.dart';
import '../widget/warning_dialog.dart';

class RegistrasiPage extends StatefulWidget {
  const RegistrasiPage({Key? key}) : super(key: key);

  @override
  _RegistrasiPageState createState() => _RegistrasiPageState();
}

class _RegistrasiPageState extends State<RegistrasiPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final _namaTextboxController = TextEditingController();
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
                'Registrasi',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Arial',
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Buat akun baru Anda',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Arial',
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 40),
              _namaTextField(),
              const SizedBox(height: 20),
              _emailTextField(),
              const SizedBox(height: 20),
              _passwordTextField(),
              const SizedBox(height: 20),
              _passwordKonfirmasiTextField(),
              const SizedBox(height: 30),
              _buttonRegistrasi(),
            ],
          ),
        ),
      ),
    );
  }

  // Membuat Textbox Nama
  Widget _namaTextField() {
    return TextFormField(
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.pink[50],
        hintText: 'Masukkan Nama',
        prefixIcon: const Icon(Icons.person, color: Colors.red),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide.none,
        ),
      ),
      keyboardType: TextInputType.text,
      controller: _namaTextboxController,
      validator: (value) {
        if (value!.length < 3) {
          return "Nama harus diisi minimal 3 karakter";
        }
        return null;
      },
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
        Pattern pattern =
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
        RegExp regex = RegExp(pattern.toString());
        if (!regex.hasMatch(value)) {
          return "Email tidak valid";
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
      keyboardType: TextInputType.text,
      obscureText: true,
      controller: _passwordTextboxController,
      validator: (value) {
        if (value!.length < 6) {
          return "Password harus diisi minimal 6 karakter";
        }
        return null;
      },
    );
  }

  // Membuat textbox Konfirmasi Password
  Widget _passwordKonfirmasiTextField() {
    return TextFormField(
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.pink[50],
        hintText: 'Konfirmasi Password',
        prefixIcon: const Icon(Icons.lock_outline, color: Colors.red),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide.none,
        ),
      ),
      keyboardType: TextInputType.text,
      obscureText: true,
      validator: (value) {
        if (value != _passwordTextboxController.text) {
          return "Konfirmasi Password tidak sama";
        }
        return null;
      },
    );
  }

  // Membuat Tombol Registrasi
  Widget _buttonRegistrasi() {
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
          'Registrasi',
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
    RegistrasiBloc.registrasi(
      nama: _namaTextboxController.text,
      email: _emailTextboxController.text,
      password: _passwordTextboxController.text,
    ).then((value) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => SuccessDialog(
          description: "Registrasi berhasil, silahkan login",
          okClick: () {
            Navigator.pop(context);
          },
        ),
      );
    }, onError: (error) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => const WarningDialog(
          description: "Registrasi gagal, silahkan coba lagi",
        ),
      );
    });
    setState(() {
      _isLoading = false;
    });
  }
}
