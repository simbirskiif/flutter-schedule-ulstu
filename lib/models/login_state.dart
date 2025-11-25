// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:timetable/enum/online_status.dart';

class LoginState {
  String? ams = "";
  OnlineStatus loginStates;
  LoginState({required this.ams, required this.loginStates});

  @override
  String toString() => 'LoginState(ams: $ams, loginStates: $loginStates)';
}
