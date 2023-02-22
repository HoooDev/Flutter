import 'package:calendar_scheduler/component/custom_text_field.dart';
import 'package:calendar_scheduler/const/colors.dart';
import 'package:calendar_scheduler/database/drift_database.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class ScheduleBottomSheet extends StatefulWidget {
  final DateTime selectedDate;
  final int? scheduleId;

  const ScheduleBottomSheet({
    Key? key,
    required this.selectedDate,
    this.scheduleId,
  }) : super(key: key);

  @override
  State<ScheduleBottomSheet> createState() => _ScheduleBottomSheetState();
}

class _ScheduleBottomSheetState extends State<ScheduleBottomSheet> {
  final GlobalKey<FormState> formKey = GlobalKey();

  int? startTime;
  int? endTime;
  String? content;
  int? selectedColorId;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return GestureDetector(
      onTap: () {
        // 현재 포커스가 된 텍스트 필드에서 포커스를 없앨 수 있다.
        // FocusNode안에 실제 텍스트 필드와 연결 된 FocusNode를 넣는다면 그쪽으로 이동하게 됨.
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: FutureBuilder<Schedule>(
          future: widget.scheduleId == null
              ? null
              : GetIt.I<LocalDatabase>().getScheduleById(widget.scheduleId!),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text('스케쥴을 불러올 수 없습니다.'),
              );
            }

            // FutureBuilder가 처음 실행 됐고,
            // 로딩 중 일때
            if (snapshot.connectionState != ConnectionState.none &&
                !snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            // Future가 실행 되고
            // 값이 있는데 단 한번도 startTime이 세팅되지 않았을 때
            if (snapshot.hasData && startTime == null) {
              startTime = snapshot.data!.startTime;
              endTime = snapshot.data!.endTime;
              content = snapshot.data!.content;
              selectedColorId = snapshot.data!.colorId;
            }

            return SafeArea(
              child: Container(
                color: Colors.white,
                height: MediaQuery.of(context).size.height / 2 + bottomInset,
                child: Padding(
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 8.0,
                      right: 8.0,
                      top: 16.0,
                    ),
                    child: Form(
                      key: formKey,
                      // autovalidateMode: AutovalidateMode.always,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _Time(
                            onStartSaved: (String? val) {
                              startTime = int.parse(val!);
                            },
                            onEndSaved: (String? val) {
                              endTime = int.parse(val!);
                            },
                            startInitialValue: startTime?.toString() ?? '',
                            endInitialValue: endTime?.toString() ?? '',
                          ),
                          const SizedBox(
                            height: 16.0,
                          ),
                          _Content(
                            onSaved: (String? val) {
                              content = val;
                            },
                            initialValue: content ?? '',
                          ),
                          const SizedBox(
                            height: 16.0,
                          ),
                          FutureBuilder<List<CategoryColor>>(
                              future:
                                  GetIt.I<LocalDatabase>().getCategoryColors(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData &&
                                    selectedColorId == null &&
                                    snapshot.data!.isNotEmpty) {
                                  selectedColorId = snapshot.data![0].id;
                                }
                                return _ColorPicker(
                                  colorIdSetter: (int id) {
                                    setState(() {
                                      selectedColorId = id;
                                    });
                                  },
                                  colors:
                                      snapshot.hasData ? snapshot.data! : [],
                                  selectedColorId: selectedColorId,
                                );
                              }),
                          const SizedBox(
                            height: 8.0,
                          ),
                          _SaveButton(
                            onPressed: onSavePressed,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }

  void onSavePressed() async {
    if (formKey.currentState == null) {
      return;
    }

    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      if (widget.scheduleId == null) {
        await GetIt.I<LocalDatabase>().createSchedule(
          SchedulesCompanion(
              date: Value(widget.selectedDate),
              startTime: Value(startTime!),
              endTime: Value(endTime!),
              content: Value(content!),
              colorId: Value(selectedColorId!)),
        );
      } else {
        await GetIt.I<LocalDatabase>().updateScheduleById(
          widget.scheduleId!,
          SchedulesCompanion(
            date: Value(widget.selectedDate),
            startTime: Value(startTime!),
            endTime: Value(endTime!),
            content: Value(content!),
            colorId: Value(selectedColorId!),
          ),
        );
      }

      Navigator.of(context).pop();
      print('SAVE 완료');
    } else {
      print('Error');
    }
  }
}

class _Time extends StatelessWidget {
  final FormFieldSetter<String> onStartSaved;
  final FormFieldSetter<String> onEndSaved;
  final String startInitialValue;
  final String endInitialValue;

  const _Time({
    Key? key,
    required this.onStartSaved,
    required this.onEndSaved,
    required this.startInitialValue,
    required this.endInitialValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomTextField(
            label: '시작 시간',
            isTime: true,
            onSaved: onStartSaved,
            initialValue: startInitialValue,
          ),
        ),
        const SizedBox(
          width: 16.0,
        ),
        Expanded(
          child: CustomTextField(
            label: '마감 시간',
            isTime: true,
            onSaved: onEndSaved,
            initialValue: endInitialValue,
          ),
        ),
      ],
    );
  }
}

class _Content extends StatelessWidget {
  final FormFieldSetter<String> onSaved;
  final String initialValue;

  const _Content({
    Key? key,
    required this.onSaved,
    required this.initialValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CustomTextField(
        label: '내용',
        isTime: false,
        onSaved: onSaved,
        initialValue: initialValue,
      ),
    );
  }
}

typedef ColorIdSetter = void Function(int id);

class _ColorPicker extends StatelessWidget {
  final List<CategoryColor> colors;
  final int? selectedColorId;
  final ColorIdSetter colorIdSetter;

  const _ColorPicker({
    Key? key,
    required this.colors,
    required this.selectedColorId,
    required this.colorIdSetter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      // 요소들 끼리의 거리
      spacing: 8.0,
      // Row끼리 위 아래로 띄워야 하는 거리
      runSpacing: 10.0,
      children: colors
          .map((e) => GestureDetector(
                onTap: () {
                  colorIdSetter(e.id);
                },
                child: renderColor(e, selectedColorId == e.id),
              ))
          .toList(),
    );
  }

  Widget renderColor(CategoryColor color, bool isSelected) {
    return Container(
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Color(
            int.parse('FF${color.hexCode}', radix: 16),
          ),
          border: isSelected
              ? Border.all(
                  color: Colors.black,
                  width: 4.0,
                )
              : null),
      width: 32.0,
      height: 32.0,
    );
  }
}

class _SaveButton extends StatelessWidget {
  final VoidCallback onPressed;
  const _SaveButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 전체를 차지하고 싶다면 Row로 감싸고 Expanded
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(backgroundColor: PRIMARY_COLOR),
            child: const Text('저장'),
          ),
        ),
      ],
    );
  }
}
