import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shimmer/shimmer.dart';
import 'package:v_card_qr_code/helpers/contacts_helper.dart';
import 'package:v_card_qr_code/screens/contacts/contact_details_screen.dart';
import 'package:v_card_qr_code/screens/widgets/app_scaffold.dart';
import 'package:v_card_qr_code/screens/widgets/placeholdes.dart';
import 'package:vcard_maintained/vcard_maintained.dart';

import '../widgets/app_bar.dart';

class ContactsScreen extends StatefulWidget {
  final Function(Map<String, String>) onNewCard;

  const ContactsScreen({super.key, required this.onNewCard});

  @override
  ContactsScreenState createState() => ContactsScreenState();
}

class ContactsScreenState extends State<ContactsScreen> with WidgetsBindingObserver {
  List<Contact> contacts = [];
  List<Contact> filteredContacts = [];
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();
  bool _showErrorPermissionState = false;
  bool _goToSettingsState = false;
  bool settingsOpened = false;
  Size preferredSizeBottom = const Size.fromHeight(80);

  @override
  void initState() {
    super.initState();
    _verifyContactsPermission();
    searchController.addListener(_filterContacts);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    searchController.removeListener(_filterContacts);
    searchController.dispose();
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed && settingsOpened) {
      bool isGranted = await Permission.contacts.request().isGranted;
      if (isGranted) {
        _fetchContacts();
      }

      settingsOpened = false;
    }
  }

  _verifyContactsPermission() async {
    if (await Permission.contacts.request().isGranted) {
      _fetchContacts();
    } else {
      setState(() {
        _showErrorPermissionState = true;
        isLoading = false;
      });
    }
  }

  Future<void> _tryRequestContactsPermission() async {
    await Permission.contacts.request().then((value) => _verifyIfPermissionIsGranted(value));
  }

  _verifyIfPermissionIsGranted(PermissionStatus value) {
    if (value == PermissionStatus.granted) {
      _fetchContacts();
    } else if (value == PermissionStatus.permanentlyDenied) {
      setState(() {
        _goToSettingsState = true;
        isLoading = false;
      });
    } else {
      setState(() {
        _showErrorPermissionState = true;
        isLoading = false;
      });
    }
  }

  Future<void> _fetchContacts() async {
    if (await FlutterContacts.requestPermission()) {
      setState(() => isLoading = true);

      List<Contact> fetchedContacts =
          await FlutterContacts.getContacts(withProperties: true, withAccounts: true, deduplicateProperties: false);

      log('qtd contatos carregados: ${fetchedContacts.length}');
      fetchedContacts = fetchedContacts
          .where((element) =>
              element.displayName.isNotEmpty ||
              element.name.first.isNotEmpty ||
              element.name.middle.isNotEmpty ||
              element.name.last.isNotEmpty)
          .toList();

      log('qtd contatos carregados, filtrados: ${fetchedContacts.length}');

      setState(() {
        contacts = fetchedContacts;
        filteredContacts = fetchedContacts;
        isLoading = false;
        _goToSettingsState = false;
        _showErrorPermissionState = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _filterContacts() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredContacts = contacts.where((contact) => contact.displayName.toLowerCase().contains(query)).toList();
    });
  }

  void _navigateToContactDetails(Contact contact) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ContactDetailsScreen(
            contact: contact,
            onGenerateVCard: (contact) {
              Map<String, String> vCardData = _generateVCardData(contact);
              widget.onNewCard(vCardData);
            })));
  }

  Map<String, String> _generateVCardData(Contact contact) {
    String? mobilePhone = ContactsHelper().getPhone(contact.phones, PhoneLabel.mobile.name);
    String? homePhone = ContactsHelper().getPhone(contact.phones, PhoneLabel.home.name);
    String? workPhone = ContactsHelper().getPhone(contact.phones, PhoneLabel.work.name);
    String? email = ContactsHelper().getEmail(contact.emails, EmailLabel.home.name);
    String? workEmail = ContactsHelper().getEmail(contact.emails, EmailLabel.work.name);
    String? otherEmail = ContactsHelper().getEmail(contact.emails, EmailLabel.other.name);
    String? note = contact.notes.isNotEmpty ? contact.notes.first.note : null;
    String? url = ContactsHelper().getURL(contact.websites, WebsiteLabel.home.name) ??
        ContactsHelper().getURL(contact.websites, WebsiteLabel.homepage.name);
    String? workUrl = ContactsHelper().getURL(contact.websites, WebsiteLabel.work.name) ??
        ContactsHelper().getURL(contact.websites, WebsiteLabel.other.name) ??
        ContactsHelper().getURL(contact.websites, WebsiteLabel.custom.name);
    String? otherPhone = ContactsHelper().getPhone(contact.phones, PhoneLabel.other.name);

    final vCard = VCard();
    vCard.uid = contact.id;
    vCard.firstName = contact.name.first;
    vCard.middleName = contact.name.middle;
    vCard.lastName = contact.name.last;
    vCard.cellPhone = mobilePhone ?? '';
    vCard.homePhone = homePhone ?? '';
    vCard.workPhone = workPhone ?? '';
    vCard.workEmail = workEmail ?? '';
    vCard.email = email ?? '';
    vCard.otherEmail = otherEmail ?? '';
    vCard.jobTitle = ContactsHelper().getOrganization(contact.organizations)?.title ?? '';
    vCard.organization = ContactsHelper().getOrganization(contact.organizations)?.company ?? '';
    vCard.url = url ?? '';
    vCard.workUrl = workUrl ?? '';
    vCard.note = note ?? '';
    vCard.otherPhone = otherPhone ?? '';

    Map<String, String> card = {
      'vCard': vCard.getFormattedString(),
      'uid': contact.id,
      'firstName': contact.name.first,
      'middleName': contact.name.middle,
      'lastName': contact.name.last,
      'cellPhone': mobilePhone ?? '',
      'homePhone': homePhone ?? '',
      'workPhone': workPhone ?? '',
      'workEmail': workEmail ?? '',
      'email': email ?? '',
      'otherEmail': otherEmail ?? '',
      'jobTitle': ContactsHelper().getOrganization(contact.organizations)?.title ?? '',
      'organization': ContactsHelper().getOrganization(contact.organizations)?.company ?? '',
      'url': url ?? '',
      'workUrl': workUrl ?? '',
      'note': note ?? '',
      'otherPhone': otherPhone ?? '',
    };

    Navigator.of(context).pop();

    return card;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: true,
        onPopInvoked: (didPop) => FocusScope.of(context).unfocus(),
        child: AppScaffold(
            appBar: AppAppBar(
                title: 'Contatos',
                preferredSizeBottom: preferredSizeBottom,
                bottom: contacts.isNotEmpty
                    ? PreferredSize(
                        preferredSize: preferredSizeBottom,
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                                cursorColor: Colors.white,
                                controller: searchController,
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                    hintText: 'Pesquisar...',
                                    hintStyle: const TextStyle(color: Colors.white),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                                    prefixIcon: const Icon(Icons.search, color: Colors.white)))))
                    : null),
            body: _handleContactsListState()));
  }

  Widget _handleContactsListState() {
    if (_goToSettingsState && !isLoading) {
      return Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
            const Text('Conceda o acesso aos contatos para continuar.'),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () async {
                  await openAppSettings();
                  settingsOpened = true;
                },
                child: const Text('Ir para configurações'))
          ]));
    }
    if (_showErrorPermissionState && !isLoading) {
      return Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
            const Text('Conceda o acesso aos contatos para continuar.'),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () async {
                  await _tryRequestContactsPermission();
                },
                child: const Text('Conceder Acesso'))
          ]));
    }
    if (isLoading) {
      return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          enabled: true,
          child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.max, children: [
                for (int i = 0; i < 20; i++)
                  const Padding(
                      padding: EdgeInsets.only(top: 16.0),
                      child: ContentPlaceholder(lineType: ContentLineType.twoLines))
              ])));
    }
    if (filteredContacts.isNotEmpty) {
      return ListView.builder(
          itemCount: filteredContacts.length,
          itemBuilder: (context, index) {
            final contact = filteredContacts[index];
            return ListTile(
                leading: contact.photoOrThumbnail != null
                    ? CircleAvatar(
                        backgroundImage: MemoryImage(contact.photoOrThumbnail!),
                      )
                    : const CircleAvatar(child: Icon(Icons.person)),
                title: Text(contact.displayName),
                subtitle: Text(contact.phones.isNotEmpty ? contact.phones.first.number : 'Sem telefone'),
                onTap: () => _navigateToContactDetails(contact));
          });
    }

    return const Center(child: Text('Nenhum contato encontrado :('));
  }
}
