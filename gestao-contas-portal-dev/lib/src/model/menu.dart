import 'package:flutter/material.dart';

class Menu {
  String title;
  IconData icon;

  Menu({this.title, this.icon});
}

List<Menu> menuItems = [
//  Menu(title: 'Dashboard', icon: Icons.dashboard),
  Menu(title: 'Contas a Pagar', icon: Icons.notification_important),
//  Menu(title: 'Contas a Receber', icon: Icons.web)
];
