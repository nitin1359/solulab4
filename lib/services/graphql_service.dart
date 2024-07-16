import 'package:graphql_flutter/graphql_flutter.dart';
import '../models/book_model.dart';
import 'package:solulab4/services/graphql_client.dart';

class GraphQLService {
  final GraphQLClient _client = GraphQLConfiguration.client;

  // Queries
  static const String getBooksQuery = """
    query GetBooks { 
      getBooks { 
        _id
        author
        title
        year
      }
    }
  """;

  // Mutations
  static const String createBookMutation = """
    mutation CreateBook(\$author: String!, \$title: String!, \$year: String!) {
      createBook(bookInput: { author: \$author, title: \$title, year: \$year }) 
    }
  """;

 static const String updateBookMutation = """
  mutation UpdateBook(\$_id: ID!, \$author: String!, \$title: String!, \$year: String!) {
    updateBook(ID: \$_id, bookInput: { author: \$author, title: \$title, year: \$year })
  }
""";


  static const String deleteBookMutation = """
    mutation DeleteBook(\$_id: ID!) {
      deleteBook(ID: \$_id) 
    }
  """;

  // Function to fetch books
  Future<List<BookModel>> getBooks() async { 
    try {
      final QueryResult result = await _client.query(
        QueryOptions(
          document: gql(getBooksQuery),
        ),
      );

      if (result.hasException) {
        print("GraphQL Error: ${result.exception.toString()}");
        throw Exception(
            "Failed to fetch books: ${result.exception!.graphqlErrors.firstOrNull?.message}");
      }

      List<BookModel> books = [];
      for (var bookData in result.data?['getBooks'] ?? []) { 
        books.add(BookModel.fromMap(map: bookData));
      }
      return books;
    } catch (e) {
      print("Error fetching books: $e");
      throw Exception("Failed to fetch books");
    }
  }

  // Function to create a book (returns the new book's ID as a String)
  Future<String> createBook(BookModel book) async { 
    try {
      final QueryResult result = await _client.mutate(
        MutationOptions(
          document: gql(createBookMutation),
          variables: book.toMap(),
        ),
      );

      if (result.hasException) {
        print("GraphQL Error: ${result.exception.toString()}");
        throw Exception(
            "Failed to create book: ${result.exception!.graphqlErrors.firstOrNull?.message}");
      }

      return result.data?['createBook'] as String;
    } catch (e) {
      print("Error creating book: $e");
      throw Exception("Failed to create book");
    }
  }

  // Function to update a book
  Future<String> updateBook(BookModel book) async {
  try {
    final QueryResult result = await _client.mutate(
      MutationOptions(
        document: gql(updateBookMutation),
        variables: {
          '_id': book.id,
          'author': book.author,
          'title': book.title,
          'year': book.year,
        },
      ),
    );

    if (result.hasException) {
      print("GraphQL Error: ${result.exception.toString()}");
      throw Exception(
          "Failed to update book: ${result.exception?.graphqlErrors.firstOrNull?.message}");
    }

    return result.data?['updateBook'] as String;
  } catch (e) {
    print("Error updating book: $e");
    throw Exception("Failed to update book");
  }
}


  // Function to delete a book
  Future<String> deleteBook(String id) async {
    try {
      final QueryResult result = await _client.mutate(
        MutationOptions(
          document: gql(deleteBookMutation),
          variables: {'_id': id},
        ),
      );

      if (result.hasException) {
        print("GraphQL Error: ${result.exception.toString()}");
        throw Exception(
            "Failed to delete book: ${result.exception?.graphqlErrors.firstOrNull?.message}");
      }

      return 'Book deleted successfully';
    } catch (e) {
      print("Error deleting book: $e");
      throw Exception("Failed to delete book");
    }
  }
}