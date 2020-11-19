import 'dart:convert';

import 'package:blog_api/models/post_model.dart';
import 'package:blog_api/services/post_service.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PostService _postService = PostService();
  List<PostModel> _list = List<PostModel>();

  Future<List<PostModel>> _getPosts() async {
    var result = await _postService.getAllPosts();
    _list = [];
    if (result != null) {
      var blogPosts = json.decode(result.body);
      blogPosts.forEach((post) {
        PostModel model = PostModel();
        setState(() {
          model.title = post['title'];
          model.details = post['details'];
          model.imageUrl = post['featured_image_url'];
          _list.add(model);
        });
      });
    }
    //  print(result.statusCode);
    //print(result.body);
    return _list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Blog App'),
        ),
        body: FutureBuilder(
          future: _getPosts(),
          // ignore: missing_return
          builder:
              (BuildContext context, AsyncSnapshot<List<PostModel>> snapshot) {
            print('length of list ${_list.length}');
            if (_list.length == 0) {
              return Center(
                child: Text('No data'),
              );
            } else if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.network(
                                snapshot.data[index].imageUrl,
                                height: 150,
                                //  width: double.maxFinite,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                snapshot.data[index].title,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w700),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                snapshot.data[index].details.substring(0, 25),
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  });
            }
          },
        ));
  }
}
