# Flutter

**문법**

int → 정수형

double → 실수형

String → 문자형

**var와 String의 차이**

- var → 자동으로 형 유추
- String → 문자형

dynamic → 어떤 타입이든 넣을 수 있다.

**var와 dynamic의 차이**

- dynamic은 형 변환이 자유로움 (var는 선언 후 다른 타입으로 변환이 불가능함)

**List → map**

- Map 변수명 = array.asMap()

**map에서 key, value 꺼내기**

- 변수명.keys
- 변수명.values
    - 변수명.keys.toList() → 리스트 형태로 반환
    - 변수명.keys.toList() → 리스트 형태로 반환

**List → Set**

Set 변수명 → Set.from(array) 

**where**

```dart
void main(){
List<Map<String, String>> people = [
    {
      'name': '로제',
      'group': '블랙핑크',
    },
    {
      'name': '제니',
      'group': '블랙핑크',
    },
    {
      'name': 'rm',
      'group': '블랙핑크',
    },
    {
      'name': '뷔',
      'group': '블랙핑크',
    },
  ];
}

final blackPink = people.where( (x) => x['group'] == '블랙핑크' ).toList();

// 출력 -> [{'name': '로제', 'group': '블랙핑크'}, {'name': '제니', 'group': '블랙핑크'}]
```

**reduce(누적 함수)**

- 리스트의 타입과 리턴의 타입이 같아야 함

```dart
void main() {
  
  List<int> numbers = [
    1,
    3,
    5,
    7,
    9
  ];
  
  final result = numbers.reduce((prev, next){
    print('---------');
    print('previous : $prev');
    print('next : $next');
    print('total : ${prev + next}');
    
    return prev + next;
  });
  
  print(result);

}

// 출력 
---------
previous : 1
next : 3
total : 4
---------
previous : 4
next : 5
total : 9
---------
previous : 9
next : 7
total : 16
---------
previous : 16
next : 9
total : 25
25

// 리턴 한 값이 prev에 계속 들어가게 됨
```

**fold**

- 리스트의 타입과 리턴의 타입이 다르게 가능

```dart
final sum = numbers.fold<int>(초기값, (누적값, 다음값) {});
```

**비동기 프로그래밍**

**Future**

```dart
void main() async {
  // Future - 미래
  // 미래에 받아올 값

  Future<String> name = Future.value('Hoo');
  Future<int> number = Future.value(1);
  Future<bool> isTrue = Future.value(true);

  await addNumbers(1, 1);
  await addNumbers(2, 2);
}

Future<void> addNumbers(int number1, int number2) async {
  print('계산 시작 : $number1 + $number2');

  // 서버 시뮬레이션
  await Future.delayed(Duration(seconds: 2), () {
    print('계산 완료 : $number1 + $number2 = ${number1 + number2}');
  });

  print('함수 완료');
}
```

**Stream**

```dart
import 'dart:async';

void main() async {
  final controller = StreamController();
  // 리스닝을 여러번 하고 싶으면 asBroadcastStream() 사용
  final stream = controller.stream.asBroadcastStream();

  // 조건을 추가해 줄 수 있음
  final streamListener1 = stream.where((val) => val % 2 == 0).listen((val) {
    print('Listener 1 : $val');
  });

  final streamListener2 = stream.where((val) => val % 2 == 1).listen((val) {
    print('Listener 2 : $val');
  });

  controller.sink.add(1);
  controller.sink.add(2);
  controller.sink.add(3);
  controller.sink.add(4);
  controller.sink.add(5);
}
```

```dart
import 'dart:async';

void main() {
  calculate(2).listen((val) {
    print('calculate(2) : $val');
  });

  calculate(4).listen((val) {
    print('calculate(4) : $val');
  });

  playAllStream().listen((val) {
    print(val);
  });
}

// 만약 calculate(2)가 끝나고 calculate(4)를 실행하고 싶다면?
Stream<int> playAllStream() async* {
  // yield는 값을 하나하나 가져오는데 *을 붙이면 모든 값을 가져올때까지 기다려 줌
  yield* calculate(1);
  yield* calculate(1000);
}

// async 대신 async*, return 대신 yield
Stream<int> calculate(int number) async* {
  for (int i = 0; i < 5; i++) {
    yield i * number;

    await Future.delayed(Duration(seconds: 1));
  }
}
```

