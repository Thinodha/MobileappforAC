import 'package:cloud_firestore/cloud_firestore.dart';

class ItemServices {
  Future<void> updateScreen({
    required String uid,
    bool isUpdate = false,
  }) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'isUpdate': isUpdate,
      });
      print('Succsessfully Update');
    } catch (e) {
      print('Error Updating items');
      rethrow;
    }
  }

  // Save selected vegetables
  Future<void> saveSelectedVegetables({
    required String uid,
    required List<Map<String, dynamic>> vegetables,
  }) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'selectedVegetables': vegetables,
      });
      print('Selected vegetables updated successfully.');
    } catch (e) {
      print('Error updating selected vegetables: $e');
      rethrow;
    }
  }

  // Save selected fruits
  Future<void> saveSelectedFruits({
    required String uid,
    required List<Map<String, dynamic>> fruits,
  }) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'selectedFruits': fruits,
      });
      print('Selected fruits updated successfully.');
    } catch (e) {
      print('Error updating selected fruits: $e');
      rethrow;
    }
  }

  // Get user selected items
  Future<Map<String, dynamic>> getUserSelectedItems(String uid) async {
    try {
      final docSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (!docSnapshot.exists) {
        return {'selectedVegetables': [], 'selectedFruits': []};
      }

      final data = docSnapshot.data() ?? {};

      return {
        'selectedVegetables': data['selectedVegetables'] ?? [],
        'selectedFruits': data['selectedFruits'] ?? [],
      };
    } catch (e) {
      print('Error getting user selected items: $e');
      rethrow;
    }
  }

  // Update a specific vegetable item
  Future<void> updateVegetableItem({
    required String uid,
    required int index,
    required Map<String, dynamic> updatedItem,
  }) async {
    try {
      // First get the current list
      final userData = await getUserSelectedItems(uid);
      final vegetables = List<Map<String, dynamic>>.from(
        userData['selectedVegetables'],
      );

      // Update the specific item
      if (index >= 0 && index < vegetables.length) {
        vegetables[index] = updatedItem;

        // Save back to Firestore
        await saveSelectedVegetables(uid: uid, vegetables: vegetables);
      }
    } catch (e) {
      print('Error updating vegetable item: $e');
      rethrow;
    }
  }

  // Update a specific fruit item
  Future<void> updateFruitItem({
    required String uid,
    required int index,
    required Map<String, dynamic> updatedItem,
  }) async {
    try {
      // First get the current list
      final userData = await getUserSelectedItems(uid);
      final fruits = List<Map<String, dynamic>>.from(
        userData['selectedFruits'],
      );

      // Update the specific item
      if (index >= 0 && index < fruits.length) {
        fruits[index] = updatedItem;

        // Save back to Firestore
        await saveSelectedFruits(uid: uid, fruits: fruits);
      }
    } catch (e) {
      print('Error updating fruit item: $e');
      rethrow;
    }
  }

  // Delete a vegetable item
  Future<void> deleteVegetableItem({
    required String uid,
    required int index,
  }) async {
    try {
      // First get the current list
      final userData = await getUserSelectedItems(uid);
      final vegetables = List<Map<String, dynamic>>.from(
        userData['selectedVegetables'],
      );

      // Remove the specific item
      if (index >= 0 && index < vegetables.length) {
        vegetables.removeAt(index);

        // Save back to Firestore
        await saveSelectedVegetables(uid: uid, vegetables: vegetables);
      }
    } catch (e) {
      print('Error deleting vegetable item: $e');
      rethrow;
    }
  }

  // Delete a fruit item
  Future<void> deleteFruitItem({
    required String uid,
    required int index,
  }) async {
    try {
      // First get the current list
      final userData = await getUserSelectedItems(uid);
      final fruits = List<Map<String, dynamic>>.from(
        userData['selectedFruits'],
      );

      // Remove the specific item
      if (index >= 0 && index < fruits.length) {
        fruits.removeAt(index);

        // Save back to Firestore
        await saveSelectedFruits(uid: uid, fruits: fruits);
      }
    } catch (e) {
      print('Error deleting fruit item: $e');
      rethrow;
    }
  }

  // Update price and quantity for a vegetable
  Future<void> updateVegetablePriceAndQuantity({
    required String uid,
    required int index,
    required String price,
    required String quantity,
  }) async {
    try {
      // First get the current list and the specific item
      final userData = await getUserSelectedItems(uid);
      final vegetables = List<Map<String, dynamic>>.from(
        userData['selectedVegetables'],
      );

      if (index >= 0 && index < vegetables.length) {
        final updatedItem = Map<String, dynamic>.from(vegetables[index]);
        updatedItem['price'] = price;
        updatedItem['quantity'] = quantity;

        // Update the item and save
        await updateVegetableItem(
          uid: uid,
          index: index,
          updatedItem: updatedItem,
        );
      }
    } catch (e) {
      print('Error updating vegetable price and quantity: $e');
      rethrow;
    }
  }

  // Update price and quantity for a fruit
  Future<void> updateFruitPriceAndQuantity({
    required String uid,
    required int index,
    required String price,
    required String quantity,
  }) async {
    try {
      // First get the current list and the specific item
      final userData = await getUserSelectedItems(uid);
      final fruits = List<Map<String, dynamic>>.from(
        userData['selectedFruits'],
      );

      if (index >= 0 && index < fruits.length) {
        final updatedItem = Map<String, dynamic>.from(fruits[index]);
        updatedItem['price'] = price;
        updatedItem['quantity'] = quantity;

        // Update the item and save
        await updateFruitItem(uid: uid, index: index, updatedItem: updatedItem);
      }
    } catch (e) {
      print('Error updating fruit price and quantity: $e');
      rethrow;
    }
  }
}
