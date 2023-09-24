// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:flutter_pembukuan/ui/admin/kategori/kategoriAll.dart';
import 'package:flutter_pembukuan/ui/admin/kategori/kategoriAdd.dart';
import 'package:flutter_pembukuan/ui/admin/kategori/kategoriEdit.dart';
import 'package:flutter_pembukuan/ui/admin/pembukuan/pembukuan.dart';
import 'package:flutter_pembukuan/ui/admin/pembukuan/userAll.dart';
import 'package:flutter_pembukuan/ui/auth/forgotPassword.dart';
import 'package:flutter_pembukuan/ui/auth/login.dart';
import 'package:flutter_pembukuan/ui/auth/register.dart';
import 'package:flutter_pembukuan/ui/dashboard.dart';
import 'package:flutter_pembukuan/ui/landing.dart';
import 'package:flutter_pembukuan/ui/launcher.dart';
import 'package:flutter_pembukuan/ui/catatan/catatanAdd.dart';
import 'package:flutter_pembukuan/ui/catatan/catatanEdit.dart';
import 'package:flutter_pembukuan/ui/profil/akunImage.dart';
import 'package:flutter_pembukuan/ui/profil/akunPassword.dart';
import 'package:flutter_pembukuan/ui/profil/akunEdit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LauncherPage(),
      routes: <String, WidgetBuilder>{
        '/login': (BuildContext context) => const LoginPage(),
        '/register': (BuildContext context) => const RegisterPage(),
        '/forgotPassword': (BuildContext context) => const LupaPassword(),
        '/noteAdd': (BuildContext context) => const CatatanTambah(),
        '/noteEdit': (BuildContext context) => const CatatanEdit(),
        '/launcher': (BuildContext context) => const LauncherPage(),
        '/landing': (BuildContext context) => const LandingPage(pilihPage: 0),
        '/akunEdit': (BuildContext context) => const AkunEdit(),
        '/akunPassword': (BuildContext context) => const AkunPassword(),
        '/akunImage': (BuildContext context) => const AkunImage(),
        '/dashboard': (BuildContext context) => const DashboardAdmin(),
        '/allNote': (BuildContext context) => const PembukuanPage(),
        '/allUserNote': (BuildContext context) => const PembukuanUser(),
        '/category': (BuildContext context) => const KategoriPage(),
        '/categoryAdd': (BuildContext context) => const KategoriTambah(),
        '/categoryEdit': (BuildContext context) => const KategoriEdit(),
      },
    );
  }
}
