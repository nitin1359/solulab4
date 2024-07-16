
import 'package:graphql_flutter/graphql_flutter.dart';

class GraphQLConfiguration {
  static final HttpLink _httpLink = HttpLink(
    'https://solulab4-2cfcbfb38da8.herokuapp.com/',
  );

  static final GraphQLClient client = GraphQLClient(
    link: _httpLink,
    cache: GraphQLCache(store: InMemoryStore()),
  );
}
