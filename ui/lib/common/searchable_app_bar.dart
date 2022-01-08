import 'package:flutter/material.dart';

class SearchableAppBar extends StatefulWidget implements PreferredSizeWidget {
  const SearchableAppBar({Key? key}) : super(key: key);

  @override
  State<SearchableAppBar> createState() => _SearchableAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _SearchableAppBarState extends State<SearchableAppBar> {
  late bool isSearching;

  @override
  void initState() {
    super.initState();
    isSearching = false;
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Stack(
      children: [
        AppBar(
          title: Text("Resultados"),
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  isSearching = true;
                });
              },
              icon: Icon(Icons.search),
            )
          ],
        ),
        Align(
          alignment: Alignment.centerRight,
          child: AnimatedContainer(
            alignment: Alignment.center,
            duration: Duration(milliseconds: 150),
            width: isSearching ? mediaQuery.size.width : 0,
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(isSearching ? 0 : 48),
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: AppBar(
              actions: [
                IconButton(
                  onPressed: () {},
                  color: Theme.of(context).colorScheme.onSurface,
                  icon: Icon(Icons.close),
                ),
              ],
              leading: IconButton(
                color: Theme.of(context).colorScheme.onSurface,
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    isSearching = false;
                  });
                },
              ),
              backgroundColor: Theme.of(context).colorScheme.surface,
              title: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
