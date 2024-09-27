import 'package:animate_gradient/animate_gradient.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:minio/minio.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:songster/ui/theme.dart';
import 'package:songster/views/game.dart';
import 'package:songster/views/home.dart';
import 'package:songster/views/widgets/gradient_background.dart';

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
      title: 'Songster',
      theme: theme,
      routes: {
        '/': (context) => Home(),
        '/game': (context) => const Game(),
      },
      builder: (context, child) => Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(),
          body: GradientBackground(
            child: child!,
          )),
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
  int _counter = 0;
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

  bool get songScanned => _counter > 1;

  String get songCode => "$_counter".padLeft(5, "0");

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      // appBar: AppBar(
      //   // TRY THIS: Try changing the color here to a specific color (to
      //   // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
      //   // change color while the other colors stay the same.
      //   backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      //   // Here we take the value from the MyHomePage object that was created by
      //   // the App.build method, and use it to set our appbar title.
      //   title: Text(widget.title),
      // ),
      body: AnimateGradient(
        duration: const Duration(seconds: 10),
        primaryBeginGeometry: const AlignmentDirectional(0, 4),
        primaryEndGeometry: const AlignmentDirectional(0, 4),
        secondaryBeginGeometry: const AlignmentDirectional(2, 0),
        secondaryEndGeometry: const AlignmentDirectional(0, -0.8),
        textDirectionForGeometry: TextDirection.rtl,
        reverse: true,
        primaryColors: const [
          Color(0xFF000000),
          Color(0xFF24213E),
          Color(0xFF39223F),
          Color(0xFF552441),
          Color(0xFFBC6538),
          Color(0xFFA9345D),
          Color(0xFFBF4487),
        ],
        secondaryColors: const [
          Color(0xFFC7267D),
          Color(0xFFA6397C),
          Color(0xFF943A6E),
          Color(0xFF943A6E),
          Color(0xFF3C0F38),
          Color(0xFF270D30),
          Color(0xFF110729),
        ],
        child: Center(
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
              if (songScanned)
                Container(
                  margin: const EdgeInsets.all(12),
                  color: Colors.white,
                  child: QrImageView(
                    data: 'www.hitstergame.com/fr/$songCode',
                    version: QrVersions.auto,
                    size: 200.0,
                  ),
                ),
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
                      _counter = 0;
                      _isScanning = true;
                    });
                  },
                  style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.white),
                      foregroundColor: WidgetStatePropertyAll(Colors.black)),
                  child: const Text("Scanner"),
                );
              }),
              Text(
                _title,
              ),

              if (songScanned)
                FloatingActionButton(
                  onPressed: isPlaying ? stop : play,
                  tooltip: 'Play/Stop',
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  child: Icon(isPlaying ? Icons.stop : Icons.play_arrow),
                ), // This trai
            ],
          ),
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
