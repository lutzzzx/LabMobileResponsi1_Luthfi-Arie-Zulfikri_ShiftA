import 'package:flutter/material.dart';
import '../bloc/mental_health_bloc.dart';
import '../widget/warning_dialog.dart';
import '/models/mental_health.dart';
import 'mental_health_form.dart';
import 'mental_health_page.dart';

class MentalHealthDetail extends StatefulWidget {
  final MentalHealth? mentalHealth;

  MentalHealthDetail({Key? key, this.mentalHealth}) : super(key: key);

  @override
  _MentalHealthDetailState createState() => _MentalHealthDetailState();
}

class _MentalHealthDetailState extends State<MentalHealthDetail> {
  final _mentalStateTextboxController = TextEditingController();
  final _therapySessionsTextboxController = TextEditingController();
  final _medicationTextboxController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _setTextFields();
  }

  void _setTextFields() {
    if (widget.mentalHealth != null) {
      _mentalStateTextboxController.text = widget.mentalHealth!.mentalState!;
      _therapySessionsTextboxController.text = widget.mentalHealth!.therapySessions.toString();
      _medicationTextboxController.text = widget.mentalHealth!.medication!;
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              'Detail Kesehatan Mental',
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                fontFamily: 'Arial',
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 30),
            _mentalStateTextField(),
            const SizedBox(height: 10),
            _therapySessionsTextField(),
            const SizedBox(height: 10),
            _medicationTextField(),
            const SizedBox(height: 30),
            _buttonSubmit(),
          ],
        ),
      ),
    );
  }

  Widget _mentalStateTextField() {
    return TextFormField(
      controller: _mentalStateTextboxController,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.pink[50],
        hintText: 'Kondisi Mental',
        prefixIcon: const Icon(Icons.health_and_safety, color: Colors.red),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
      readOnly: true, // Make it read-only
    );
  }

  Widget _therapySessionsTextField() {
    return TextFormField(
      controller: _therapySessionsTextboxController,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.pink[50],
        hintText: 'Jumlah Sesi Terapi',
        prefixIcon: const Icon(Icons.schedule, color: Colors.red),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
      readOnly: true, // Make it read-only
    );
  }

  Widget _medicationTextField() {
    return TextFormField(
      controller: _medicationTextboxController,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.pink[50],
        hintText: 'Obat yang Diterima',
        prefixIcon: const Icon(Icons.medication, color: Colors.red),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
      readOnly: true, // Make it read-only
    );
  }

  Widget _buttonSubmit() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [

        OutlinedButton(
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            side: const BorderSide(color: Colors.red, width: 2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          child: const Icon(Icons.edit, color: Colors.red),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MentalHealthForm(
                  mentalHealth: widget.mentalHealth,
                ),
              ),
            );
          },
        ),
        const SizedBox(width: 10), // Spasi antar tombol
        // Tombol Hapus
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          child: const Icon(Icons.delete, color: Colors.white), // Ikon delete
          onPressed: () => confirmHapus(),
        ),
      ],
    );
  }



  void confirmHapus() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Konfirmasi Hapus",
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.red, // Title color
            ),
          ),
          content: const Text("Yakin ingin menghapus data ini?"),
          actions: [
            // Tombol hapus
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.red),
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              ),
              child: const Text("Ya", style: TextStyle(color: Colors.white)),
              onPressed: () {
                MentalHealthBloc.deleteMentalHealthEntry(id: widget.mentalHealth!.id!).then(
                      (value) {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const MentalHealthPage(),
                      ),
                          (route) => false,
                    );
                  },
                  onError: (error) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => const WarningDialog(
                        description: "Hapus gagal, silahkan coba lagi",
                      ),
                    );
                  },
                );
              },
            ),
            // Tombol batal
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.red),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              ),
              child: const Text("Batal", style: TextStyle(color: Colors.red)),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }


}
