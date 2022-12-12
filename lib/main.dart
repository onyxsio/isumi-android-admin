import 'package:flutter/material.dart';
import 'package:onyxsio/onyxsio.dart';

void main() async {
  await Onyxsio.init();
  final authRepo = AuthRepository();
  await authRepo.user.first;
  runApp(AppProviders(authRepo: authRepo));
}
