import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Button'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // -------------ElevatedButton------------
            ElevatedButton(
              onPressed: () {},
              child: Text('ButtonStyle'),
              style: ButtonStyle(
                // Material State
                // hovered - 호버링 상태 (마우스 커서를 올려놓은 상태)
                // focused - 포커스 됐을 때 (테스트 필드)
                // pressed - 눌렀을 때
                // dragged - 드래그 됐을 때
                // selected - 선택 됐을 때 (체크박스, 라디오 버튼)
                // scrolledUnder - 다른 컴포넌트 밑으로 스크롤링 됐을 때
                // disabled - 비활성화 됐을 때
                // error - 에러상태

                  backgroundColor: MaterialStateProperty.all(
                    Colors.black,
                  ),
                  // 특성 상태에 따른 다른 상태를 리턴해주고 싶다면 resolveWith
                  foregroundColor: MaterialStateProperty.resolveWith(
                          (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed)) {
                          return Colors.white;
                        }
                        return Colors.red;
                      }),
                  padding: MaterialStateProperty.resolveWith((states) {
                    if(states.contains(MaterialState.pressed)){
                      return EdgeInsets.all(100.0);
                    }
                    return EdgeInsets.all(20.0);
                  })
              ),
            ),

            // -------------ElevatedButton------------
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                // 메인 색
                backgroundColor: Colors.red,
                // 글자 및 애니메이션 색
                foregroundColor: Colors.black,
                // 그림자 색
                shadowColor: Colors.green,
                // 입체감의 높이
                elevation: 10.0,
                // 글자
                textStyle: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 20.0,
                ),
                padding: EdgeInsets.all(32.0),
                // 테두리 조절
                side: BorderSide(
                  color: Colors.black,
                  width: 4.0,
                ),
              ),
              child: Text(
                'ElevatedButton',
              ),
            ),
            // -------------OutlinedButton------------
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.green,
                backgroundColor: Colors.yellow,
              ),
              child: Text(
                'OutlinedButton',
              ),
            ),
            // -------------TextButton------------
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(foregroundColor: Colors.brown),
              child: Text(
                'TextButton',
              ),
            )
          ],
        ),
      ),
    );
  }
}
