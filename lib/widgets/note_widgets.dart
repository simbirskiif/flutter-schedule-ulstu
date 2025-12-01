import 'package:flutter/material.dart';
import 'package:timetable/models/note.dart';
import 'package:timetable/models/lesson.dart';
import 'package:provider/provider.dart';
import 'package:animations/animations.dart';
import 'package:timetable/utils/color_utils.dart';

class NoteWidget extends StatelessWidget {
  final LessonID id;
  final Widget closedBuilder;
  const NoteWidget({super.key, required this.id, required this.closedBuilder});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: OpenContainer(
        transitionDuration: Duration(milliseconds: 500),
        closedElevation: 0,
        closedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        closedColor: ColorScheme.of(context).surfaceVariant,
        closedBuilder: (context, action) =>
            GestureDetector(onTap: action, child: closedBuilder),
        openBuilder: (context, action) =>
            _FullScreenView(action: action, id: id),
      ),
    );
  }
}

class LessonNoteView extends StatelessWidget {
  final LessonID id;
  const LessonNoteView({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 650),
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.only(left: 26, right: 26, top: 10, bottom: 10),
          child: Column(
            children: [
              Selector<LessonNotes, String?>(
                selector: (_, provider) => provider.getNote(id)?.title,
                builder: (context, value, child) {
                  return Text(
                    value ?? "",
                    style: TextStyle(
                      color: textColorForContainer(
                        context,
                        ColorScheme.of(context).surfaceVariant,
                      ),
                      fontSize: 16,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ScheduleNoteView extends StatelessWidget {
  final LessonID id;
  const ScheduleNoteView({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Selector<LessonNotes, String?>(
      selector: (_, provider) => provider.getNote(id)?.content,
      builder: (context, note, child) => Padding(
        padding: EdgeInsets.only(top: 8),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 650),
          child: SizedBox(
            width: double.infinity,
            height: 30,
            child: Material(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              color: ColorScheme.of(context).surfaceVariant,
              child: Padding(
                padding: EdgeInsets.only(left: 6, bottom: 6, right: 2),
                child: Text(
                  note ?? "",
                  style: TextStyle(
                    color: textColorForContainer(
                      context,
                      ColorScheme.of(context).surfaceVariant,
                    ),
                    fontSize: 15,
                  ),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FullScreenView extends StatefulWidget {
  final Function action;
  final LessonID id;
  const _FullScreenView({required this.action, required this.id});

  @override
  State<_FullScreenView> createState() => _FullScreenViewState();
}

class _FullScreenViewState extends State<_FullScreenView> {
  @override
  Widget build(BuildContext context) {
    final notes = Provider.of<LessonNotes>(context, listen: false);
    String content = notes.getNote(widget.id)?.content ?? "";
    String title = notes.getNote(widget.id)?.title ?? "";
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Hero(
          tag: "tag",
          child: Material(
            color: ColorScheme.of(context).surfaceVariant,
            child: SizedBox.expand(
              child: Center(
                child: Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.all(30),
                      child: Column(
                        children: [
                          TextFormField(
                            style: TextStyle(
                              fontSize: 30,
                              color: textColorForContainer(
                                context,
                                ColorScheme.of(context).surfaceVariant,
                              ),
                            ),
                            initialValue: title,
                            onChanged: (value) => title = value,
                          ),
                          Expanded(
                            child: TextFormField(
                              style: TextStyle(
                                color: textColorForContainer(
                                  context,
                                  ColorScheme.of(context).surfaceVariant,
                                ),
                              ),
                              initialValue: content,
                              onChanged: (value) => content = value,
                              expands: true,
                              maxLines: null,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Введите текст заметки',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomRight,
                      margin: EdgeInsets.all(30),
                      child: ElevatedButton(
                        onPressed: () {
                          notes.setContent(widget.id, content, context);
                          notes.setTitle(widget.id, title, context);
                          widget.action();
                        },
                        child: Text("Сохранить"),
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomLeft,
                      margin: EdgeInsets.all(30),
                      child: ElevatedButton(
                        onPressed: () {
                          notes.delNote(widget.id, context);
                          widget.action();
                        },
                        child: Text("Удалить"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
