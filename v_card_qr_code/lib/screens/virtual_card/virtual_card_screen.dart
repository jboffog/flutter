import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:v_card_qr_code/helpers/color.dart';
import 'package:v_card_qr_code/helpers/contacts_helper.dart';
import 'package:v_card_qr_code/screens/contacts/contacts_screen.dart';
import 'package:v_card_qr_code/screens/virtual_card/vcard_form_screen.dart';
import 'dart:convert';

import 'package:v_card_qr_code/screens/widgets/app_scaffold.dart';

class VirtualCardScreen extends StatefulWidget {
  final Map<String, String>? card;
  final Function(Map<String, String>) onNewCard;

  const VirtualCardScreen({super.key, this.card, required this.onNewCard});

  @override
  VirtualCardScreenState createState() => VirtualCardScreenState();
}

class VirtualCardScreenState extends State<VirtualCardScreen> {
  Map<String, String>? currentCard;
  bool isCardSaved = false;

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();

    _getCurrentCard();
    _checkIfCardIsSaved();
  }

  void _getCurrentCard() async {
    currentCard = widget.card;

    if (currentCard == null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? cardString = prefs.getString('last');
      if (cardString != null) {
        setState(() => currentCard = Map<String, String>.from(json.decode(cardString)));
      }
    }
  }

  void _checkIfCardIsSaved() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> cards = prefs.getStringList('cards') ?? [];
    setState(() => isCardSaved = cards.contains(json.encode(currentCard)));
  }

  Future<void> _saveCard() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> cards = prefs.getStringList('cards') ?? [];
    if (currentCard != null && !cards.contains(json.encode(currentCard))) {
      cards.add(json.encode(currentCard));
      await prefs.setStringList('cards', cards);
      setState(() {
        isCardSaved = true;
      });

      widget.onNewCard(currentCard!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        body: Center(
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      if (currentCard != null) ...[
        _buildRowData('Nome:', ContactsHelper().getCompleteName(currentCard!)),
        if (currentCard!['organization']!.isNotEmpty) _buildRowData('Empresa:', currentCard!['organization']!),
        if (currentCard!['jobTitle']!.isNotEmpty) _buildRowData('Cargo:', currentCard!['jobTitle']!),
        if (currentCard!['workPhone']!.isNotEmpty) _buildRowData('Celular:', currentCard!['workPhone']!),
        if (currentCard!['workEmail']!.isNotEmpty) _buildRowData('Email:', currentCard!['workEmail']!),
        const SizedBox(height: 20),
        Container(
            decoration: BoxDecoration(
                border: Border.all(color: AppColors().secundaryColor, width: 3),
                borderRadius: const BorderRadius.all(Radius.circular(20))),
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: QrImageView(
                    size: MediaQuery.of(context).size.width * 0.60,
                    data: currentCard!['vCard']!,
                    dataModuleStyle:
                        QrDataModuleStyle(color: AppColors().secundaryColor, dataModuleShape: QrDataModuleShape.circle),
                    eyeStyle: QrEyeStyle(color: AppColors().secundaryColor, eyeShape: QrEyeShape.circle)))),
        const SizedBox(height: 20),
        if (!isCardSaved)
          ElevatedButton(
              onPressed: () async => await _saveCard().then((value) => _handleSavedCardState(context)),
              child: const Text('Salvar esse cartão virtual')),
        const SizedBox(height: 20)
      ],
      ElevatedButton(
          onPressed: () {
            showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return _buildBottomSheet(context);
                });
          },
          child: const Text('Gerar novo cartão virtual'))
    ])));
  }

  Widget _buildRowData(String title, String value) {
    return Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors().secundaryColor),
          textAlign: TextAlign.end),
      const SizedBox(width: 4),
      Text(value, style: TextStyle(fontSize: 16, color: AppColors().primaryColor), textAlign: TextAlign.center)
    ]);
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> _handleSavedCardState(BuildContext context) {
    return ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Cartão virtual salvo com sucesso!')));
  }

  Widget _buildBottomSheet(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          ListTile(
              leading: const Icon(Icons.input),
              title: const Text('Informar dados manualmente'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => VCardFormScreen(onSave: (card) {
                          widget.onNewCard(card);
                          setState(() {
                            currentCard = card;
                          });
                          _checkIfCardIsSaved();
                        })));
              }),
          ListTile(
              leading: const Icon(Icons.contacts),
              title: const Text('Buscar nos contatos'),
              onTap: () async {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ContactsScreen(onNewCard: (card) {
                          setState(() {
                            currentCard = card;
                            isCardSaved = false;
                          });
                          widget.onNewCard(card);
                        })));
              })
        ]));
  }
}
