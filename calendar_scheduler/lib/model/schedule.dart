import 'package:drift/drift.dart';

class Schedules extends Table {
  // integer는 함수를 리턴하기 때문에 ()를 한번 더 붙여준다.
  // id 컬럼 = PK
  IntColumn get id => integer().autoIncrement()();

  // 내용
  TextColumn get content => text()();

  // 일정 날짜
  DateTimeColumn get date => dateTime()();

  // 시작 시간
  IntColumn get startTime => integer()();

  // 끝 시간
  IntColumn get endTime => integer()();

  // Category Color Table ID
  IntColumn get colorId => integer()();

  // 생성 날짜
  DateTimeColumn get createdAt => dateTime().clientDefault(
        () => DateTime.now(),
      )();
}
