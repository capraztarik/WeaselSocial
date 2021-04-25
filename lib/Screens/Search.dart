import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weasel_social_media_app/Utilities/styles.dart';
import '../Utilities/custom_search_delegates.dart';
import 'package:toggle_switch/toggle_switch.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  Future<void> _showSearch() async {
    final searchText = await showSearch<String>(
      context: context,
      delegate: SearchWithSuggestionDelegate(
        onSearchChanged: _getRecentSearchesLike,
      ),
    );

    //Save the searchText to SharedPref so that next time you can use them as recent searches.
    await _saveToRecentSearches(searchText);
  }

  Future<List<String>> _getRecentSearchesLike(String query) async {
    final pref = await SharedPreferences.getInstance();
    final allSearches = pref.getStringList("recentSearches");
    return allSearches.where((search) => search.startsWith(query)).toList();
  }

  Future<void> _saveToRecentSearches(String searchText) async {
    if (searchText == null) return; //Should not be null
    final pref = await SharedPreferences.getInstance();

    //Use `Set` to avoid duplication of recentSearches
    Set<String> allSearches =
        pref.getStringList("recentSearches")?.toSet() ?? {};

    //Place it at first in the set
    allSearches = {searchText, ...allSearches};
    pref.setStringList("recentSearches", allSearches.toList());
  }

  var searchList = [
    {
      "id": "1",
      "name": "Abidin Gokcekaya",
      "picture":
          "https://i.pinimg.com/564x/d9/56/9b/d9569bbed4393e2ceb1af7ba64fdf86a.jpg",
    },
    {
      "id": "2",
      "name": "Mert Kolabas",
      "picture":
          "https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
    },
    {
      "id": "1",
      "name": "Abidin Gokcekaya",
      "picture":
          "https://i.pinimg.com/564x/d9/56/9b/d9569bbed4393e2ceb1af7ba64fdf86a.jpg",
    },
    {
      "id": "1",
      "name": "Abidin Gokcekaya",
      "picture":
          "https://i.pinimg.com/564x/d9/56/9b/d9569bbed4393e2ceb1af7ba64fdf86a.jpg",
    },
    {
      "id": "1",
      "name": "Abidin Gokcekaya",
      "picture":
          "https://i.pinimg.com/564x/d9/56/9b/d9569bbed4393e2ceb1af7ba64fdf86a.jpg",
    },
    {
      "id": "1",
      "name": "Abidin Gokcekaya",
      "picture":
          "https://i.pinimg.com/564x/d9/56/9b/d9569bbed4393e2ceb1af7ba64fdf86a.jpg",
    },
    {
      "id": "1",
      "name": "Abidin Gokcekaya",
      "picture":
          "https://i.pinimg.com/564x/d9/56/9b/d9569bbed4393e2ceb1af7ba64fdf86a.jpg",
    },
    {
      "id": "1",
      "name": "Abidin Gokcekaya",
      "picture":
          "https://i.pinimg.com/564x/d9/56/9b/d9569bbed4393e2ceb1af7ba64fdf86a.jpg",
    },
    {
      "id": "1",
      "name": "Abidin Gokcekaya",
      "picture":
          "https://i.pinimg.com/564x/d9/56/9b/d9569bbed4393e2ceb1af7ba64fdf86a.jpg",
    },
    {
      "id": "1",
      "name": "Abidin Gokcekaya",
      "picture":
          "https://i.pinimg.com/564x/d9/56/9b/d9569bbed4393e2ceb1af7ba64fdf86a.jpg",
    },
    {
      "id": "1",
      "name": "Abidin Gokcekaya",
      "picture":
          "https://i.pinimg.com/564x/d9/56/9b/d9569bbed4393e2ceb1af7ba64fdf86a.jpg",
    },
    {
      "id": "1",
      "name": "Abidin Gokcekaya",
      "picture":
          "https://i.pinimg.com/564x/d9/56/9b/d9569bbed4393e2ceb1af7ba64fdf86a.jpg",
    },
  ];

  var postList = [
    {
      "id": "1",
      "name": "Abidin Gokcekaya",
      "profilepicture":
          "https://i.pinimg.com/564x/d9/56/9b/d9569bbed4393e2ceb1af7ba64fdf86a.jpg",
      "postpicture":
          "https://lh3.googleusercontent.com/S91cavnhzA402I4Db58tuo83mFdRG5pvCXq3CPSJN4tzYvqBx4h1zwkCWoZ4zxJO371IkwrfUiXZAHTeHA6_kTKAQjs=w640-h400-e365-rj-sc0x00ffffff"
    },
    {
      "id": "2",
      "name": "Mert Kolabas",
      "profilepicture":
          "https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
      "postpicture":
          "https://travelplanner.app/wp-content/uploads/2021/02/1200px-Shaqi_jrvej.jpg"
    }
  ];
  int _currentState = 0;
  bool boolState = false;

  Widget swapTile() {
    return AnimatedCrossFade(
      duration: const Duration(milliseconds: 500),
      firstChild: usersearchview(searchList),
      secondChild: postsearchview(postList),
      crossFadeState:
          boolState ? CrossFadeState.showSecond : CrossFadeState.showFirst,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white30,
        title: Text(
          "Weasel",
          style: TextStyle(color: Colors.black87),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.black87,
            ),
            onPressed: _showSearch,
          ),
        ],
      ),
      body: ListView(
        children: [
          Center(
            child: Container(
              height: 50,
              //width: MediaQuery.of(context).size.width,
              child: ToggleSwitch(
                cornerRadius: 0.0,
                minWidth: MediaQuery.of(context).size.width,
                fontSize: 17.0,
                initialLabelIndex: _currentState,
                activeBgColor: Color(0xFF03B898),
                activeFgColor: Colors.black87,
                inactiveBgColor: Colors.white,
                inactiveFgColor: Colors.black87,
                labels: ['Username', 'Location', 'Post Content'],
                onToggle: (index) {
                  print('switched to: $index');
                  setState(() {
                    _currentState = index;
                    if (index == 0)
                      boolState = false;
                    else
                      boolState = true;
                  });
                },
              ),
            ),
          ),
          swapTile(),
        ],
      ),
    );
  }
}

