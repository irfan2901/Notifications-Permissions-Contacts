import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:notifications_demo/contacts_page.dart';
import 'package:notifications_demo/local_notifications.dart';
import 'package:notifications_demo/second_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late DateTime selectedDateTime;
  late LocalNotifications localNotifications;

  @override
  void initState() {
    super.initState();
    selectedDateTime = DateTime.now();
    onNotificationClicked();
  }

  onNotificationClicked() {
    LocalNotifications.onClickNotification.stream.listen((event) {
      log('Notification clicked. Payload: $event');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SecondPage(payload: event),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                LocalNotifications.showSimpleNotification(
                    title: 'Demo Notification',
                    body: 'Nofification message',
                    payload: 'Notification Data');
              },
              icon: const Icon(Icons.notifications),
              label: const Text('Simple Notification'),
            ),
            ElevatedButton.icon(
              onPressed: () {
                LocalNotifications.showPeriodicNotification(
                    title: 'Periodic title',
                    body: 'This is periodic notification',
                    payload: 'Periodic notification data');
              },
              icon: const Icon(Icons.timer),
              label: const Text('Periodic Notification'),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                await _selectDateTime(context);
                LocalNotifications.showScheduledNotification(
                    title: 'Scheduled notification',
                    body: 'This is scheduled notification',
                    payload: 'Scheduled notification data',
                    scheduledDate: selectedDateTime);
              },
              icon: const Icon(Icons.notifications),
              label: const Text('Schedule Notification'),
            ),
            ElevatedButton.icon(
              onPressed: () {
                LocalNotifications.showNotificationWithImage(
                    'Notification Image',
                    'Notification with image',
                    'assets/demoimg.jpg',
                    'Network image');
              },
              icon: const Icon(Icons.image),
              label: const Text('Notification with Image'),
            ),
            ElevatedButton.icon(
              onPressed: () {
                LocalNotifications.showNotificationWithNetworkImage(
                    'Network Image',
                    'Notification with network image',
                    'https://images.pexels.com/photos/20410779/pexels-photo-20410779/free-photo-of-a-wooden-walkway-in-the-middle-of-a-jungle.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1');
              },
              icon: const Icon(Icons.image_search),
              label: const Text('Notification with Network Image'),
            ),
            TextButton(
              onPressed: () {
                LocalNotifications.cancel(1);
              },
              child: const Text('Cancel notifications'),
            ),
            TextButton(
              onPressed: () {
                LocalNotifications.cancelAll();
              },
              child: const Text('CancelAll notifications'),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ContactsPage(),
                  ),
                );
              },
              icon: const Icon(Icons.contact_page),
              label: const Text('Show my Contacts'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime picked = (await showDatePicker(
      context: context,
      initialDate: selectedDateTime,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    ))!;

    if (picked != selectedDateTime) {
      final TimeOfDay time = (await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(selectedDateTime),
      ))!;

      setState(() {
        selectedDateTime = DateTime(
          picked.year,
          picked.month,
          picked.day,
          time.hour,
          time.minute,
        );
      });
      log('Selected Date and Time: $selectedDateTime');
    }
  }
}
