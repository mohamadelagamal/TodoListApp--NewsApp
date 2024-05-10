import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget buildArticleItem(list,context)=> Padding(
  padding: const EdgeInsets.all(20.0),
  child: Column(
    children: [
      Container(
        width: double.infinity,
        height: 150,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage('${list['urlToImage']}'),
            fit: BoxFit.cover,
          ),
        ),
      ),
      SizedBox(height: 10),
      Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              '${list['title']}',
              style: Theme.of(context).textTheme.bodyText1,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text('${list['description']}', style: TextStyle(color: Colors.grey),maxLines: 2,),
          SizedBox(height: 10),
          Container(
              width: double.infinity,
              alignment: Alignment.centerRight,
              child: Text('${list['publishedAt']}', style: TextStyle(color: Colors.grey),maxLines: 1,)
          ),

        ],
      )
    ],
  ),
);
Widget myDivider()=> Container(
  width: double.infinity,
  height: 1,
  color: Colors.grey[300],
);

Widget articleBuilder(list,context)=>ConditionalBuilder(
  condition: list.length > 0,
  builder: (context) => ListView.separated(
    physics: BouncingScrollPhysics(),
    itemBuilder: (context, index) => buildArticleItem(list[index],context),
    separatorBuilder: (context, index) => myDivider(),
    itemCount: list.length,
  ),
  fallback: (context) => Center(child: CircularProgressIndicator()),
);
void navigateTo(context,widget)=> Navigator.push(context, MaterialPageRoute(builder: (context)=> widget));