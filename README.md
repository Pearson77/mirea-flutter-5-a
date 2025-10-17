# Практическая работа №5

## Работа со списками. Передача данных между модулями.

### Виджет строки поиска:
```dart
  Widget searchBar() {
    return TextField(
      onChanged: (String s) => setState(() {
        searchNotesList = [];
        for (int i = 0; i < notes.length; i++) {
          if (notes[i].title.contains(s)) {
            searchNotesList.add(notes[i]);
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
```

### Виджет списка заметок:
```dart
  Widget notesList() {
    return ListView.separated(
      itemCount: notes.length,
      separatorBuilder: (context, i) => Divider(),
      itemBuilder: (context, i) {
        final note = notes[i];
        return Dismissible(
          key: ValueKey(note.id),
          child: ListTile(
            title: Text(note.title.isEmpty ? '(без названия)' : note.title),
            subtitle: Text(
              note.body,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () => editNote(note),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () => deleteNote(note),
            ),
          ),
          onDismissed: (direction) => deleteNote(note),
        );
      },
    );
  }
```

### Виджет списка заметок при поиске
Состояние зависит от переменной `searchNotesList`
```dart
  Widget findNotesList() {
    return ListView.separated(
      itemCount: searchNotesList.length,
      separatorBuilder: (context, i) => Divider(),
      itemBuilder: (context, i) {
        final note = searchNotesList[i];
        return Dismissible(
          key: ValueKey(note.id),
          child: ListTile(
            title: Text(note.title.isEmpty ? '(без названия)' : note.title),
            subtitle: Text(
              note.body,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () => editNote(note),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () => deleteNote(note),
            ),
          ),
          onDismissed: (direction) => deleteNote(note),
        );
      },
    );
  }
```

### Список заметок
<img width="2880" height="1551" alt="image" src="https://github.com/user-attachments/assets/2d1ea12c-3990-44b4-a189-771df357722a" />

### Создание
<img width="2880" height="1549" alt="image" src="https://github.com/user-attachments/assets/b0285464-cc12-41f4-af80-98955d8f0c53" />

### Редактирование
<img width="2880" height="1546" alt="image" src="https://github.com/user-attachments/assets/a6d44841-6a6a-4843-87a5-bf0d3b9c76fa" />

### Удаление
<img width="2880" height="1552" alt="image" src="https://github.com/user-attachments/assets/7e39189b-7b03-4c77-bcfc-37c756c69cbe" />
<img width="2880" height="1552" alt="image" src="https://github.com/user-attachments/assets/ac7757fe-fe54-4de0-902a-c532aab6f1f0" />

