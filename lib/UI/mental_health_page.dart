import 'package:flutter/material.dart';
import '../bloc/logout_bloc.dart';
import '../bloc/mental_health_bloc.dart';
import '/models/mental_health.dart';
import 'mental_health_detail.dart';
import 'mental_health_form.dart';
import 'login_page.dart';

class MentalHealthPage extends StatefulWidget {
  const MentalHealthPage({Key? key}) : super(key: key);

  @override
  _MentalHealthPageState createState() => _MentalHealthPageState();
}

class _MentalHealthPageState extends State<MentalHealthPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.red),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: const Text('Logout', style: TextStyle(color: Colors.red)),
              trailing: const Icon(Icons.logout, color: Colors.red),
              onTap: () async {
                await LogoutBloc.logout().then((value) => {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => LoginPage()),
                          (route) => false)
                });
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Kesehatan Mental',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                  fontFamily: 'Arial',
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Daftar Kesehatan Mental',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontFamily: 'Arial',
                ),
              ),
              const SizedBox(height: 16),
              FutureBuilder<List>(
                future: MentalHealthBloc.getMentalHealthEntries(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) print(snapshot.error);
                  return snapshot.hasData
                      ? ListMentalHealth(
                    list: snapshot.data,
                  )
                      : const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MentalHealthForm()),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class ListMentalHealth extends StatelessWidget {
  final List? list;

  const ListMentalHealth({Key? key, this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: list == null ? 0 : list!.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, i) {
        return ItemMentalHealth(
          mentalHealth: list![i],
        );
      },
    );
  }
}

class ItemMentalHealth extends StatelessWidget {
  final MentalHealth mentalHealth;

  const ItemMentalHealth({Key? key, required this.mentalHealth}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MentalHealthDetail(
              mentalHealth: mentalHealth,
            ),
          ),
        );
      },
      child: Card(
        color: Colors.pink[50],
        elevation: 0,
        child: ListTile(
          leading: Icon(
            Icons.self_improvement,
            color: Colors.red,
          ),
          title: Text(
            mentalHealth.mentalState!,
            style: const TextStyle(
              fontFamily: 'Arial',
              fontSize: 18,
              color: Colors.black,
            ),
          ),
          subtitle: Text(
            mentalHealth.therapySessions.toString(),
            style: const TextStyle(
              fontFamily: 'Arial',
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          trailing: Text(
            mentalHealth.medication!,
            style: const TextStyle(
              fontFamily: 'Arial',
              fontSize: 14,
              color: Colors.red,
            ),
          ),
        ),
      ),
    );
  }
}
