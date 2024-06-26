import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:v_card_qr_code/helpers/color.dart';
import 'package:v_card_qr_code/helpers/contacts_helper.dart';
import 'package:v_card_qr_code/screens/contacts/contacts_screen.dart';
import 'package:v_card_qr_code/screens/virtual_card/vcard_form_screen.dart';
import 'dart:convert';
import 'dart:ui' as ui;
import 'package:path_provider/path_provider.dart';

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
  static GlobalKey previewContainer = GlobalKey();

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
        Center(
            child: RepaintBoundary(
                key: previewContainer,
                child: Container(
                    color: AppColors().bgColor,
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      const SizedBox(height: 5),
                      _buildRowData('Nome:', ContactsHelper().getCompleteName(currentCard!)),
                      if (currentCard!['organization']!.isNotEmpty)
                        _buildRowData('Empresa:', currentCard!['organization']!),
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
                                  dataModuleStyle: QrDataModuleStyle(
                                      color: AppColors().secundaryColor, dataModuleShape: QrDataModuleShape.circle),
                                  eyeStyle:
                                      QrEyeStyle(color: AppColors().secundaryColor, eyeShape: QrEyeShape.circle)))),
                      const SizedBox(height: 10),
                    ]))))
      ],
      Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (currentCard != null && !isCardSaved)
                  ElevatedButton(
                      onPressed: () async => await _saveCard().then((value) => _handleSavedCardState(context)),
                      child: const Icon(Icons.save)),
                ElevatedButton(
                    onPressed: () => showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return _buildBottomSheetNewCard(context);
                        }),
                    child: const Icon(Icons.add)),
                if (currentCard != null)
                  ElevatedButton(
                      onPressed: () => showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return _buildBottomSheetCompartilharCard(context);
                          }),
                      child: const Icon(Icons.share))
              ]))
    ])));
  }

  Future<void> compartilharQrCode() async {
    String path = await tirarScreenshot(previewContainer);

    await Share.shareXFiles([XFile(path)]);
  }

  Future<String> tirarScreenshot(GlobalKey<State<StatefulWidget>> previewContainer) async {
    RenderRepaintBoundary boundary = previewContainer.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(pixelRatio: 2);
    final directory = (await getApplicationDocumentsDirectory()).path;
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();

    String path = '$directory/screenshot.png';
    File imgFile = File(path);
    await imgFile.writeAsBytes(pngBytes);
    return path;
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

  Widget _buildBottomSheetNewCard(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text('Gerar novo cartão virtual',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors().secundaryColor)),
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

  Widget _buildBottomSheetCompartilharCard(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text('Compartilhar esse cartão virtual',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors().secundaryColor)),
          ListTile(
              leading: const Icon(Icons.input),
              title: const Text('Compartilhar foto do QrCode'),
              onTap: () async {
                Navigator.of(context).pop();
                await compartilharQrCode();
              }),
          ListTile(
              leading: const Icon(Icons.contacts),
              title: const Text('Compartilhar arquivo VCF'),
              onTap: () async {
                Navigator.of(context).pop();
                shareVCFCard();
              })
        ]));
  }

  void shareVCFCard() async {
    try {
      String vCardName = ContactsHelper().getCompleteName(currentCard!);
      var vCardAsString = currentCard!['vCard']!;
      var contactAsFile = File(await getFilePath(vCardName.toString()));
      contactAsFile.writeAsString(vCardAsString);
      Share.shareXFiles([XFile(contactAsFile.path)]).then((value) => contactAsFile.deleteSync());
    } catch (e) {
      log("Error Creating VCF File $e");
      return null;
    }
  }

  Future<String> getFilePath(String fileName) async {
    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
    String appDocumentsPath = appDocumentsDirectory.path;
    String filePath = '$appDocumentsPath/$fileName.vcf';

    File file = File(filePath);
    if (await file.exists()) {
      //pra evitar um bug de share no whats
      file.delete();
    }

    file = File(filePath);

    return file.path;
  }
}
