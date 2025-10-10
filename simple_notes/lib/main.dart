import 'package:flutter/material.dart';
import 'models/note.dart';
import 'edit_note_page.dart';

void main() => runApp(const SimpleNotesApp());

class SimpleNotesApp extends StatelessWidget {
  const SimpleNotesApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromARGB(255, 89, 61, 64),
        ),
      ),
      home: const NotesPage(),
    );
  }
}

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});
  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  bool _searchActive = false;
  List<Note> _searchList = [];

  final List<Note> _notes = [
    Note(id: '1', title: 'Заметка о важном', body: 'Тело заметки'),
  ];

  Future<void> _addNote() async {
    final newNote = await Navigator.push<Note>(
      context,
      MaterialPageRoute(builder: (_) => EditNotePage()),
    );
    if (newNote != null) {
      setState(() => _notes.add(newNote));
    }
  }

  Future<void> _edit(Note note) async {
    final updated = await Navigator.push<Note>(
      context,
      MaterialPageRoute(builder: (_) => EditNotePage(existing: note)),
    );
    if (updated != null) {
      setState(() {
        final i = _notes.indexWhere((n) => n.id == updated.id);
        if (i != -1) _notes[i] = updated;
      });
    }
  }

  void _delete(Note note) {
    setState(() => _notes.removeWhere((n) => n.id == note.id));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Заметка удалена')));
  }

  Widget _searchBar() {
    return TextField(
      onChanged: (String s) => setState(() {
        _searchList = [];
        for (int i = 0; i < _notes.length; i++) {
          if (_notes[i].title.contains(s)) {
            _searchList.add(_notes[i]);
          }
        }
      }),
      autofocus: true,
      style: TextStyle(fontSize: 16),
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: 'Поиск',
        hintStyle: TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget defaultList() {
    return ListView.separated(
      itemCount: _notes.length,
      separatorBuilder: (context, i) => Divider(),
      itemBuilder: (context, i) {
        final note = _notes[i];
        return Dismissible(
          key: ValueKey(note.id),
          child: ListTile(
            title: Text(note.title.isEmpty ? '(без названия)' : note.title),
            subtitle: Text(
              note.body,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () => _edit(note),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () => _delete(note),
            ),
          ),
          onDismissed: (direction) => _delete(note),
        );
      },
    );
  }

  Widget searchList() {
    return ListView.separated(
      itemCount: _searchList.length,
      separatorBuilder: (context, i) => Divider(),
      itemBuilder: (context, i) {
        final note = _searchList[i];
        return Dismissible(
          key: ValueKey(note.id),
          child: ListTile(
            title: Text(note.title.isEmpty ? '(без названия)' : note.title),
            subtitle: Text(
              note.body,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () => _edit(note),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () => _delete(note),
            ),
          ),
          onDismissed: (direction) => _delete(note),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        title: !_searchActive ? Text('Практика №5') : _searchBar(),
        actions: !_searchActive
            ? [
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () => setState(() {
                    _searchActive = true;
                    _searchList = [];
                  }),
                ),
              ]
            : [
                IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () => setState(() {
                    _searchActive = false;
                  }),
                ),
              ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNote,
        child: const Icon(Icons.add),
      ),
      body: _notes.isEmpty
          ? const Center(child: Text('Пока нет заметок. Нажмите +'))
          : !_searchActive ? defaultList() : searchList(),
    );
  }
}
