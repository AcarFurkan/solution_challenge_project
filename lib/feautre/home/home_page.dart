import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kartal/kartal.dart';
import 'package:solution_challenge_project/core/common_widgets/animation/progress_animation/custom_circular_progress.dart';
import 'package:solution_challenge_project/core/constants/app_sizes.dart';
import 'package:solution_challenge_project/feautre/authentication/data/firebase_auth_repository.dart';

List<Map<String, String>> flowers = [
  {"Flower 1": "Mg 2 Ca 4"},
  {"Flower 2": "Mg 4 Ca 2"},
  {"Flower 3": "Mg 3 Ca 5"}
];

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  Map<String, String> selectedFlower = flowers.first;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(firebaseAuthRepositoryProvider).currentUser;
    final CountDownController controller = CountDownController();
    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: Text('My Solar Panel',
            style: context.textTheme.headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold)),
        trailing: IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () async {
            await ref.read(firebaseAuthRepositoryProvider).signOut();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Sizes.p16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // const Text('Home Page'),
              gapH16,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BuildProgressBar(controller: controller),
                  const BuildChargeInfo()
                ],
              ),
              gapH24,

              const BuildFlowerInfo(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  BuildCleanPanelColumn(),
                  BuildWaterThePlantsColumn(),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  DropdownButtonHideUnderline(
                    child: DropdownButton<Map<String, String>>(
                        value: selectedFlower,
                        items: flowers
                            .map((e) => DropdownMenuItem<Map<String, String>>(
                                  value: e,
                                  child: Text(
                                    e.keys.first,
                                    style: context.textTheme.headlineSmall,
                                  ),
                                ))
                            .toList(),
                        onChanged: (e) {
                          setState(() {
                            selectedFlower = e ?? flowers.first;
                          });
                        }),
                  ),
                  Chip(
                    label: Text(selectedFlower.values.first,
                        style: context.textTheme.titleSmall
                            ?.copyWith(color: Colors.white)),
                    backgroundColor: Colors.green,
                  ),
                ],
              ),
              const BuildDozajlamaColumn(),
            ],
          ),
        ),
      ),
    );
  }
}

class BuildChargeInfo extends StatelessWidget {
  const BuildChargeInfo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      //  crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Total Capacity 19 Volt",
          style: context.textTheme.titleLarge,
        ),
        Text(
          "15 Volt Consumed",
          style: context.textTheme.titleLarge,
        ),
      ],
    );
  }
}

class BuildProgressBar extends StatelessWidget {
  const BuildProgressBar({
    super.key,
    required this.controller,
  });

  final CountDownController controller;

  @override
  Widget build(BuildContext context) {
    return NeonCircularProgress(
        onComplete: () {
          //  controller.restart();
        },
        neon: 10,
        //  initialDuration: 1000,
        completedProgress: 15 / 19,
        onStart: () {},
        width: 150,
        controller: controller,
        duration: 1500,
        strokeWidth: 10,
        //  isTimerTextShown: false,
        neumorphicEffect: true,
        outerStrokeColor: Colors.grey.shade100,
        innerFillGradient: LinearGradient(
            colors: [Colors.greenAccent.shade200, Colors.blueAccent.shade400]),
        neonGradient: LinearGradient(
            colors: [Colors.greenAccent.shade200, Colors.blueAccent.shade400]),
        strokeCap: StrokeCap.round,
        innerFillColor: Colors.white,
        backgroudColor: Colors.grey.shade100,
        neonColor: Colors.blue.shade900);
  }
}

class BuildCleanPanelColumn extends StatelessWidget {
  const BuildCleanPanelColumn({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
            radius: context.width * 0.2,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Image.asset(
                "assets/solar_panel.jpeg",
                fit: BoxFit.fill,
              ),
            )),
        TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Center(
                        child: Text("Panel Cleaning",
                            style: context.textTheme.titleLarge
                                ?.copyWith(color: Colors.white))),
                    backgroundColor: Colors.green),
              );
            },
            child: Text("Clean Panel", style: context.textTheme.titleLarge)),
      ],
    );
  }
}

class BuildWaterThePlantsColumn extends StatelessWidget {
  const BuildWaterThePlantsColumn({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
            radius: context.width * 0.2,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Image.asset(
                "assets/flower.jpeg",
              ),
            )),
        TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Center(
                        child: Text("Plants are watered",
                            style: context.textTheme.titleLarge
                                ?.copyWith(color: Colors.white))),
                    backgroundColor: Colors.green),
              );
            },
            child:
                Text("Water The Plants", style: context.textTheme.titleLarge)),
      ],
    );
  }
}

class BuildDozajlamaColumn extends StatelessWidget {
  const BuildDozajlamaColumn({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
            radius: context.width * 0.2,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Image.asset(
                "assets/dozajlama.jpeg",
              ),
            )),
        TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Center(
                        child: Text("Dosing",
                            style: context.textTheme.titleLarge
                                ?.copyWith(color: Colors.white))),
                    backgroundColor: Colors.green),
              );
            },
            child: Text("Dosage", style: context.textTheme.titleLarge)),
      ],
    );
  }
}

class BuildFlowerInfo extends StatelessWidget {
  const BuildFlowerInfo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            Text("TDS", style: context.textTheme.titleLarge),
            const CustomChip(text: "5 ppm"),
          ],
        ),
        Column(
          children: [
            Text("Conductivity", style: context.textTheme.titleLarge),
            const CustomChip(text: "35.49 ppm"),
          ],
        ),
        Column(
          children: [
            Text("Degree", style: context.textTheme.titleLarge),
            const CustomChip(text: "15°C"),
          ],
        )
      ],
    );
  }
}

class CustomChip extends StatelessWidget {
  const CustomChip({
    super.key,
    required this.text,
  });
  final String text;
  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(text,
          style: context.textTheme.titleSmall?.copyWith(color: Colors.white)),
      backgroundColor: Colors.green,
    );
  }
}
