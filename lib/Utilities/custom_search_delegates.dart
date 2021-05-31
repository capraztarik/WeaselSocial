import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weasel_social_media_app/Screens/Search.dart';

typedef OnSearchChanged = Future<List<String>> Function(String);

class SearchWithSuggestionDelegate extends SearchDelegate<String> {
  /*Future<List<Product>> getProducts() async {
    http.Response response = await http.get(
        Uri.https(
            'cs308ecommerceapp.herokuapp.com', '/api/product/search=' + query),
        headers: <String, String>{
          "Authorization": "Token cc71fbb1837a85d251518bece8db7e7cdfa04875"
        });
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      var returnList = list.map((model) => Product.fromJson(model)).toList();
      print("getlist");
      ctrl.add(returnList);
      return returnList;
    } else {
      print('Error!!');
      return null;
    }
  }

  StreamController<List<Product>> ctrl =
      StreamController<List<Product>>.broadcast();*/

  ///[onSearchChanged] gets the [query] as an argument. Then this callback
  ///should process [query] then return an [List<String>] as suggestions.
  ///Since its returns a [Future] you get suggestions from server too.
  final OnSearchChanged onSearchChanged;

  ///This [_oldFilters] used to store the previous suggestions. While waiting
  ///for [onSearchChanged] to completed, [_oldFilters] are displayed.
  List<String> _oldFilters = const [];

  SearchWithSuggestionDelegate({String searchFieldLabel, this.onSearchChanged})
      : super(searchFieldLabel: searchFieldLabel);

  ///
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => Navigator.pop(context),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () => query = "",
      ),
    ];
  }

  ///Since [showResults] is overridden we can don't have to build the results.
  @override
  Widget buildResults(BuildContext context) {
    return SearchPage(query: query, pageState: "search");
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: onSearchChanged != null ? onSearchChanged(query) : null,
      builder: (context, snapshot) {
        if (snapshot.hasData) _oldFilters = snapshot.data;
        return ListView.builder(
          itemCount: _oldFilters.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: Icon(Icons.restore),
              title: Text("${_oldFilters[index]}"),
              onTap: () => close(context, _oldFilters[index]),
            );
          },
        );
      },
    );
  }
}
