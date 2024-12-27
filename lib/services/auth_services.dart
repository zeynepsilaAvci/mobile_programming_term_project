import 'package:firebase_auth/firebase_auth.dart';
class AuthService{
  final FirebaseAuth _auth= FirebaseAuth.instance;

  //signin
Future<User?> signInWithEmailAndPassword(String email, String password) async{
  try{
    UserCredential result=await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    User? user=result.user;
    return user;
  }
  catch(e){
    print(e.toString());
    return null;
  }
}

 //sihnup
  Future<User?> registerWithEmailAndPassword(String email, String password) async{
    try{
      UserCredential result=await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user=result.user;
      return user;
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }

  //signout
Future<void> signOut ()async{
  try{
    return await _auth.signOut();
  }catch(e){
    print(e.toString());
    return null;
  }
}
}