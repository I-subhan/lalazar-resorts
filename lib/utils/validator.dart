
class Validators{

  //email

  static bool isValidEmail(String input){

    final pattern = r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$';

    return RegExp(pattern).hasMatch(input);

  }
  //number
static bool isValidPakistaninumber(String input){

    final pattern = r'^03\d{9}$';

    return RegExp(pattern).hasMatch(input);
}
//password
static bool isValidPass(String input){

    final pattern = r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$';

    return RegExp(pattern).hasMatch(input);

}
}