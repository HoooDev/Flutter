import 'package:calendar_scheduler/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  // 초기화 됐는지 확인(원래는 runApp 실행이 되면 이 코드가 실행이 되는데 우리가 runApp전에
  // nitializeDateFormatting을 실행하기 때문에 또 한번의 초기화를 해줘야 한다
  WidgetsFlutterBinding.ensureInitialized();

  // 만약 runApp전에 다른 코드를 실행하려면 플러터 프레임워크가 준비 된 상태인지 확인 해야함 ↑
  await initializeDateFormatting();

  runApp(
    MaterialApp(
      theme: ThemeData(
        fontFamily: 'NotoSans'
      ),
      home: HomeScreen(),
    )
  );
}
