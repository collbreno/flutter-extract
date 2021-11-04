import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class PageTransitionDemo extends StatelessWidget {
  const PageTransitionDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final milliseconds = 300;

    return Scaffold(
      appBar: AppBar(
        title: Text('Page Transition'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: Text('Custom'),
              onPressed: () {
                Navigator.push(
                  context,
                  PageTransition(
                    child: _Page2(),
                    type: PageTransitionType.size,
                    alignment: Alignment.bottomCenter,
                    duration: Duration(milliseconds: milliseconds),
                    reverseDuration: Duration(milliseconds: milliseconds),
                    curve: Curves.easeInOutQuart,
                  ),
                );
              },
            ),
            ElevatedButton(
              child: Text('Normal'),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => _Page2()));
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _Page2 extends StatelessWidget {
  const _Page2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      appBar: AppBar(
        title: Text('Page 2'),
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (ctx, i) {
          return ListTile(
            title: Text('Item $i'),
          );
        },
      ),
    );
  }
}
