import 'package:flutter/material.dart';
import 'package:projeto_usedev/src/screens/cart_screen.dart';
import 'package:projeto_usedev/src/screens/login_screen.dart';

PreferredSizeWidget buildMainAppBar(BuildContext context, {VoidCallback? onCartTap}) {
  return AppBar(
    leading: const Icon(Icons.menu, size: 40),
    title: const Center(
      child: Image(image: AssetImage('assets/logo_usedev.png'), height: 40),
    ),
    actions: [
      IconButton(
        icon: const Icon(Icons.person_outline, size: 40),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          );
        },
      ),
      const SizedBox(width: 10),
      IconButton(
        icon: const Icon(Icons.shopping_cart_outlined, size: 40),
        onPressed: onCartTap ?? () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CartScreen()),
          );
        },
      ),
      const SizedBox(width: 25),
    ],
  );
}

PreferredSizeWidget buildCartAppBar(BuildContext context) {
  return AppBar(
    leading: IconButton(
      icon: const Icon(Icons.arrow_back, size: 40),
      onPressed: () => Navigator.pop(context),
    ),
    title: const Center(
      child: Image(image: AssetImage('assets/logo_usedev.png'), height: 40),
    ),
    actions: [
      IconButton(
        icon: const Icon(Icons.person_outline, size: 40),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          );
        },
      ),
      const SizedBox(width: 10),
      const Icon(Icons.shopping_cart_outlined, size: 40),
      const SizedBox(width: 25),
    ],
  );
}