import 'package:flutter/material.dart';
import '../services/crash_detection_service.dart';
import 'emergency_contacts_screen.dart';
import 'emergency_sos_screen.dart';
import 'login_screen.dart';

class DashboardScreen extends StatefulWidget {
  static const routeName = '/dashboard';

  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int riskScore = 78;
  int currentSpeed = 68;
  bool _isCheckingCrash = false;
  String _crashStatus = 'No crash events detected';

  Future<void> _checkCrash() async {
    setState(() {
      _isCheckingCrash = true;
    });
    final crashDetected = await CrashDetectionService.instance.simulateCrashCheck();
    if (mounted) {
      setState(() {
        _isCheckingCrash = false;
        _crashStatus = crashDetected
            ? 'Potential crash detected. Visit SOS for help.'
            : 'No crash detected. Continue driving safely.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final riskColor = riskScore < 50 ? Colors.green : (riskScore < 80 ? Colors.orange : Colors.red);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Driver summary',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Driver Risk Score',
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 36,
                          backgroundColor: Color.fromRGBO(
                            riskColor.r.round(),
                            riskColor.g.round(),
                            riskColor.b.round(),
                            0.18,
                          ),
                          child: Text(
                            '$riskScore%',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: riskColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 18),
                        Expanded(
                          child: Text(
                            riskScore < 60
                                ? 'Low risk. Keep your focus on the road.'
                                : 'Moderate risk. Drive carefully and avoid sudden maneuvers.',
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Current Speed',
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '$currentSpeed km/h',
                          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                        ),
                        Icon(
                          Icons.speed,
                          size: 40,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    LinearProgressIndicator(
                      value: currentSpeed / 140,
                      color: Theme.of(context).colorScheme.primary,
                      backgroundColor: Colors.grey.shade200,
                      minHeight: 10,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade50,
                  borderRadius: BorderRadius.circular(18),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Emergency support',
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Use the SOS hub to share your location, manage contacts, and access crash detection tools.',
                      style: TextStyle(fontSize: 15),
                    ),
                    const SizedBox(height: 16),
                    Text(_crashStatus, style: const TextStyle(fontSize: 15, color: Colors.black87)),
                    const Spacer(),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.shade700,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                            icon: const Icon(Icons.report_gmailerrorred),
                            label: const Text('Go to SOS'),
                            onPressed: () => Navigator.of(context).pushNamed(EmergencySOSScreen.routeName),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.contacts),
                            label: const Text('Contacts'),
                            onPressed: () => Navigator.of(context).pushNamed(EmergencyContactsScreen.routeName),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _isCheckingCrash ? null : _checkCrash,
                            child: _isCheckingCrash
                                ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator())
                                : const Text('Crash Check'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
