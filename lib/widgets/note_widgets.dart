import 'package:flutter/material.dart';
import 'package:timetable/models/note.dart';
import 'package:timetable/models/lesson.dart';
import 'package:provider/provider.dart';
import 'package:animations/animations.dart';

class NoteWidget extends StatelessWidget {
  final LessonID id;
  final Widget closedBuilder;
  const NoteWidget({super.key, required this.id, required this.closedBuilder});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, bottom: 0, top: 4),
      child: OpenContainer(
        transitionDuration: Duration(milliseconds: 500),
        closedElevation: 0,
        closedShape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(8),
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

class GeneralNoteView extends StatefulWidget {
  final LessonID id;
  const GeneralNoteView({super.key, required this.id});

  @override
  State<GeneralNoteView> createState() => _GeneralNoteViewState();
}

class _GeneralNoteViewState extends State<GeneralNoteView> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 16),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Selector<LessonNotes, String?>(
                selector: (_, provider) => provider.getNote(widget.id)?.title,
                builder: (context, value, child) {
                  return Text(
                    value ?? "",
                    style: TextStyle(color: Colors.white, fontSize: 16),
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

class LessonNoteView extends StatefulWidget {
  final LessonID id;
  const LessonNoteView({super.key, required this.id});

  @override
  State<LessonNoteView> createState() => _LessonNoteViewState();
}

class _LessonNoteViewState extends State<LessonNoteView> {
  @override
  Widget build(BuildContext context) => Selector<LessonNotes, String?>(
    selector: (_, provider) => provider.getNote(widget.id)?.content,
    builder: (context, noteName, child) => Padding(
      padding: EdgeInsets.only(top: 8),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 650),
        child: SizedBox(
          width: double.infinity,
          height: 40,
          child: Material(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            color: ColorScheme.of(context).surfaceVariant,
            child: Padding(
              padding: EdgeInsetsGeometry.all(6),
              child: Text(
                noteName ?? "",
                style: TextStyle(color: Colors.white, fontSize: 20),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class _FullScreenView extends StatefulWidget {
  final Function action;
  final LessonID id;
  const _FullScreenView({super.key, required this.action, required this.id});

  @override
  State<_FullScreenView> createState() => _FullScreenViewState();
}

class _FullScreenViewState extends State<_FullScreenView> {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<LessonNotes>(context, listen: false);
    String content = model.getNote(widget.id)?.content ?? "";
    String title = model.getNote(widget.id)?.title ?? "";
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
                            style: TextStyle(fontSize: 30, color: Colors.white),
                            initialValue: title,
                            onChanged: (value) => title = value,
                          ),
                          Expanded(
                            child: TextFormField(
                              style: TextStyle(color: Colors.white),
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
                          model.setContent(widget.id, content);
                          model.setTitle(widget.id, title);
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
                          model.delNote(widget.id);
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
