import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  late List<Contact> _contacts = [];

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
      ),
      body: ListView.builder(
        itemCount: _contacts.length,
        itemBuilder: (context, index) {
          Contact contact = _contacts[index];
          return ListTile(
            title: Text(contact.displayName),
            // subtitle: Text(contact.phones[0].number),
            subtitle: Text(contact.phones[0].normalizedNumber),
          );
        },
      ),
    );
  }

  Future<void> _checkPermission() async {
    PermissionStatus permissionStatus = await Permission.contacts.status;
    if (permissionStatus != PermissionStatus.granted) {
      permissionStatus = await Permission.contacts.request();
      if (permissionStatus != PermissionStatus.granted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Permission denied...'),
          ),
        );
      } else {
        _fetchContacts();
      }
    } else {
      _fetchContacts();
    }
  }

  Future<void> _fetchContacts() async {
    List<Contact> contacts = await FlutterContacts.getContacts(
        withProperties: true, withThumbnail: false);
    setState(() {
      _contacts = contacts;
    });
  }
}
