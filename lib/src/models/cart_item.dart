import 'package:projeto_usedev/src/models/produto.dart';

class CartItem {
  final Produto produto;
  int quantity;

  CartItem({
    required this.produto,
    this.quantity = 1,
  });

  double get totalPrice => double.parse(produto.price.replaceAll('R\$ ', '').replaceAll(',', '.')) * quantity;
}