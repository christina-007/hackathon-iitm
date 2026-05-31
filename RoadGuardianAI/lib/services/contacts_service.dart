class EmergencyContact {
  final String id;
  String name;
  String phone;

  EmergencyContact({required this.id, required this.name, required this.phone});
}

class EmergencyContactsService {
  EmergencyContactsService._internal();

  static final EmergencyContactsService instance = EmergencyContactsService._internal();

  final List<EmergencyContact> _contacts = [
    EmergencyContact(id: '1', name: 'Roadside Assist', phone: '1800-555-1212'),
    EmergencyContact(id: '2', name: 'Family Contact', phone: '+1 555 987 6543'),
  ];

  List<EmergencyContact> getContacts() => List.unmodifiable(_contacts);

  void addContact(String name, String phone) {
    final String id = DateTime.now().millisecondsSinceEpoch.toString();
    _contacts.add(EmergencyContact(id: id, name: name, phone: phone));
  }

  void removeContact(String id) {
    _contacts.removeWhere((contact) => contact.id == id);
  }

  void updateContact(String id, String name, String phone) {
    final index = _contacts.indexWhere((contact) => contact.id == id);
    if (index == -1) return;
    _contacts[index].name = name;
    _contacts[index].phone = phone;
  }
}
