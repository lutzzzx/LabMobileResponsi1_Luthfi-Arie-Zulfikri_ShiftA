import 'package:flutter/material.dart';
import '../bloc/mental_health_bloc.dart';
import '../widget/warning_dialog.dart';
import 'mental_health_page.dart';
import 'package:responsi5/models/mental_health.dart';

class MentalHealthForm extends StatefulWidget {
  MentalHealth? mentalHealth;
  MentalHealthForm({Key? key, this.mentalHealth}) : super(key: key);

  @override
  _MentalHealthFormState createState() => _MentalHealthFormState();
}

class _MentalHealthFormState extends State<MentalHealthForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String judul = "Tambah Data";
  String tombolSubmit = "Simpan";
  final _mentalStateTextboxController = TextEditingController();
  final _therapySessionsTextboxController = TextEditingController();
  final _medicationTextboxController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isUpdate();
  }

  isUpdate() {
    if (widget.mentalHealth != null) {
      setState(() {
        judul = "Ubah Data";
        tombolSubmit = "Ubah";
        _mentalStateTextboxController.text = widget.mentalHealth!.mentalState!;
        _therapySessionsTextboxController.text = widget.mentalHealth!.therapySessions.toString();
        _medicationTextboxController.text = widget.mentalHealth!.medication!;
      });
    }
  }

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
              Text(
                judul,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Arial',
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 40),
              _mentalStateTextField(),
              const SizedBox(height: 20),
              _therapySessionsTextField(),
              const SizedBox(height: 20),
              _medicationTextField(),
              const SizedBox(height: 30),
              _buttonSubmit(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _mentalStateTextField() {
    return TextFormField(
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.pink[50],
        hintText: 'Kondisi Mental',
        prefixIcon: const Icon(Icons.health_and_safety, color: Colors.red),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide.none,
        ),
      ),
      keyboardType: TextInputType.text,
      controller: _mentalStateTextboxController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Kondisi Mental harus diisi";
        }
        return null;
      },
    );
  }

  Widget _therapySessionsTextField() {
    return TextFormField(
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.pink[50],
        hintText: 'Jumlah Sesi Terapi',
        prefixIcon: const Icon(Icons.schedule, color: Colors.red),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide.none,
        ),
      ),
      keyboardType: TextInputType.number,
      controller: _therapySessionsTextboxController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Jumlah sesi terapi harus diisi";
        }
        return null;
      },
    );
  }

  Widget _medicationTextField() {
    return TextFormField(
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.pink[50],
        hintText: 'Obat yang Diterima',
        prefixIcon: const Icon(Icons.medication, color: Colors.red),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide.none,
        ),
      ),
      keyboardType: TextInputType.text,
      controller: _medicationTextboxController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Obat yang diterima harus diisi";
        }
        return null;
      },
    );
  }

  Widget _buttonSubmit() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: Text(
          tombolSubmit,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
            fontFamily: 'Arial',
          ),
        ),
        onPressed: () {
          var validate = _formKey.currentState!.validate();
          if (validate) {
            if (!_isLoading) {
              if (widget.mentalHealth != null) {
                ubah();
              } else {
                simpan();
              }
            }
          }
        },
      ),
    );
  }

  simpan() {
    setState(() {
      _isLoading = true;
    });
    MentalHealth createMentalHealth = MentalHealth();
    createMentalHealth.mentalState = _mentalStateTextboxController.text;
    createMentalHealth.therapySessions = int.parse(_therapySessionsTextboxController.text);
    createMentalHealth.medication = _medicationTextboxController.text;

    MentalHealthBloc.addMentalHealthEntry(entry: createMentalHealth).then((value) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => const MentalHealthPage()));
    }, onError: (error) {
      showDialog(
          context: context,
          builder: (BuildContext context) => const WarningDialog(
            description: "Simpan gagal, silahkan coba lagi",
          ));
    });
    setState(() {
      _isLoading = false;
    });
  }

  ubah() {
    setState(() {
      _isLoading = true;
    });
    MentalHealth updateMentalHealth = MentalHealth(id: widget.mentalHealth!.id!);
    updateMentalHealth.mentalState = _mentalStateTextboxController.text;
    updateMentalHealth.therapySessions = int.parse(_therapySessionsTextboxController.text);
    updateMentalHealth.medication = _medicationTextboxController.text;

    MentalHealthBloc.updateMentalHealthEntry(entry: updateMentalHealth).then((value) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => const MentalHealthPage()));
    }, onError: (error) {
      showDialog(
          context: context,
          builder: (BuildContext context) => const WarningDialog(
            description: "Permintaan ubah data gagal, silahkan coba lagi",
          ));
    });
    setState(() {
      _isLoading = false;
    });
  }
}
