import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projeto_usedev/src/models/produto.dart';
import 'package:projeto_usedev/src/data/cart.dart';
import 'package:projeto_usedev/src/models/cart_item.dart';
import 'package:projeto_usedev/src/widgets/app_bar.dart';

class DetailScreen extends StatelessWidget {
  final Produto produto;

  const DetailScreen({super.key, required this.produto});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildMainAppBar(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Detalhe do Produto',
                style: TextStyle(
                  fontFamily: GoogleFonts.orbitron().fontFamily,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(16),
                child: Image.asset(
                  produto.image,
                  width: double.infinity,
                  height: 260,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                produto.name,
                style: TextStyle(
                  fontFamily: GoogleFonts.orbitron().fontFamily,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                produto.description,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'R\$ ${produto.price}',
                style: TextStyle(
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple[800],
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Check if item already in cart
                    final existingItem = cart.firstWhere(
                      (item) => item.produto.name == produto.name,
                      orElse: () => CartItem(produto: produto, quantity: 0),
                    );
                    if (existingItem.quantity > 0) {
                      existingItem.quantity++;
                    } else {
                      cart.add(CartItem(produto: produto));
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${produto.name} adicionado ao carrinho'),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.add_shopping_cart,
                    color: Colors.white,
                    size: 22,
                  ),

                  label:  Text(
                    'Adicionar ao carrinho',
                    style: TextStyle(
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple[800],
                    foregroundColor: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),              
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
