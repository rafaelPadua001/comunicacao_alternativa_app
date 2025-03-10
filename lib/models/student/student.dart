class Student {
  String fullName;
  String email;
  String password;


  Student({
    required this.fullName,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toMap(){
    return {
      'fullName': fullName,
      'email': email,
      'password': password,
    };
  }

  factory Student.fromMap(Map<String, dynamic> map){
    return Student(
      fullName: map['fullName'] ?? '',
      email: map['email'],
      password: map['password']
    );
  }
}