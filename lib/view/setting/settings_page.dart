import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rpg/provider/ability.dart';
import 'package:rpg/view/setting/components/menu_view.dart';
import 'package:rpg/view/setting/components/rename_view.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> with TickerProviderStateMixin {
  late AnimationController animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1000),
  );
  final TextEditingController editingController = TextEditingController();

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      editingController.text = ref.watch(abilityProvider).userName!;
    });
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    editingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MenuView(
            animationController: animationController,
          ),
          RenameView(
            animationController: animationController,
            editingController: editingController,
          ),
        ],
      ),
    );
  }
}
