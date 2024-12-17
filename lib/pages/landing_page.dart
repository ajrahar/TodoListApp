import 'package:aplikasi_todo_list/includes/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MainMenuPage extends StatefulWidget {
  @override
  State<MainMenuPage> createState() => _MainMenuPageState();
}

class _MainMenuPageState extends State<MainMenuPage> {

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        // Navigasi ke halaman TodoList
        Navigator.pushReplacementNamed(context, '/todoList');
        break;
      case 1:
        // Navigasi ke halaman Settings
        Navigator.pushReplacementNamed(context, '/landing');
        break;
      case 2:
        // Navigasi ke halaman Profile
        Navigator.pushReplacementNamed(context, '/profile');
        break;
    }
  }
  // Fungsi untuk mendapatkan ucapan berdasarkan waktu
  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return "Selamat Pagi!";
    } else if (hour < 15) {
      return "Selamat Siang!";
    } else if (hour < 18) {
      return "Selamat Sore!";
    } else {
      return "Selamat Malam!";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Menu Utama"),
        automaticallyImplyLeading: false, // Menghilangkan tombol kembali
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ucapan berdasarkan waktu
            Text(
              _getGreeting(),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Selamat datang di aplikasi Todo List Anda.",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 30),

            // Ringkasan Todo
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: Icon(Icons.checklist, color: Colors.blueAccent),
                title: Text(
                  "Daftar Todo",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                subtitle: Text("Kelola dan pantau daftar tugas Anda."),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.pushNamed(context, '/todos');
                },
              ),
            ),
            SizedBox(height: 10),

            // Menu Profil
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: Icon(Icons.person, color: Colors.green),
                title: Text(
                  "Profil Anda",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                subtitle: Text("Lihat dan kelola informasi profil."),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.pushNamed(context, '/profile');
                },
              ),
            ),
            SizedBox(height: 10),

            // Menu Pengaturan
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: Icon(Icons.settings, color: Colors.orangeAccent),
                title: Text(
                  "Pengaturan",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                subtitle: Text("Atur preferensi aplikasi Anda."),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.pushNamed(context, '/settings');
                },
              ),
            ),
            Spacer(),

            // Footer
            Center(
              child: Text(
                "Versi 1.0.0",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
