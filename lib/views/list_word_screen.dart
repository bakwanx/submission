import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

class ListWordScreen extends StatefulWidget {
  const ListWordScreen({Key? key}) : super(key: key);

  @override
  State<ListWordScreen> createState() => _ListWordScreenState();
}

class _ListWordScreenState extends State<ListWordScreen> {
  final _randomWordPairs = <WordPair>[];
  final _savedWordPairs = Set<WordPair>();

  Widget _wordList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, item) {
        if (item.isOdd) return Divider();

        final index = item ~/ 2;

        if (index >= _randomWordPairs.length) {
          _randomWordPairs.addAll(generateWordPairs().take(10));
        }
        return _item(_randomWordPairs[index]);
      },
    );
  }

  Widget _item(WordPair pair) {
    final alreadySaved = _savedWordPairs.contains(pair);
    return ListTile(
      title: Text(pair.asLowerCase, style: TextStyle(fontSize: 18)),
      trailing: Icon(alreadySaved ? Icons.favorite : Icons.favorite_border,
          color: alreadySaved ? Colors.red.shade600 : null),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _savedWordPairs.remove(pair);
          } else {
            _savedWordPairs.add(pair);
          }
        });
      },
    );
  }

  void _saveItem() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          final Iterable<ListTile> tiles = _savedWordPairs.map(
            (WordPair pair) {
              return ListTile(
                title: Text(pair.asPascalCase, style: TextStyle(fontSize: 16)),
              );
            },
          );

          final List<Widget> divided =
              ListTile.divideTiles(context: context, tiles: tiles).toList();

          return Scaffold(
            appBar: AppBar(title: Text('Favorited Word Pairs')),
            body: ListView(children: divided),
          );
        },
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WordPair Generator'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.list),
            onPressed: _saveItem,
          )
        ],
      ),
      body: _wordList(),
    );
  }
}
