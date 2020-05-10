
class HttpService{
  final String postUrl = 'url';

  void signIn(String email, String name) async{
    Map data = {
      'email': email,
      'name': name
    };
//    ...............
  }

  String getApartmentCode(){
    return 'y6JC8FK';
  }

  void connectToApartment(String code){
    Map data ={
      'code': code,
    };
//    ...............
  }


}