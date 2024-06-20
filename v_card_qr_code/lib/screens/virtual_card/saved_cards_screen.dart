import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:v_card_qr_code/helpers/color.dart';
import 'package:v_card_qr_code/helpers/contacts_helper.dart';
import 'package:v_card_qr_code/screens/virtual_card/vcard_form_screen.dart';
import 'package:v_card_qr_code/screens/widgets/app_scaffold.dart';

class SavedCardsScreen extends StatefulWidget {
  final Function(Map<String, String>) onCardSelected;

  const SavedCardsScreen({super.key, required this.onCardSelected});

  @override
  SavedCardsScreenState createState() => SavedCardsScreenState();
}

class SavedCardsScreenState extends State<SavedCardsScreen> {
  final List<Map<String, String>> savedCards = [];

  @override
  void initState() {
    super.initState();
    _loadSavedCards();
  }

  _loadSavedCards() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // List<String> cards = prefs.getStringList('cards')?.reversed.toList() ?? [];
    List<String> cards = prefs.getStringList('cards')?.toList() ?? [];

    setState(() {
      savedCards.clear();
      for (String card in cards) {
        savedCards.add(Map<String, String>.from(json.decode(card)));
      }
    });
  }

  _deleteCard(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // List<String> cards = prefs.getStringList('cards')?.reversed.toList() ?? [];
    List<String> cards = prefs.getStringList('cards')?.toList() ?? [];
    cards.removeAt(index);
    await prefs.setStringList('cards', cards);
    _loadSavedCards();
  }

  _editCard(int index, Map<String, String> card) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // List<String> cards = prefs.getStringList('cards')?.reversed.toList() ?? [];
    List<String> cards = prefs.getStringList('cards')?.toList() ?? [];
    cards[index] = json.encode(card);
    await prefs.setStringList('cards', cards);
    _loadSavedCards();
  }

  _showQrCode(Map<String, String> card) {
    widget.onCardSelected(card);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        body: savedCards.isNotEmpty
            ? ListView.builder(
                shrinkWrap: true,
                itemCount: savedCards.length,
                itemBuilder: (context, index) {
                  Map<String, String> card = savedCards[index];
                  return _generataItemList(card, index, context);
                })
            : const Center(child: Text('Nenhum cartão virual salvo.')));
  }

  Widget _generataItemList(Map<String, String> card, int index, BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
        child: Card(
            elevation: 4,
            child: ExpansionTile(
                backgroundColor: Colors.white60,
                collapsedBackgroundColor: Colors.white60,
                shape: const Border(),
                // dense: true,
                iconColor: AppColors().secundaryColor,
                collapsedIconColor: AppColors().primaryColor,
                title: Text(_getExpansionTileTitleText(card),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                leading: const Icon(Icons.contact_mail),
                children: [
                  Column(children: [
                    if (_hasPersonalData(card)) _buildTitleRowData('Dados Pessoais:', showDivider: false),
                    if (card['firstName']!.isNotEmpty)
                      _buildItemRowData('Nome: ', ContactsHelper().getCompleteName(card)),
                    if (card['cellPhone']!.isNotEmpty)
                      _buildItemRowData('Celular: ', card['cellPhone']!, isPhone: true),
                    if (card['homePhone']!.isNotEmpty)
                      _buildItemRowData('Tel. Fixo: ', card['homePhone']!, isPhone: true),
                    if (card['email']!.isNotEmpty) _buildItemRowData('Email: ', card['email']!, isEmail: true),
                    if (card['url']!.isNotEmpty) _buildItemRowData('Link: ', card['url']!, isHyperLink: true),
                    //////////////////////////////////
                    if (_hasOrganizacionalData(card)) _buildTitleRowData('Dados Empresarias:'),
                    if (card['organization']!.isNotEmpty) _buildItemRowData('Empresa: ', card['organization']!),
                    if (card['jobTitle']!.isNotEmpty) _buildItemRowData('Cargo: ', card['jobTitle']!),
                    if (card['workPhone']!.isNotEmpty)
                      _buildItemRowData('Celular: ', card['workPhone']!, isPhone: true),
                    if (card['workEmail']!.isNotEmpty) _buildItemRowData('Email: ', card['workEmail']!, isEmail: true),
                    if (card['workUrl']!.isNotEmpty) _buildItemRowData('Link: ', card['workUrl']!, isHyperLink: true),
                    //////////////////////////////////
                    if (_hasOtherData(card)) _buildTitleRowData('Outros dados:'),
                    if (card['otherEmail']!.isNotEmpty)
                      _buildItemRowData('Email: ', card['otherEmail']!, isEmail: true),
                    if (card['otherPhone']!.isNotEmpty) _buildItemRowData('Tel: ', card['otherPhone']!, isPhone: true),
                    if (card['note']!.isNotEmpty) _buildItemRowData('Nota: ', card['note']!)
                  ]),
                  _buildTitleRowData('Ações disponíveis:'),
                  Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _deleteCard(index)),
                        _verticalDivider(),
                        IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => VCardFormScreen(
                                    initialCard: card,
                                    onSave: (editedCard) {
                                      _editCard(index, editedCard);
                                    })))),
                        _verticalDivider(),
                        IconButton(
                            icon: Icon(Icons.qr_code, color: AppColors().primaryColor),
                            onPressed: () => _showQrCode(card))
                      ])
                ])));
  }

  Widget _verticalDivider() => const Padding(
      padding: EdgeInsets.all(8.0), child: SizedBox(height: 10, child: VerticalDivider(color: Colors.grey)));

  String _getExpansionTileTitleText(Map<String, String> card) {
    String titleText;
    titleText = card['firstName']!;

    if (card['cellPhone']!.isNotEmpty) {
      titleText = '$titleText | ${card['cellPhone']!}';
    }

    return titleText;
  }

  bool _hasPersonalData(Map<String, String> card) {
    return card['firstName']!.isNotEmpty ||
        card['cellPhone']!.isNotEmpty ||
        card['homePhone']!.isNotEmpty ||
        card['email']!.isNotEmpty ||
        card['url']!.isNotEmpty;
  }

  bool _hasOtherData(Map<String, String> card) =>
      card['otherEmail']!.isNotEmpty || card['note']!.isNotEmpty || card['otherPhone']!.isNotEmpty;

  bool _hasOrganizacionalData(Map<String, String> card) {
    return card['organization']!.isNotEmpty ||
        card['jobTitle']!.isNotEmpty ||
        card['workUrl']!.isNotEmpty ||
        card['workPhone']!.isNotEmpty ||
        card['workEmail']!.isNotEmpty;
  }

  Widget _buildTitleRowData(String title, {bool showDivider = true}) {
    return Padding(
        padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
        child: Column(children: [
          if (showDivider)
            Padding(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.40, right: MediaQuery.of(context).size.width * 0.40),
                child: const Divider(color: Colors.grey, thickness: 1)),
          Text(title, textAlign: TextAlign.left, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
        ]));
  }

  Widget _buildItemRowData(String title, String value,
      {bool isHyperLink = false, bool isEmail = false, bool isPhone = false}) {
    return Padding(
      padding: (isHyperLink || isEmail || isPhone) ? const EdgeInsets.only(top: 2, bottom: 2) : const EdgeInsets.all(0),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(
            flex: 1,
            child: Text(title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold), textAlign: TextAlign.end)),
        const SizedBox(width: 4),
        if (isHyperLink)
          Expanded(
            flex: 3,
            child: InkWell(
                onTap: () => launchUrl(Uri.parse(value.contains('http') ? value : 'https://$value')),
                child: Text(value,
                    style: const TextStyle(decoration: TextDecoration.underline, color: Colors.blue, fontSize: 16),
                    textAlign: TextAlign.start)),
          )
        else if (isPhone)
          Expanded(
              flex: 3,
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(value, style: const TextStyle(fontSize: 16), textAlign: TextAlign.start),
                  const SizedBox(width: 4),
                  GestureDetector(onTap: () => launchPhoneDialer(value), child: const Icon(Icons.call))
                ],
              ))
        else if (isEmail)
          Expanded(
              flex: 3,
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(value, style: const TextStyle(fontSize: 16), textAlign: TextAlign.start),
                  const SizedBox(width: 4),
                  GestureDetector(onTap: () => _sendToEmail(value), child: const Icon(Icons.email))
                ],
              ))
        else
          Expanded(flex: 3, child: Text(value, style: const TextStyle(fontSize: 16)))
      ]),
    );
  }

  _sendToEmail(String email) async {
    final Uri params = Uri(scheme: 'mailto', path: email);

    var url = params.toString();
    if (await canLaunchUrl(params)) {
      await launchUrl(params);
    } else {
      log('Could not launch $url');
    }
  }

  Future<void> launchPhoneDialer(String contactNumber) async {
    final Uri phoneUri = Uri(scheme: "tel", path: contactNumber);
    try {
      if (await canLaunchUrl(phoneUri)) await launchUrl(phoneUri);
    } catch (error) {
      log("Cannot dial");
    }
  }
}
