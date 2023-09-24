// ignore_for_file: unused_local_variable, non_constant_identifier_names, use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_pembukuan/bloc/sharedLogin.dart';
import 'package:flutter_pembukuan/ui/auth/login.dart';
import 'package:flutter_pembukuan/ui/dashboard.dart';
import 'package:flutter_pembukuan/ui/landing.dart';

class LauncherPage extends StatefulWidget {
  const LauncherPage({super.key});

  @override
  State<LauncherPage> createState() => _LauncherPageState();
}

class _LauncherPageState extends State<LauncherPage> {
  String role = '';
  String email_verified_at = '';

  @override
  void initState() {
    super.initState();
    SharedLogin.getRole().then((v) => {role = v});
    SharedLogin.getEmailVerified().then((v) => {email_verified_at = v});
    startLaunching();
  }

  void initialization() async {
    print('ready in 3...');
    await Future.delayed(const Duration(seconds: 1));
    print('ready in 2...');
    await Future.delayed(const Duration(seconds: 1));
    print('ready in 1...');
    await Future.delayed(const Duration(seconds: 1));
    print('go!');
    FlutterNativeSplash.remove();
  }

  startLaunching() async {
    await Future.delayed(const Duration(milliseconds: 500));
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) {
      if (role == 'admin') {
        return const DashboardAdmin();
        // return const KategoriPage();
      } else if (role == 'user') {
        return const LandingPage(pilihPage: 0);
      } else {
        return const LoginPage();
      }
    }));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Color.fromRGBO(172, 17, 69, 1),
        // decoration: const BoxDecoration(
        //   gradient: LinearGradient(
        //     colors: [Colors.pink, Colors.purple],
        //     begin: Alignment.topCenter,
        //     end: Alignment.bottomLeft,
        //   ),
        //   image: DecorationImage(
        //     image: AssetImage('assets/appbar/pattern.png'),
        //     fit: BoxFit.none,
        //     repeat: ImageRepeat.repeat,
        //   ),
        // ),
      ),
    );
  }
}
