import 'package:flutter/material.dart';
import 'package:heart_bpm/heart_bpm.dart';
class HeartBeat extends StatefulWidget {
  const HeartBeat({super.key});

  @override
  State<HeartBeat> createState() => _HeartBeatState();
}

class _HeartBeatState extends State<HeartBeat> {
  List<SensorValue> data = [];
  int? bpmValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Heartbeat',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFFC987E1),
      ),
      body: Stack(
        children : [
          Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Cover both the camera and flash with your finger",
                  style: Theme.of(context)
                      .textTheme
                      .headlineLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center),
              const SizedBox(
                height: 22,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.favorite,
                    size: 88,
                    color: Colors.red,
                  ),
                  HeartBPMDialog(
                    context: context,
                    onRawData: (value) {
                      setState(() {
                        if (data.length == 100) {
                          data.removeAt(0);
                        }
                        data.add(value);
                      });
                    },
                    onBPM: (value) => setState(() {
                      bpmValue = value;
                    }),
                    child: Text(
                      bpmValue?.toString() ?? "-",
                      style: Theme.of(context)
                          .textTheme
                          .displayLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        ]
      ),
    );
  }
}