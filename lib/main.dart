import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:just_audio/just_audio.dart';
import 'package:minio/minio.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

final minio = Minio(
    endPoint: const String.fromEnvironment("S3_ENDPOINT"),
    accessKey: const String.fromEnvironment("S3_ACCESS_KEY"),
    secretKey: const String.fromEnvironment("S3_SECRET_KEY"));

const bucket = String.fromEnvironment("S3_BUCKET");

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Songster'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 1;
  bool isPlaying = false;
  final player = AudioPlayer(); // Create a player
  String _title = "";
  bool _isScanning = false;

  @override
  void initState() {
    player.playerStateStream.listen((state) {
      setState(() {
        isPlaying = state.playing;
      });
    });
    super.initState();
    setSong(1);
  }

  @override
  Future<void> _setUrl(String? url) async {
    if (url!.isEmpty) {
      return;
    }

    final regex = new RegExp('www.hitstergame.com/[a-z]{2}/[0-9]{5}');
    if (regex.hasMatch(url)) {
      final splitted = url.split("/");
      final c = int.parse(splitted[2]);

      setState(() {
        _counter = c;
        isPlaying = false;
      });

      await setSong(c);
    }
  }

  Future<void> setSong(int counter) async {
    var padded = "$counter".padLeft(5, "0");
    var val = await minio.presignedGetObject(bucket, 'fr/$padded.m4a',
        expires: 60 * 15);
    print(val);
    final duration = await player.setUrl(val);
    await player.setVolume(1.0);
  }

  Future<void> play() async {
    await player.play();
  }

  Future<void> stop() async {
    await player.stop();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Builder(builder: (context) {
              if (_isScanning) {
                return SizedBox(
                    height: 400,
                    child: MobileScanner(
                      onDetect: (capture) async {
                        setState(() {
                          _isScanning = false;
                        });
                        final List<Barcode> barcodes = capture.barcodes;
                        for (final barcode in barcodes) {
                          await _setUrl(barcode.rawValue);
                        }
                      },
                    ));
              }

              return TextButton(
                onPressed: () {
                  setState(() {
                    _isScanning = true;
                  });
                },
                child: const Text("Scanner"),
              );
            }),
            Text(
              _title,
            ),
            // Text(
            //   'Title: $_counter',
            //   style: Theme.of(context).textTheme.headlineMedium,
            // ),
            FloatingActionButton(
              onPressed: isPlaying ? stop : play,
              tooltip: 'Play/Stop',
              child: Icon(isPlaying ? Icons.stop : Icons.play_arrow),
            ), // This trai
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: setUrl,
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
