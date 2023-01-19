import 'package:calendar_scheduler/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final String label;

  // true - 시간, false - 내용
  final bool isTime;

  const CustomTextField({Key? key, required this.label, required this.isTime})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: PRIMARY_COLOR,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(
          height: 3.0,
        ),
        if (isTime) renderTextFiled(),
        if (!isTime)
          Expanded(
            child: renderTextFiled(),
          )
      ],
    );
  }

  Widget renderTextFiled() {
    return TextField(
      textAlignVertical: TextAlignVertical(y: -1.0),
      // 깜빡이는 커서 색상 변경
      cursorColor: Colors.grey,
      maxLines: isTime ? 1 : null,
      // 부모의 길이만큼 늘려주기 위해 expands 사용
      expands: !isTime,
      // 텍스트 타입을 boolean 값에 따라 변경 해 줌
      keyboardType: isTime ? TextInputType.number : TextInputType.multiline,
      // 숫자만 적을 수 있게 변경
      inputFormatters: isTime ? [FilteringTextInputFormatter.digitsOnly] : [],
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(width: 0, style: BorderStyle.none)),

        // filled를 true로 해야만 디자인 커스텀이 가능하다.
        filled: true,
        // input 배경색 채우기
        fillColor: Colors.grey[300],
      ),
    );
  }
}
