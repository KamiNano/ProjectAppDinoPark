class Ticket {
  final String id;
  final String type;
  final int quantity;
  final DateTime purchaseTime;

  Ticket({
    required this.id,
    required this.type,
    required this.quantity,
    required this.purchaseTime,
  });

  // แปลง Ticket เป็น Map เพื่อเก็บใน Sembast
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'quantity': quantity,
      'purchaseTime': purchaseTime.toIso8601String(),
    };
  }

  // สร้าง Ticket จาก Map ที่ดึงมาจาก Sembast
  factory Ticket.fromMap(Map<String, dynamic> map) {
    return Ticket(
      id: map['id'] as String,
      type: map['type'] as String,
      quantity: map['quantity'] as int,
      purchaseTime: DateTime.parse(map['purchaseTime'] as String),
    );
  }
}
