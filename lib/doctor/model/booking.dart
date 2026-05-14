class Booking {
  final String date;
  final String description;
  final int id;
  final String receiver;
  final String sender;
  late final String status;
  final String time;
  final String name;
  final String number;
  final String demail;
  final String doc;
  final String degree;
  final String specs;
  final String did;
  final String img;
  final List<String?> disease;
  final List<String?> place;
  final String experience;
  final String user;
  String? paymentMethod;
  String? paymentAmount;
  String? receiptUrl;
  String? paymentStatus;

  Booking({
    required this.user,
    required this.date,
    required this.disease,
    required this.description,
    required this.id,
    required this.receiver,
    required this.sender,
    required this.status,
    required this.time,
    required this.number,
    required this.demail,
    required this.name,
    required this.doc,
    required this.degree,
    required this.specs,
    required this.did,
    required this.img,
    required this.place,
    required this.experience,
    this.paymentMethod,
    this.paymentAmount,
    this.receiptUrl,
    this.paymentStatus,
  });

  factory Booking.fromMap(Map<dynamic, dynamic> data) {
    return Booking(
      user: data['user'] ?? '',
      disease: List<String?>.from(data['disease'] ?? []),
      place: List<String?>.from(data['place'] ?? []),
      date: data['date'] ?? '',
      description: data['description'] ?? '',
      id: data['id'] ?? 0,
      receiver: data['receiver'] ?? '',
      sender: data['sender'] ?? '',
      status: data['status'] ?? 'pending',
      time: data['time'] ?? '',
      name: data['name'] ?? '',
      number: data['number'] ?? '',
      demail: data['demail'] ?? '',
      doc: data['doc'] ?? '',
      degree: data['degree'] ?? '',
      specs: data['specs'] ?? '',
      did: data['did'] ?? '',
      img: data['img'] ?? '',
      experience: data['experience'] ?? '',
      paymentMethod: data['payment_method'],
      paymentAmount: data['payment_amount'],
      receiptUrl: data['receipt_url'],
      paymentStatus: data['payment_status'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user': user,
      'disease': disease,
      'place': place,
      'date': date,
      'description': description,
      'id': id,
      'receiver': receiver,
      'sender': sender,
      'status': status,
      'time': time,
      'name': name,
      'number': number,
      'demail': demail,
      'doc': doc,
      'degree': degree,
      'specs': specs,
      'did': did,
      'img': img,
      'experience': experience,
      'payment_method': paymentMethod,
      'payment_amount': paymentAmount,
      'receipt_url': receiptUrl,
      'payment_status': paymentStatus,
    };
  }
}
