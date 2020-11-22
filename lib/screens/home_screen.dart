import 'dart:convert';

import 'package:blog_api/models/post_model.dart';
import 'package:blog_api/services/post_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PostService _postService = PostService();

  Future<List<PostModel>> _getPosts() async {
    var result = await _postService.getAllPosts();
    List<PostModel> _list = List<PostModel>();
    if (result != null) {
      var blogPosts = json.decode(result.body);
      blogPosts.forEach((post) {
        var model = PostModel();
        model.title = post['title'];
        model.details = post['details'];
        model.date = post['created_at'];
        model.category = post['category']['name'];
        String img = post['featured_image_url'];
        model.imageUrl = img.substring(22, img.length);
        _list.add(model);
      });
    }

    return _list;
  }

  @override
  Widget build(BuildContext context) {
    var url = 'http://192.168.1.2:8000/';
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Blog App'),
        ),
        body: FutureBuilder(
            future: _getPosts(),
            builder: (BuildContext context,
                AsyncSnapshot<List<PostModel>> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.data.length == 0) {
                return Center(
                  child: Text('No Blog posts !!!'),
                );
              } else {
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 8),
                        child: GestureDetector(
                          onTap: () {},
                          child: Card(
                            elevation: 2.5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.network(
                                  // 'https://images.unsplash.com/photo-1511988617509-a57c8a288659?ixlib=rb-1.2.1&ixid=MXwxMjA3fDB8MHxleHBsb3JlLWZlZWR8NXx8fGVufDB8fHw%3D&auto=format&fit=crop&w=500&q=60',
                                  url + snapshot.data[index].imageUrl,
                                  height: 150,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    snapshot.data[index].title,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    snapshot.data[index].details
                                        .substring(0, 30),
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        snapshot.data[index].category,
                                        style: TextStyle(
                                          backgroundColor: Colors.black12,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        DateFormat("dd-MMM-yyyy").format(
                                            DateTime.parse(
                                                snapshot.data[index].date)),
                                        style: TextStyle(
                                            backgroundColor: Colors.black12,
                                            fontSize: 16.0),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    });
              }
            }));
  }
}
