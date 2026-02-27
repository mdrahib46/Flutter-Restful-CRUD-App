import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:postapp/model/post_list_model.dart';
import 'package:postapp/services/network_caller.dart';
import 'package:postapp/services/network_response.dart';
import 'package:postapp/urls.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController userIdTEController = TextEditingController();
  final TextEditingController titleTEController = TextEditingController();
  final TextEditingController bodyTEController = TextEditingController();

  List<PostListModel> postList = [];
  bool _inProgress = false;

  Future<void> fetchPost() async {
    setState(() => _inProgress = true);

    final NetworkResponse response =
    await NetworkCaller.getRequest(url: Urls.getPost);

    if (response.isSuccess) {
      final List<dynamic> postListModel = response.responseData;

      setState(() {
        postList =
            postListModel.map((e) => PostListModel.fromJson(e)).toList();
      });
    } else {
      print('Failed to fetch posts: ${response.statusCode}');
    }

    setState(() => _inProgress = false);
  }



  @override
  void initState() {
    fetchPost();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post App', style: TextStyle(fontWeight: FontWeight.w600)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Add Post"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: userIdTEController,
                      decoration: InputDecoration(
                        label: Text('User Id'),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: titleTEController,
                      decoration: InputDecoration(
                        label: Text('Title'),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: bodyTEController,
                      decoration: InputDecoration(
                        label: Text('Body'),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadiusGeometry.circular(8),
                            ),
                          ),
                          child: Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadiusGeometry.circular(8),
                            ),
                          ),
                          child: Text('Submit'),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [

          Expanded(
            child: RefreshIndicator(
              onRefresh: fetchPost,
              child: _inProgress
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: postList.length,
                      itemBuilder: (context, index) {
                        final item = postList[index];

                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: Colors.white12,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            title: Text(
                              'Post Id: ${item.id ?? 0}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.title ?? '',
                                  style: TextStyle(fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis),
                                ),
                                Text(
                                  item.body ?? '',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.justify,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                  TextButton(onPressed: (){}, child: Icon(Icons.remove_red_eye)),
                                  TextButton(onPressed: (){}, child: Icon(Icons.edit)),
                                  TextButton(onPressed: (){}, child: Icon(Icons.delete)),
                                ],)
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
