import 'package:flutter/material.dart';
import 'package:navigation/layout/main_layout.dart';
import 'package:navigation/screen/route_one_screen.dart';

class Home_screen extends StatelessWidget {
  const Home_screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 안드로이드 기기에서 뒤로가기를 눌렀을 때 꺼지는 것 방지
    // WillPopScope에 onWillPop 사용
    // async를 꼭 써주고 함수형으로 작성

    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: MainLayout(title: 'Home Screen', children: [
        ElevatedButton(
          onPressed: () {
            // canPop : 뒤로 갈 페이지가 있으면 true 없으면 false
            print(Navigator.of(context).canPop());
          },
          child: Text('Can Pop'),
        ),
        ElevatedButton(
          onPressed: () {
            // maybePop : 더이상 뒤로 갈 페이지가 없을 때 뒤로가기 할 수가 없음
            // canPop이 true 일 때만 뒤로
            Navigator.of(context).maybePop();
          },
          child: Text('Maybe Pop'),
        ),
        ElevatedButton(
          onPressed: () {
            // maybePop
            Navigator.of(context).pop();
          },
          child: Text('Pop'),
        ),
        ElevatedButton(
          onPressed: () async {
            final result = await Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => RouteOneScreen(
                number: 123,
              ),
            ));
            print(result);
          },
          child: Text(
            'Push',
          ),
        )
      ]),
    );
  }
}