**nullable과 non-nullable (?가 핵심)**

```dart
String name = '이건후';
name = null // 불가능
print(name);

String? name2 = '후건이';
name2 = null; // 이건 가능
print(name2)

// !는 null이 될 수 없음을 의미
```

**final과 const**

```dart
// final로 선언하면 다시 변수 변경 불가능
final String name = '이건후';

// const도 선언하면 다시 변수 변경 불가능
const String name2 = '후건이';

// 둘 다 타입 생략 가능
final name = '이건후';

const name2 = '후건이';

// 빌드 타임의 값을 몰라도 가능.
final DateTime now = DateTime.now();
// 빌드 타임의 값을 알고 있어야함 즉, 코드가 실행 되기 전엔 그 값을 알 수 없다.
const DateTime now = DateTime.now();
```

**Operators**

```dart
// number가 null이면 3.0으로 바꿔라 라는 뜻
number ??= 3.0;
```

**Class and Widget**

Class → 객체가 가져야 하는 속성과 기능을 정의한 내용을 담고 있는 설계도 역할

객체 → 클래스가 정의된 후 메모리상에 할당되었을 때 이를 객체라고 함

인스턴스 → 클래스를 기반으로 생성, 클래스의 속성과 기능을 똑같이 가지고 있고 프로그래밍 상에서 사용되는 대상

**Static**

- 인스턴스에 귀속되지 않고, 클래스 통째로 귀속
- 함수 또는 변수가 통째로 클래스에 귀속

ex)

```dart
class Employee {
	static String building;
	String name;
	
	Employee(
	String name,
):this.name = name;

	void NameAndBuilding(){
		print(${this.name}, {building};
	}
}
```

- building 변수에만 static 사용. (static은 클래스에 귀속 되므로 this 사용 불가능)

**Widget 이론**

- Widget은 모두 ‘불변’의 법칙을 갖고있다.
- 하지만 위젯의 값을 변경해야 할 때가 있다.(색 변경 등)
- 변경이 필요하면 기존 위젯을 삭제해버리고 새로운 위젯으로 대체한다.

**StatelessWidget 라이프 사이클**

- Constructor로 생성이 되고 생성이 되자마자 build 함수가 실행된다.
- 이전 container 예제와 마찬가지로 변경이 필요하면 새로운 위젯을 만들어버린다.
- 하나의 StatelessWidget은 라이프 사이클 동안 단 한번만 build 함수를 실행한다.

```dart
class Person {
  // 클래스에서 정의한 변수는 *멤버변수*
  String? name;
  int? age;
  String? gender;

  // 생성자는 함수의 모양을 가지고 있다.
  // named argument {}로 인자 묶기
  Person({String? name, int? age, String? gender}) {
    // this.name이 멤버변수임을 알려줌 즉, 들어온 인자를 멤버변수에 할당
    this.name = name;
    this.age = age;
    this.gender = gender;
  }
}

void main() {
	// named argument로 객체 생성
  Person p1 = new Person(age:26);
  Person p2 = new Person(gender:'male');

  print(p1.age);
  print(p2.gender);
}
```

