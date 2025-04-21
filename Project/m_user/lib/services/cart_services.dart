import 'package:flutter/material.dart';
import 'package:m_user/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ItemService {

  ItemService();

  Future<void> addToitem(BuildContext context, int id) async {
    try {
      final userId = supabase.auth.currentUser?.id;
      final prefs = await SharedPreferences.getInstance();
      String? shopId = await prefs.getString('shop');
      print(userId);
      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("User not logged in")),
        );
        return;
      }


      // Get or create a order
      final order = await supabase
          .from('tbl_order')
          .select()
          .eq('order_status', 0)
          .eq('user_id', userId)
          .eq('shop_id', shopId!)
          .maybeSingle();

      int orderId;
      if (order == null) {
        final response = await supabase
            .from('tbl_order')
            .insert({'user_id': userId, 'order_status': 0, 'shop_id': shopId})
            .select("id")
            .single();
        orderId = response['id'];
      } else {
        orderId = order['id'];
      }

      // Check if item already exists in item
      final itemResponse = await supabase
          .from('tbl_item')
          .select()
          .eq('order_id', orderId)
          .eq('food_id', id)
          .maybeSingle();

      if (itemResponse == null) {
        // Item doesn't exist, add it with quantity 1
        await _additem(context, orderId, id);
      } else {
        // Item exists, increase quantity
        await _updateitemQuantity(context, itemResponse['id'], itemResponse['item_quantity']);
      }
    } catch (e) {
      print('Error adding ordr to item: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error adding to item: $e")),
      );
    }
  }

  Future<void> _additem(BuildContext context, int orderId, int itemId) async {
    try {
      await supabase.from('tbl_item').insert({
        'order_id': orderId,
        'food_id': itemId,
        'item_quantity': 1, // Initial quantity
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Added to item")),
      );
    } catch (e) {
      print('Error adding to item: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error adding to item: $e")),
      );
    }
  }

  Future<void> _updateitemQuantity(BuildContext context, int itemId, int currentQuantity) async {
    try {
      final newQuantity = currentQuantity + 1;
      await supabase
          .from('tbl_item')
          .update({'item_quantity': newQuantity})
          .eq('id', itemId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Quantity updated to $newQuantity")),
      );
    } catch (e) {
      print('Error updating item quantity: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating item")),
      );
    }
  }
}