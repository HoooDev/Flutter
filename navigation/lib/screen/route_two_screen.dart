import 'package:flutter/material.dart';
import 'package:navigation/layout/main_layout.dart';
import 'package:navigation/screen/route_three_screen.dart';

class RouteTwoScreen extends StatelessWidget {
  const RouteTwoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments;
    return Scaffold(
      body: Center(
        child: MainLayout(
          title: 'Route Two',
          children: [
            Text(
              'arguments : $arguments',
              textAlign: TextAlign.center,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Pop')),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  '/three',
                  arguments: 999,
                );
              },
              child: Text('Push Named'),
            ),
            ElevatedButton(
              onPressed: () {
                // pushReplacement -> pop하면 초기화면으로 돌아옴
                // 만약 RouteTwo에서 Three로 가면 Two를 Three로 대체해버림
                Navigator.of(context).pushReplacementNamed(
                  '/three',
                );
              },
              child: Text('Push Replacement'),
            ),
            ElevatedButton(
              onPressed: () {
                // true로 리턴받는 애들은 스택에 저장, false인 애들은 저장 x
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => RouteThreeScreen()),
                    (route) => route.settings.name == '/');
              },
              child: Text('Push And Remove Until'),
            ),
          ],
        ),
      ),
    );
  }
}
