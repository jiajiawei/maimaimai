import 'package:objectbox/objectbox.dart';

@Entity()
class Product {
  @Id()
  int id = 0;

  @Index()
  String barCode;

  double price = -1;

  Product(this.barCode);
}
