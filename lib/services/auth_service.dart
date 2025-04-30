import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signUp(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      print('SignUp Error: $e');
      return null;
    }
  }

  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      print('SignIn Error: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<User?> signUpWithRole(
    String email,
    String password,
    String role,
    String username,
  ) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;

      // Save user data in Firestore
      await FirebaseFirestore.instance.collection('users').doc(user!.uid).set({
        'uid': user.uid,
        'email': user.email,
        'role': role, // default: 'user'
        'username': username,
      });

      return user;
    } catch (e) {
      print('SignUp Error: $e');
      return null;
    }
  }

  Future<String?> getUserRole(String uid) async {
    try {
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      return userDoc['role'];
    } catch (e) {
      print('Error fetching role: $e');
      return null;
    }
  }

  Future<void> saveFarmerDetails({
    required String uid,
    required String name,
    required String address,
    required String fieldAddress,
    required String phone1,
    required String phone2,
  }) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'name': name,
        'address': address,
        'fieldAddress': fieldAddress,
        'phone1': phone1,
        'phone2': phone2,
      });
      print('Farmer details updated successfully.');
    } catch (e) {
      print('Error updating farmer details: $e');
      rethrow;
    }
  }

  Future<void> saveBankDetails({
    required String uid,
    required String name,
    required String accountNumber,
    required String bank,
    required String branch,
  }) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'bankName': bank,
        'accountHolderName': name,
        'accountNumber': accountNumber,
        'branch': branch,
      });
      print('Bank details updated successfully.');
    } catch (e) {
      print('Error saving bank details: $e');
      rethrow;
    }
  }

  // First, define a vegetable name mapping

  Stream<User?> get userChanges => _auth.authStateChanges();
}
