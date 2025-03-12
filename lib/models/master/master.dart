class Master {
  String fullName;
  String email;
  String password;
  String? phone;

  Master({
    required this.fullName,
    required this.email,
    required this.password,
    required this.phone
  });

  Map<String, dynamic> toMap(){
    return {
      'fullName': fullName,
      'email': email,
      'password': password,
      'phone': phone,
    };
  }

  factory Master.fromMap(Map<String, dynamic> map){
    return Master(
      fullName: map['fullName'] ?? '',
      email: map['email'],
      password: map['password'],
      phone: map['phone'] ?? '',
    );
  }
}