import 'package:eathlete/models/class_definitions.dart';
import 'package:eathlete/models/goal_model.dart';
import 'package:eathlete/screens/homepage_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../models/diary_model.dart';
import '../models/user_model.dart';

/// This class contains logic for the user to log in, as well as containing user
/// info and diary info
class UserRepository extends ChangeNotifier {
  ///instances for login of user
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final FacebookLogin _facebookLogin;
  Box diaryBox;
  Box userBox;

  ///information about user that can be accessed by the rest of the app
  List<UserNotification> notifications;
  User user;


  UserRepository({FirebaseAuth firebaseAuth, GoogleSignIn googleSignin})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignin ?? GoogleSignIn(),
        _facebookLogin = FacebookLogin(),
        user = User();

  Future<User> signInWithFacebook(bool isDeleted) async {
    final FacebookLoginResult facebookUser =
        await _facebookLogin.logIn(['email']);
    final FacebookAccessToken facebookAccessToken = facebookUser.accessToken;
    final AuthCredential credential = FacebookAuthProvider.getCredential(
        accessToken: facebookAccessToken.token);
    var _authResult = await _firebaseAuth.signInWithCredential(credential);
    FirebaseUser firebaseUser = _authResult.user;
    final FirebaseUser currentUser = await _firebaseAuth.currentUser();
    assert(firebaseUser.uid == currentUser.uid);
    IdTokenResult idToken = await firebaseUser.getIdToken();
    String jwt = idToken.token;
    user.jwt = jwt;

    if (!isDeleted) await setUserOnSignIn();
    return user;
  }

  Future<User> signInWithGoogle(bool isDelete) async {
    try {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      var _authResult = await _firebaseAuth.signInWithCredential(credential);
      FirebaseUser firebaseUser = _authResult.user;
      final FirebaseUser currentUser = await _firebaseAuth.currentUser();
      assert(firebaseUser.uid == currentUser.uid);
      IdTokenResult idToken = await firebaseUser.getIdToken();
      String jwt = idToken.token;
      user.jwt = jwt;
      if (!isDelete) await setUserOnSignIn();
      return user;
    } catch (e) {
      throw e;
    }
  }

  Future<User> signInWithApple(bool isDelete) async {
    try {
      AuthorizationCredentialAppleID appleCredential =
          await SignInWithApple.getAppleIDCredential(scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ]);

      OAuthProvider oAuthProvider = OAuthProvider(providerId: "apple.com");
      final AuthCredential credential = oAuthProvider.getCredential(
          idToken: appleCredential.identityToken,
          accessToken: appleCredential.authorizationCode);

      final AuthResult _authResult =
          await FirebaseAuth.instance.signInWithCredential(credential);
      FirebaseUser firebaseUser = _authResult.user;
      final FirebaseUser currentUser = await _firebaseAuth.currentUser();
      assert(firebaseUser.uid == currentUser.uid);
      IdTokenResult idToken = await firebaseUser.getIdToken();
      String jwt = idToken.token;
      user.jwt = jwt;
      if (!isDelete) await setUserOnSignIn();
      return user;
    } catch (e) {
      print(e);
      throw e;
    }
  }

  ///method to be called when a user signs in, which makes calls to api to
  ///get all user info and store it on the device
  Future<void> setUserOnSignIn() async {

    await user.getUserInfo(await refreshIdToken());
    print('got user info');
    //following code block meant to replace the need for database functions
    userBox = await Hive.openBox('userBox');
    diaryBox = await Hive.openBox('diaryBox');
    userBox.add(user);
    diaryBox.put('sessionList', await getSessionList(user.jwt));
    diaryBox.put('generalDayList', await getGeneralDayList(user.jwt));
    diaryBox.put('competitionList', await getCompetitionList(user.jwt));
    diaryBox.put('resultList', await getResultList(user.jwt));
    diaryBox.put('performanceObjective', await getObjective(user.jwt, 'Performance'));
    diaryBox.put('hoursWorkedObjective', await getObjective(user.jwt, 'Hours Worked'));
    diaryBox.put('intensityObjective', await getObjective(user.jwt, 'Intensity'));
    diaryBox.put('shortTermGoals', await getGoals(user.jwt, 'Short'));
    diaryBox.put('mediumTermGoals', await getGoals(user.jwt, 'Medium'));
    diaryBox.put('longTermGoals', await getGoals(user.jwt, "Long"));
    diaryBox.put('finishedGoals', await getGoals(user.jwt, 'Finished'));
    diaryBox.put('ultimateGoal', await getGoals(user.jwt, 'Ultimate'));
    diaryBox.put('diaryObjectsToSend', []);
    diaryBox.put('diaryObjectsToDelete', []);
    print('got to the end of here');


  }

  Future<void> signInWithCredentials(
      String email, String password, bool isDelete) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final FirebaseUser currentUser = await _firebaseAuth.currentUser();

    IdTokenResult idToken = await currentUser.getIdToken();
    String jwt = idToken.token;
    user.jwt = jwt;
    await user.getUserInfo(await refreshIdToken());
    if (!isDelete) await setUserOnSignIn();
  }

  Future<String> refreshIdToken() async {
    try {
      final FirebaseUser currentUser = await _firebaseAuth.currentUser();
      IdTokenResult idToken = await currentUser.getIdToken();
      String jwt = idToken.token;
      return jwt;
    } catch (e) {
      print(e);
      return 'failed';
    }
  }

  Future<void> resetPassword(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> signUp({String email, String password}) async {
    try {
      print('before event');
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('after event');
      final FirebaseUser currentUser = await _firebaseAuth.currentUser();
      currentUser.sendEmailVerification();
      IdTokenResult idToken = await currentUser.getIdToken();
    } catch (e) {
      throw e;
    }
  }

  Future<void> signOut() async {
    await Hive.box('diaryBox').clear();
    // await Hive.box('diaryBox').close();
    return Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn.signOut(),

      // userBox.clear(),
      // userBox.close()
    ]);
  }

  Future<bool> isSignedIn() async {
    final currentUser = await _firebaseAuth.currentUser();
    return currentUser != null;
  }

  Future<FirebaseUser> getUser() async {
    return (await _firebaseAuth.currentUser());
  }

  Future<void> deleteUser() async {
    FirebaseUser currentUser = await _firebaseAuth.currentUser();
    await user.deleteUser(await refreshIdToken());
    currentUser.delete();
  }
}
