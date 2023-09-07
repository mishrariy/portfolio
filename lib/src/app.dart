import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:portfolio/src/constants/themes.dart' as themes;
import 'package:portfolio/src/constants/transparent_image.dart';
import 'package:portfolio/src/features/main/presentation/main_section.dart';
import 'package:portfolio/src/features/main/provider/dark_mode_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:portfolio/src/features/project/data/project_repository.dart';
import 'package:portfolio/src/localization/generated/locale_keys.g.dart';

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void didChangeDependencies() {
    _preCacheAllImages();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (_) => tr(LocaleKeys.name),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: themes.lightTheme,
      darkTheme: themes.darkTheme,
      themeMode: ref.watch(darkModeProvider).maybeWhen(
            data: (darkMode) => darkMode ? ThemeMode.dark : ThemeMode.light,
            orElse: () => ThemeMode.system,
          ),
      home: const MainSection(),
    );
  }

  void _preCacheAllImages() {
    // Projects
    final projects = ref.read(projectRepositoryProvider).getProjects();
    for (var project in projects) {
      final projectScreenshotUrl = project.screenshotUrl;
      if (projectScreenshotUrl != null) {
        final projectImage = AssetImage(projectScreenshotUrl);
        precacheImage(projectImage, context);
      }
    }
    // Placeholder
    precacheImage(MemoryImage(transparentImage), context);
  }
}
