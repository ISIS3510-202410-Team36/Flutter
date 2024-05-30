import 'dart:async';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shake/shake.dart';
import 'package:unimarket/Views/cart_view.dart';
import 'package:unimarket/Views/chat_view/chat_view.dart';
import 'package:unimarket/Views/home_view.dart';
import 'package:unimarket/Views/publish_view/publish_view.dart';
import 'package:unimarket/Views/search_view/search_view.dart';
import 'package:unimarket/nav_bar.dart';
import 'package:noise_meter/noise_meter.dart';

class BodyView extends StatefulWidget {
  const BodyView({super.key});

  @override
  State<BodyView> createState() => _BodyViewState();
}

class _BodyViewState extends State<BodyView> {
  @override
  bool _isRecording = false;
  NoiseReading? _latestReading;
  StreamSubscription<NoiseReading>? _noiseSubscription;
  NoiseMeter? noiseMeter;

  void onData(NoiseReading noiseReading) {
    setState(() => _latestReading = noiseReading);
    if (_latestReading!.meanDecibel > 90.0) {
      stop();
      showNoiseDialog(context, (_latestReading!.meanDecibel));
    }
  }

  void showNoiseDialog(BuildContext context, double decibels) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 212, 129, 12),
          title: const Text('Noise Alert'),
          content: const Text(
              "Noise reached 90 decibels of noise or higher , considero moving to a calmer place"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                start();
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
            TextButton(
              onPressed: () {
                stop();
                Navigator.of(context).pop();
              },
              child: const Text('Turn off this function'),
            ),
          ],
        );
      },
    );
  }

  void onError(Object error) {
    print(error);
    stop();
  }

  Future<bool> checkPermission() async => await Permission.microphone.isGranted;

  Future<void> requestPermission() async =>
      await Permission.microphone.request();

  Future<void> start() async {
    noiseMeter ??= NoiseMeter();

    if (!(await checkPermission())) await requestPermission();

    _noiseSubscription = noiseMeter?.noise.listen(onData, onError: onError);
    setState(() => _isRecording = true);
  }

  void stop() {
    _noiseSubscription?.cancel();
    setState(() => _isRecording = false);
  }

  int currentIndex = 0;

  void setCurrentIndex(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  var pageViewList = [
    Container(
      alignment: Alignment.center,
      child: const HomeView(),
    ),
    Container(
      color: Colors.white,
      alignment: Alignment.center,
      child: SearchView(
        categoryIndex: 5,
      ),
    ),
    Container(
      color: Colors.white,
      alignment: Alignment.center,
      child: const CartView(),
    ),
    Container(
      color: Colors.white,
      alignment: Alignment.center,
      child: const PublishView(),
    ),
    Container(
      color: Colors.white,
      alignment: Alignment.center,
      child: const Text('Here goes the settings page'),
    ),
    Container(
      color: Colors.white,
      alignment: Alignment.center,
      child: const ChatView(),
    ),
    Container(
      color: Colors.white,
      alignment: Alignment.center,
      child: const Text('Here goes the user profile page'),
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavBar(
        onDestinationSelected: (int value) {
          setState(() {
            currentIndex = value;
          });
        },
        selectedIndex: currentIndex,
      ),
      body: pageViewList[currentIndex],
    );
  }

  late ShakeDetector detector;

  @override
  void initState() {
    detector = ShakeDetector.autoStart(onPhoneShake: () {
      setState(() {
        currentIndex = 3;
      });
    });
    start();

    super.initState();
  }

  @override
  void dispose() {
    detector.stopListening();
    _noiseSubscription?.cancel();
    super.dispose();
  }
}
