import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solulab4/controllers/book_controller.dart';
import 'package:solulab4/models/book_model.dart';

class HomeScreen extends StatelessWidget {
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final BookController bookController = Get.find();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('GraphQL CRUD'),
      ),
      body: Obx(
        () => bookController.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: bookController.books.length,
                itemBuilder: (context, index) {
                  final book = bookController.books[index];
                  return ListTile(
                    title: Text(book.title),
                    subtitle: Text('${book.author} (${book.year})'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            _authorController.text = book.author;
                            _titleController.text = book.title;
                            _yearController.text = book.year;
                            Get.defaultDialog(
                              title: 'Update Book',
                              content: Column(
                                children: [
                                  TextField(
                                    controller: _titleController,
                                    decoration: const InputDecoration(
                                        labelText: 'Title'),
                                  ),
                                  TextField(
                                    controller: _authorController,
                                    decoration: const InputDecoration(
                                        labelText: 'Author'),
                                  ),
                                  TextField(
                                    controller: _yearController,
                                    decoration: const InputDecoration(
                                        labelText: 'Year'),
                                    keyboardType: TextInputType.number,
                                  ),
                                  const SizedBox(height: 16),
                                  ElevatedButton(
                                    onPressed: () {
                                      bookController.updateBook(
                                        BookModel(
                                          id: book.id,
                                          author: _authorController.text,
                                          title: _titleController.text,
                                          year: _yearController.text,
                                        ),
                                      );
                                      Get.back();
                                    },
                                    child: const Text('Update'),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            bookController.deleteBook(book.id!);
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _titleController.clear();
          _authorController.clear();
          _yearController.clear();
          Get.defaultDialog(
            title: 'Add Book',
            content: Column(
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: _authorController,
                  decoration: const InputDecoration(labelText: 'Author'),
                ),
                TextField(
                  controller: _yearController,
                  decoration: const InputDecoration(labelText: 'Year'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    bookController.createBook(
                      BookModel(
                        author: _authorController.text,
                        title: _titleController.text,
                        year: _yearController.text,
                      ),
                    );
                    Get.back();
                    _authorController.clear();
                    _titleController.clear();
                    _yearController.clear();
                  },
                  child: const Text('Add'),
                ),
              ],
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
