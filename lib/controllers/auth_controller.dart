import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';

class AuthController extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? get currentUser => _auth.currentUser;
  UserModel? _userModel;

  UserModel? get userModel => _userModel;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  AuthController() {
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        _fetchUserData(user.uid);
      } else {
        _userModel = null;
        notifyListeners();
      }
    });
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> _fetchUserData(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(uid)
          .get();
      if (doc.exists) {
        _userModel = UserModel.fromMap(doc.data() as Map<String, dynamic>, uid);
        notifyListeners();
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  Future<bool> signUp({
    required String name,
    required String email,
    required String mobileNumber,
    required String password,
  }) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      UserModel newUser = UserModel(
        uid: cred.user!.uid,
        name: name,
        email: email,
        mobileNumber: mobileNumber,
      );

      await _firestore
          .collection('users')
          .doc(cred.user!.uid)
          .set(newUser.toMap());
      _userModel = newUser;
      _setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message ?? "An error occurred during sign up.";
      _setLoading(false);
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      _setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message ?? "An error occurred during login.";
      _setLoading(false);
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  Future<bool> signInWithGoogle() async {
    _setLoading(true);
    _errorMessage = null;
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        _setLoading(false);
        return false; // User canceled sign in
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential cred = await _auth.signInWithCredential(credential);

      // Check if user exists in Firestore
      DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(cred.user!.uid)
          .get();
      if (!doc.exists) {
        // Create new user record
        UserModel newUser = UserModel(
          uid: cred.user!.uid,
          name: cred.user!.displayName ?? 'No Name',
          email: cred.user!.email ?? '',
          mobileNumber: cred.user!.phoneNumber ?? '',
        );
        await _firestore
            .collection('users')
            .doc(cred.user!.uid)
            .set(newUser.toMap());
        _userModel = newUser;
      }

      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  Future<bool> resetPassword(String email) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      await _auth.sendPasswordResetEmail(email: email);
      _setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message ?? "Error sending reset email.";
      _setLoading(false);
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  Future<bool> updateUserData({
    required String name,
    required String mobileNumber,
  }) async {
    if (_auth.currentUser == null) return false;
    _setLoading(true);
    _errorMessage = null;
    try {
      await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
        'name': name,
        'mobileNumber': mobileNumber,
      });

      if (_userModel != null) {
        _userModel = _userModel!.copyWith(
          name: name,
          mobileNumber: mobileNumber,
        );
        notifyListeners();
      }

      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    _userModel = null;
    notifyListeners();
  }
}
