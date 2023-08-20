import 'package:objectbox/objectbox.dart';

@Entity()
class Product {
  @Id()
  int id = 0;

  @Index()
  String barCode;

  double price = -1;

  String imageFileName = '';

  Product(this.barCode);
}