참고 - [플러터(flutter) 순한 맛 강좌 5 | 플러터에서 제일 중요하다는 위젯이란 무엇일까요?](https://www.youtube.com/watch?v=jI4kqLdqXic&list=PLQt_pzi-LLfpcRFhWMywTePfZ2aPapvyl&index=6)

**위젯들의 타입**

1. **Stateless Widget(상태가 없는 정적인 위젯)**
    - Stateful → Value 값을 지속적으로 추적 보존
    - Stateless → 이전 상호작용의 어떠한 값도 저장하지 않음
    - 스크린상에 존재만 할 뿐 아무것도 하지 않음
    - 어떠한 실시간 데이터도 저장하지 않음
    - 어떤 변화(모양, 상태)를 유발시키는 value값을 가지지 않음
2. **Stateful Widget(계속 움직임이나 변화가 있는 위젯)**
    
    

Flutter Widget tree

1. Widget들은 tree 구조로 정리될 수 있음
2. 한 Widget내에 얼마든지 다른 widget들이 포함될 수 있음
3. Widget은 부모 위젯과 자식 위젯으로 구성
4. Parent widget을 widget container라고 부르기도 함

참고 - ****[플러터(flutter) 순한 맛 강좌 6 | 플러터 프로젝트 폴더와 기본 코드 이해하기 1](https://www.youtube.com/watch?v=b5wbsJFXVTM&list=PLQt_pzi-LLfpcRFhWMywTePfZ2aPapvyl&index=7)****

pubspec.yaml

- 프로젝트의 메타데이터를 정의하고 관리하는 것 (버전, 사용환경, dart의 버전, dependency, thirdparty library 등 을 정의)

클래스 명과 함수 명

- main(), runApp() → 첫글자 소문자, 즉 함수명
- MyApp() → 첫글자 대문자, 즉 클래스 명 camel case
- Scaffold→ 빈 도화지 같은 앱 화면에 다양한 요소를 배치 할 수 있음
- children: <Widget>[]와 children: []의 차이?
    - 전자는 List에 들어가는 type을 Widget으로 명시해 준 것, 후자는 dynamic

leading → 아이콘 버튼이나 간단한 위젯을 왼쪽에 배치할 때 

actions → 복수의 아이콘 버튼 등을 오른쪽에 배치할 때

onPressed → 함수의 형태로 일반 버튼이나 아이콘 버튼을 터치했을 때 일어나는 이벤트를 정의

**스낵바 구현**

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Snack Bar',
      theme: ThemeData(primarySwatch: Colors.red),
      home: MyPage(),
    );
  }
}

class MyPage extends StatelessWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Snack Bar'),
        centerTitle: true,
      ),
      body: Center(
        child: TextButton(
          child: Text(
            'Show me',
            style: TextStyle(
              color: Colors.blue,
              fontSize: 30,
            ),
          ),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                'Hello',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white
                ),
              ),
							// 스낵바 배경색
              backgroundColor: Colors.teal,
							// 스낵바 나타나는 시간
              duration: Duration(milliseconds: 1000),
            ));
          },
        ),
      ),
    );
  }
}
```

**토스트바 구현**

```dart
// pubspec.yaml (fluttertoast 추가)
flutter:
    sdk: flutter
  # The following adds the Cupertino Icons font to your application.
  # Use with the CupertinoIcons class for iOS style icons.
  cupertino_icons: ^1.0.2
  fluttertoast: ^8.0.9

// main.dart
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Toast',
      home: MyPage(),
    );
  }
}

class MyPage extends StatelessWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Toast Message'),
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            flutterToast();
          },
          child: Text('Toast'),
        ),
      ),
    );
  }
}

void flutterToast() {
  Fluttertoast.showToast(
      msg: "This is Center Short Toast",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0
  );
}
```

**현재 날짜와 특정 날짜의 비교**

```dart
void main() {
  
  DateTime now = DateTime.now();
  
  DateTime specificDay = DateTime(
    2022,
    09,
    18,
  );
  print(specificDay);
  
  final difference = now.difference(specificDay);
  print(difference);
  print(difference.inDays);
	
	// isAfter, isBefore (현재에 비해 과거인지 미래인지 boolean값으로 확인)
	print(now.isAfter(specificDay));
  print(now.isBefore(specificDay));

	// now에 10시간 더하고 빼기
	print(now.add(Duration(hours:10)));
  print(now.add(Duration(hours:10)));
}
```

```
classEmployee {
staticString building;
  String name;

  Employee(String name,) :this.name = name;

voidNameAndBuilding() {
    print(${this.name}, {building};
    }
}
```