Widget usersearchview(var searchList) {
  final ScrollController controller = new ScrollController();
  return ListView.builder(
    shrinkWrap: true,
    scrollDirection: Axis.vertical,
    controller: controller,
    itemCount: searchList.length,
    itemBuilder: (context, i) {
      return userSearchUI(
          searchList[i]["id"], searchList[i]["name"], searchList[i]["picture"]);
    },
  );
}

Widget postsearchview(var postList) {
  final ScrollController controller = new ScrollController();
  return ListView.builder(
    //physics: AlwaysScrollableScrollPhysics(),
    controller: controller,
    shrinkWrap: true,
    scrollDirection: Axis.vertical,
    itemCount: postList.length,
    itemBuilder: (context, i) {
      return postSearchUI(postList[i]["id"], postList[i]["name"],
          postList[i]["profilepicture"], postList[i]["postpicture"]);
    },
  );
}

Widget userSearchUI(var key, String name, String imageUrl) {
  return Container(
    child: Column(
      children: <Widget>[
        Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: 55,
                    height: 55,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage('$imageUrl'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(5.0),
                ),
                Text(
                  '$name',
                  style: kTextStyle,
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Widget postSearchUI(
    var key, String name, String profileImageUrl, String postImageUrl) {
  return Container(
    child: Column(
      children: <Widget>[
        Card(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: 55,
                        height: 55,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: NetworkImage('$profileImageUrl'),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5.0),
                    ),
                    Text(
                      '$name',
                      style: kTextStyle,
                    ),
                  ],
                ),
              ),
              Divider(
                thickness: 2,
              ),
              Container(
                height: 300,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage('$postImageUrl'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
