import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TopNavbar extends StatelessWidget {
  const TopNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(6)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
          )
        ],
      ),
      padding: const EdgeInsets.all(8),
      height: 70,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: PopupMenuButton(
              offset: const Offset(0, 30),
              child: const Row(
                children: [
                  Text("Username"),
                  SizedBox(width: 5),
                  Icon(Icons.people),
                ],
              ),
              itemBuilder: (context) {
                return <PopupMenuEntry>[
                  PopupMenuItem(
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(25),
                        constraints: const BoxConstraints(minWidth: 180),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(),
                            Text("Username"),
                          ],
                        ),
                      ),
                    ),
                  ),
                  PopupMenuItem(
                      child: ListTile(
                    leading: const Icon(Icons.password, color: Colors.grey),
                    title: const Text("Change Password"),
                    onTap: () {},
                  )),
                  PopupMenuItem(
                      child: ListTile(
                    leading: const Icon(
                      Icons.logout,
                      color: Colors.red,
                    ),
                    title: const Text("Logout"),
                    onTap: () => context.go("/auth"),
                  ))
                ];
              },
            ),
          ),
        ],
      ),
    );
  }
}
