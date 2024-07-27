import 'package:flutter/material.dart';

class MenuBarView extends StatefulWidget implements PreferredSizeWidget {
  const MenuBarView({
    super.key,
    required this.message,
  });
  @override
  Size get preferredSize => const Size.fromHeight(100);
  final String message;

  @override
  State<MenuBarView> createState() => _MenuBarViewState();
}

class _MenuBarViewState extends State<MenuBarView> {
  final FocusNode _buttonFocusNode = FocusNode(debugLabel: 'Menu');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Productos_app"), 
 // Removed const for dynamic text
        leading: MenuAnchor(
          builder: (BuildContext context, MenuController controller,
              Widget? child) {
            return IconButton(
              focusNode: _buttonFocusNode,
              icon: Icon(
                Icons.menu, // Replaced icon with hamburger menu icon
                color: Colors.white,
              ),
              onPressed: () {
                if (controller.isOpen) {
                  controller.close();
                } else {
                  controller.open();
                }
              },
            );
          },
          childFocusNode: _buttonFocusNode,
          menuChildren: <Widget>[
            Column(
              children: [
                const Divider(),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: const Text(
                      "Opciones",
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
                      child: Icon(
                        Icons.person,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      children: [
                        MenuItemButton(
                          child: const Text("Productos"),
                          onPressed: () => Navigator.pushNamed(context, '/dashboard'),
                        ),
                        MenuItemButton(
                          child: const Text("Mapa"),
                          onPressed: () => Navigator.pushNamed(context, '/map'),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}