import 'package:calendar_scheduler/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String initialValue;
  // true - 시간, false - 내용
  final bool isTime;
  final FormFieldSetter<String> onSaved;

  const CustomTextField({
    Key? key,
    required this.label,
    required this.isTime,
    required this.onSaved,
    required this.initialValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: PRIMARY_COLOR,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(
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
    return TextFormField(
      // Form
      onSaved: onSaved,
      // null이 return 되면 에러가 없다.
      // 에러가 있으면 에러를 String 값으로 리턴해준다.
      validator: (String? val) {
        if (val == null || val.isEmpty) {
          return '값을 입력해주세요.';
        }

        if (isTime) {
          int time = int.parse(val);

          if (time < 0) {
            return '0이상의 숫자를 입력해주세요.';
          }
          if (time > 24) {
            return '24 이하의 숫자를 입력해주세요';
          }
        } else {
          if (val.length > 500) {
            return '500자 이하의 글자를 입력해주세요';
          }
        }

        return null;
      },

      textAlignVertical: const TextAlignVertical(y: -1.0),
      // 깜빡이는 커서 색상 변경
      cursorColor: Colors.grey,
      maxLines: isTime ? 1 : null,
      // 부모의 길이만큼 늘려주기 위해 expands 사용
      expands: !isTime,
      //
      initialValue: initialValue,
      // 텍스트 타입을 boolean 값에 따라 변경 해 줌
      keyboardType: isTime ? TextInputType.number : TextInputType.multiline,
      // 숫자만 적을 수 있게 변경
      inputFormatters: isTime ? [FilteringTextInputFormatter.digitsOnly] : [],
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(width: 0, style: BorderStyle.none)),

        // filled를 true로 해야만 디자인 커스텀이 가능하다.
        filled: true,
        // input 배경색 채우기
        fillColor: Colors.grey[300],
        suffixText: isTime ? '시' : null,
      ),
    );
  }
}
