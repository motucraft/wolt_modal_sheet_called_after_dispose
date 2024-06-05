import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

void main() => runApp(const MyApp());

final router = GoRouter(
  initialLocation: '/home',
  routes: [
    GoRoute(
      path: '/home',
      pageBuilder: (context, state) {
        return const MaterialPage(child: Home());
      },
    ),
    GoRoute(
      path: '/modal-sheet',
      pageBuilder: (context, state) {
        final extra = state.extra;
        if (extra == null || extra is! ValueNotifier<WoltModalSheetPageListBuilder>) {
          throw UnsupportedError('Unsupported');
        }
        return ModalSheetPage(pageListBuilderNotifier: extra);
      },
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp.router(routerConfig: router);
}

class Home extends HookWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final pageBuilderNotifier = useValueNotifier<WoltModalSheetPageListBuilder>((context) => []);

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            pageBuilderNotifier.value = (context) => [
                  WoltModalSheetPage(
                    child: const SizedBox(
                      height: 200,
                      child: Center(
                        child: Text('test'),
                      ),
                    ),
                  ),
                ];
            context.push('/modal-sheet', extra: pageBuilderNotifier);
          },
          child: const Text('open'),
        ),
      ),
    );
  }
}

class ModalSheetPage extends Page<void> {
  final ValueNotifier<WoltModalSheetPageListBuilder> pageListBuilderNotifier;
  final ValueNotifier<int>? pageIndexNotifier;

  const ModalSheetPage({
    required this.pageListBuilderNotifier,
    this.pageIndexNotifier,
  });

  @override
  Route<void> createRoute(BuildContext context) {
    return WoltModalSheetRoute<void>(
      pageListBuilderNotifier: pageListBuilderNotifier,
      pageIndexNotifier: pageIndexNotifier,
      onModalDismissedWithBarrierTap: () => Navigator.pop(context),
      routeSettings: this,
    );
  }
}
