import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solulab4/models/book_model.dart';
import 'package:solulab4/services/graphql_service.dart';

class BookController extends GetxController {
  final GraphQLService _graphQLService = GraphQLService();
  final RxList<BookModel> _books = <BookModel>[].obs;

  final RxBool isLoading = false.obs;

  RxList<BookModel> get books => _books;


  @override
  void onInit() {
    super.onInit();
    fetchBooks();
  }

 
  Future<void> fetchBooks() async {
    isLoading.value = true;
    try {
      _books.assignAll(await _graphQLService.getBooks());
      _showSuccessSnackbar('Success', 'Books fetched successfully');
    } catch (e) {
      _showErrorSnackbar('Error', 'Failed to fetch books');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createBook(BookModel book) async {
    try {
      final newBookId = await _graphQLService.createBook(book);
      final newBook = BookModel(
          id: newBookId,
          title: book.title,
          author: book.author,
          year: book.year);
      _books.add(newBook);
      _showSuccessSnackbar('Success', 'Book created successfully');
    } catch (e) {
      _showErrorSnackbar('Error', 'Failed to create book');
    }
  }

  Future<void> updateBook(BookModel book) async {
    try {
      // ignore: unused_local_variable
      final updatedBookId = await _graphQLService.updateBook(book);
      final index = _books.indexWhere((b) => b.id == book.id);
      if (index != -1) {
        _books[index] = book; 
      }
      _showSuccessSnackbar('Success', 'Book updated successfully');
    } catch (e) {
      print("Error updating book in BookController: $e");
      _showErrorSnackbar('Error', 'Failed to update book: $e');
    }
  }

  Future<void> deleteBook(String id) async {
    try {
      await _graphQLService.deleteBook(id);
      _books.removeWhere((b) => b.id == id); 
      _showSuccessSnackbar('Success', 'Book deleted successfully');
    } catch (e) {
      _showErrorSnackbar('Error', 'Failed to delete book');
    }
  }

  void _showSuccessSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  void _showErrorSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }
}
