import 'package:flutter/material.dart';
import '../services/contacts_service.dart';
import '../services/crash_detection_service.dart';
import '../services/location_service.dart';

class EmergencySOSScreen extends StatefulWidget {
  static const routeName = '/sos';

  const EmergencySOSScreen({super.key});

  @override
  State<EmergencySOSScreen> createState() => _EmergencySOSScreenState();
}

class _EmergencySOSScreenState extends State<EmergencySOSScreen> {
  MockLocation? _location;
  bool _isSharing = false;
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _loadLocation();
  }

  Future<void> _loadLocation() async {
    setState(() {
      _isSharing = true;
    });
    final location = await MockLocationService.instance.refreshLocation();
    if (mounted) {
      setState(() {
        _location = location;
        _isSharing = false;
      });
    }
  }

  Future<void> _sendSOS() async {
    setState(() {
      _isSending = true;
    });
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) {
      setState(() {
        _isSending = false;
      });
      showDialog<void>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('SOS Sent'),
            content: Text(
              'Your emergency alert has been shared with ${EmergencyContactsService.instance.getContacts().length} contacts and roadside support.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _checkCrash() async {
    final crashDetected = await CrashDetectionService.instance.simulateCrashCheck();
    if (mounted) {
      showDialog<void>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(crashDetected ? 'Crash Detected' : 'No Crash Detected'),
            content: Text(crashDetected
                ? 'Crash sensors indicate a potential collision. SOS was prepared automatically.'
                : 'No crash events were detected. Continue driving safely.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final contacts = EmergencyContactsService.instance.getContacts();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency SOS'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Mobile SOS Hub',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              'Your current mock location is shared with emergency responders and saved contacts.',
            ),
            const SizedBox(height: 20),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Location', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    if (_isSharing)
                      const Center(child: CircularProgressIndicator())
                    else if (_location != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Latitude: ${_location!.latitude.toStringAsFixed(4)}'),
                          Text('Longitude: ${_location!.longitude.toStringAsFixed(4)}'),
                          const SizedBox(height: 6),
                          Text('Updated: ${_location!.timestamp}'),
                        ],
                      )
                    else
                      const Text('Unable to fetch mock location.'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _isSharing ? null : _loadLocation,
              icon: const Icon(Icons.gps_fixed),
              label: const Text('Refresh location'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Emergency Contacts', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      Expanded(
                        child: contacts.isEmpty
                            ? const Center(child: Text('No emergency contacts available.'))
                            : ListView.builder(
                                itemCount: contacts.length,
                                itemBuilder: (context, index) {
                                  final contact = contacts[index];
                                  return ListTile(
                                    title: Text(contact.name),
                                    subtitle: Text(contact.phone),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade700),
                    onPressed: _isSending ? null : _sendSOS,
                    child: _isSending
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text('Send SOS'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: _checkCrash,
                    child: const Text('Run crash check'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
