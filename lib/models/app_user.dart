
enum Genders{
  male,female, others
}


class AppUser {
final String uid;
final String name;
final String email;
final String address;
final String dob;
final Genders gender;
final int? number;

AppUser({
  required this.uid,
  required this.name,
  required this.number,
  required this.address,
  required this.gender,
  required this.dob,
  required this.email,

});

Map<String,dynamic> toMap(){

  return {
    'uid' : uid,
   'userName' : name,
    'number' : number,
    'address' : address,
    'gender' : gender.name,
    'dob' : dob,
    'userEmail': email,
  };
}

factory AppUser.fromMap(Map<String,dynamic>map){

  return AppUser(name: map['userName']  ?? '',
      number: int.tryParse(map['number']?.toString() ?? '0',)??0,
      uid: map['uid'] ?? '',
      address: map['address'] ?? '',
      gender: Genders.values.firstWhere((e)=>e.name == map['gender'], orElse:
      ()=>Genders.others),
      dob: map['dob'] ?? '',
      email: map['userEmail']);

}
}