import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projeto_usedev/src/screens/initial_screen.dart';
import 'package:projeto_usedev/src/screens/login_screen.dart';
import 'package:projeto_usedev/src/data/cart.dart';
import 'package:projeto_usedev/src/models/cart_item.dart';
import 'package:projeto_usedev/src/services/login_service.dart';
import 'package:projeto_usedev/src/widgets/app_bar.dart' show buildCartAppBar;

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  void _removeItem(CartItem item) {
    setState(() {
      cart.remove(item);
    });
  }

  void _increaseQuantity(CartItem item) {
    setState(() {
      item.quantity++;
    });
  }

  void _decreaseQuantity(CartItem item) {
    setState(() {
      if (item.quantity > 1) {
        item.quantity--;
      } else {
        _removeItem(item);
      }
    });
  }

  double _calculateTotal() {
    double total = 0;
    for (var item in cart) {
      total += item.totalPrice;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildCartAppBar(context),
      body: cart.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 80,
                    color: Colors.purple[800],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Seu carrinho está vazio',
                    style: TextStyle(fontSize: 24),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.length,
                    itemBuilder: (context, index) {
                      final item = cart[index];
                      return Container(
                        width: double.infinity,
                        margin:
                            const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 180,
                              width: double.infinity,
                              alignment: Alignment.center,
                              color: Colors.white,
                              child: Image.asset(
                                item.produto.image,
                                width: 180,
                                height: 159,
                                alignment: Alignment.center,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.produto.name,
                                    style: TextStyle(
                                      fontFamily: GoogleFonts.orbitron().fontFamily,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    'R\$ ${item.produto.price}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          IconButton(
                                            onPressed: () =>
                                                _decreaseQuantity(item),
                                            icon: const Icon(Icons.remove),
                                          ),
                                          Text(
                                            '${item.quantity}',
                                            style:
                                                const TextStyle(fontSize: 18),
                                          ),
                                          IconButton(
                                            onPressed: () =>
                                                _increaseQuantity(item),
                                            icon: const Icon(Icons.add),
                                          ),
                                        ],
                                      ),
                                      IconButton(
                                        onPressed: () => _removeItem(item),
                                        icon: const Icon(Icons.delete,
                                            color: Colors.red),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    border: Border(
                      top: BorderSide(color: Colors.grey[300]!),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total:',
                            style: TextStyle(
                              fontFamily: GoogleFonts.orbitron().fontFamily,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            'R\$ ${_calculateTotal().toStringAsFixed(2)}',
                            style: TextStyle(
                              fontFamily: GoogleFonts.orbitron().fontFamily,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.purple[800],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          onPressed: () async {
                            final token = await LoginService.getToken();
                            if (!mounted) return;
                            
                            if (token == null || token.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Você precisa estar logado para finalizar a compra.'),
                                ),
                              );
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const LoginScreen(),
                                ),
                              );
                              return;
                            }
                            
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Compra finalizada com sucesso!'),
                              ),
                            );
                            setState(() {
                              cart.clear();
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Finalizar Compra',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const InitialScreen(),
                              ),
                              (route) => false,
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.purple),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Continuar Comprando',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.purple,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}