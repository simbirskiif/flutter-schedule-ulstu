import 'package:flutter/material.dart';
import 'package:loading_indicator_m3e/loading_indicator_m3e.dart';
import 'package:provider/provider.dart';
import 'package:timetable/api/session_manager.dart';

void showFirstSetupDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      // SessionManager manager = Provider.of<SessionManager>(context);
      // bool isLoading = manager.fetchingData;
      // bool isError = !manager.isLoggin;
      // manager.fetchUserData();
      return DialogF();
    },
  );
}

class DialogF extends StatefulWidget {
  const DialogF({super.key});

  @override
  State<DialogF> createState() => _DialogFState();
}

class _DialogFState extends State<DialogF> {
  bool isFirstLoad = true;
  bool isLoading = false;
  bool isError = false;
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    SessionManager manager = Provider.of<SessionManager>(
      context,
      listen: false,
    );
    await Future.delayed(Duration(microseconds: 5));
    isLoading = manager.fetchingData;
    isError = !manager.isLoggin;
    if (isFirstLoad) {
      manager.fetchUserData();
      isFirstLoad = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    SessionManager manager = Provider.of<SessionManager>(context);
    return AlertDialog(
      title: Text(
        "Почти готово",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: ColorScheme.of(context).onSurface,
        ),
      ),
      content: SingleChildScrollView(
        child: Stack(
          children: [
            Column(children: [Text("data"), Text("data"), Text("data")]),
            manager.fetchingData
                ? Positioned.fill(
                    child: Container(
                      color: ColorScheme.of(context).surfaceContainerHigh,
                      child: Center(child: LoadingIndicatorM3E()),
                    ),
                  )
                : Text(""),
            !manager.isLoggin
                ? Positioned.fill(
                    child: Container(
                      color: ColorScheme.of(context).surfaceContainerHigh,
                      child: Center(
                        child: Column(
                          children: [
                            Center(child: Icon(Icons.error)),
                            Text("Произошла ошибка"),
                          ],
                        ),
                      ),
                    ),
                  )
                : Text(""),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () {}, child: Text("Закрыть")),
        !manager.fetchingData && manager.isLoggin
            ? TextButton(onPressed: () {}, child: Text("Готово"))
            : Text(""),
        !manager.isLoggin
            ? TextButton(onPressed: () {}, child: Text("Повторить"))
            : Text(""),
      ],
    );
  }
}
