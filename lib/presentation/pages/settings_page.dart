import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_flutter/presentation/providers/reminder_provider.dart';
import 'package:restaurant_flutter/presentation/providers/theme_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Settings',
                    style: theme.textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'App preferences',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color:
                          theme.colorScheme.primary.withValues(alpha: 0.06),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Consumer<ThemeProvider>(
                  builder: (context, themeProvider, child) {
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 4,
                      ),
                      leading: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (child, animation) {
                          return RotationTransition(
                            turns:
                                Tween(begin: 0.75, end: 1.0).animate(animation),
                            child:
                                FadeTransition(opacity: animation, child: child),
                          );
                        },
                        child: Icon(
                          themeProvider.isDarkMode
                              ? Icons.dark_mode_rounded
                              : Icons.light_mode_rounded,
                          key: ValueKey(themeProvider.isDarkMode),
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      title: Text(
                        'Dark Theme',
                        style: theme.textTheme.titleLarge,
                      ),
                      subtitle: Text(
                        themeProvider.isDarkMode
                            ? 'Dark mode is on'
                            : 'Light mode is on',
                        style: theme.textTheme.bodyMedium,
                      ),
                      trailing: Switch.adaptive(
                        value: themeProvider.isDarkMode,
                        activeTrackColor: theme.colorScheme.primary,
                        onChanged: (_) => themeProvider.toggleTheme(),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color:
                          theme.colorScheme.primary.withValues(alpha: 0.06),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Consumer<ReminderProvider>(
                  builder: (context, reminderProvider, child) {
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 4,
                      ),
                      leading: Icon(
                        reminderProvider.isDailyReminderOn
                            ? Icons.notifications_active_rounded
                            : Icons.notifications_off_rounded,
                        color: theme.colorScheme.primary,
                      ),
                      title: Text(
                        'Daily Reminder',
                        style: theme.textTheme.titleLarge,
                      ),
                      subtitle: Text(
                        reminderProvider.isDailyReminderOn
                            ? 'Reminder at 11:00 AM is on'
                            : 'Reminder is off',
                        style: theme.textTheme.bodyMedium,
                      ),
                      trailing: Switch.adaptive(
                        value: reminderProvider.isDailyReminderOn,
                        activeTrackColor: theme.colorScheme.primary,
                        onChanged: (value) =>
                            reminderProvider.toggleDailyReminder(value),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
