// class Theater {
//   int id;
//   String title;
//   String address;
//   bool isSelected;
//
//   Theater(this.id, this.title, this.address, this.isSelected);
// }
class Theater {
  final int id;
  final String title;
  final String address;
  bool isSelected;

  Theater({
    required this.id,
    required this.title,
    required this.address,
    this.isSelected = false, // Default value for isSelected if not provided
  });
}
