import 'package:flutter/material.dart';
import 'package:v_card_qr_code/helpers/contacts_helper.dart';
import 'package:v_card_qr_code/screens/widgets/app_bar.dart';
import 'package:v_card_qr_code/screens/widgets/app_scaffold.dart';
import 'package:vcard_maintained/vcard_maintained.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

class VCardFormScreen extends StatefulWidget {
  final Map<String, String>? initialCard;
  final Function(Map<String, String>) onSave;

  const VCardFormScreen({super.key, this.initialCard, required this.onSave});

  @override
  VCardFormScreenState createState() => VCardFormScreenState();
}

class VCardFormScreenState extends State<VCardFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _buttonEnabled = ValueNotifier<bool>(false);

  final vCard = VCard();

  final RegExp regexTelefoneGlobal = RegExp(r'^[0-9.()+\- ]{1,20}$');
  final RegExp regexEmail = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  final RegExp regexURL = RegExp(r'^[^\s/$.?#].[^\s]*$');

  late TextEditingController firstNameController = TextEditingController();
  late TextEditingController middleNameController = TextEditingController();
  late TextEditingController lastNameController = TextEditingController();
  late TextEditingController cellPhoneController = TextEditingController();
  late TextEditingController homePhoneController = TextEditingController();
  late TextEditingController workPhoneController = TextEditingController();
  late TextEditingController workEmailController = TextEditingController();
  late TextEditingController emailController = TextEditingController();
  late TextEditingController otherEmailController = TextEditingController();
  late TextEditingController jobTitleController = TextEditingController();
  late TextEditingController organizationController = TextEditingController();
  late TextEditingController urlController = TextEditingController();
  late TextEditingController workUrlController = TextEditingController();
  late TextEditingController noteController = TextEditingController();
  late TextEditingController otherPhoneController = TextEditingController();

  final firstNameFocusNode = FocusNode();
  final middleNameFocusNode = FocusNode();
  final lastNameFocusNode = FocusNode();
  final cellPhoneFocusNode = FocusNode();
  final homePhoneFocusNode = FocusNode();
  final workPhoneFocusNode = FocusNode();
  final emailFocusNode = FocusNode();
  final urlFocusNode = FocusNode();
  final workEmailFocusNode = FocusNode();
  final workUrlFocusNode = FocusNode();
  final otherEmailFocusNode = FocusNode();
  final jobTitleFocusNode = FocusNode();
  final noteFocusNode = FocusNode();
  final otherPhoneFocusNode = FocusNode();
  final organizationFocusNonde = FocusNode();

  @override
  void initState() {
    super.initState();
    if (widget.initialCard != null) {
      firstNameController = TextEditingController(text: widget.initialCard!['firstName']);
      middleNameController = TextEditingController(text: widget.initialCard!['middleName']);
      lastNameController = TextEditingController(text: widget.initialCard!['lastName']);
      cellPhoneController = TextEditingController(text: widget.initialCard!['cellPhone']);
      homePhoneController = TextEditingController(text: widget.initialCard!['homePhone']);
      workPhoneController = TextEditingController(text: widget.initialCard!['workPhone']);
      workEmailController = TextEditingController(text: widget.initialCard!['workEmail']);
      emailController = TextEditingController(text: widget.initialCard!['email']);
      otherEmailController = TextEditingController(text: widget.initialCard!['otherEmail']);
      jobTitleController = TextEditingController(text: widget.initialCard!['jobTitle']);
      organizationController = TextEditingController(text: widget.initialCard!['organization']);
      urlController = TextEditingController(text: widget.initialCard!['url']);
      workUrlController = TextEditingController(text: widget.initialCard!['workUrl']);
      noteController = TextEditingController(text: widget.initialCard!['note']);
      otherPhoneController = TextEditingController(text: widget.initialCard!['otherPhone']);
    }

    _addListeners();
    _validateForm();
  }

  void _addListeners() {
    firstNameController.addListener(_validateForm);
    middleNameController.addListener(_validateForm);
    lastNameController.addListener(_validateForm);
    cellPhoneController.addListener(_validateForm);
    homePhoneController.addListener(_validateForm);
    workPhoneController.addListener(_validateForm);
    workEmailController.addListener(_validateForm);
    emailController.addListener(_validateForm);
    otherEmailController.addListener(_validateForm);
    jobTitleController.addListener(_validateForm);
    organizationController.addListener(_validateForm);
    urlController.addListener(_validateForm);
    workUrlController.addListener(_validateForm);
    noteController.addListener(_validateForm);
    otherPhoneController.addListener(_validateForm);
  }

  void _validateForm() {
    bool isValid = _formKey.currentState?.validate() ?? false;
    bool isAnyFieldNotEmpty = [
      firstNameController.text,
      middleNameController.text,
      lastNameController.text,
      cellPhoneController.text,
      homePhoneController.text,
      workPhoneController.text,
      workEmailController.text,
      emailController.text,
      otherEmailController.text,
      jobTitleController.text,
      urlController.text,
      workUrlController.text,
      noteController.text,
      otherPhoneController.text,
    ].any((element) => element.isNotEmpty);

    _buttonEnabled.value = isValid || isAnyFieldNotEmpty;
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      final vCard = VCard();
      if (widget.initialCard != null) {
        vCard.uid = widget.initialCard!['uid'];
      } else {
        vCard.uid = DateTime.now().millisecondsSinceEpoch.toString();
      }
      vCard.firstName = firstNameController.text.trim();
      vCard.middleName = middleNameController.text.trim();
      vCard.lastName = lastNameController.text.trim();
      vCard.cellPhone = cellPhoneController.text.trim();
      vCard.homePhone = homePhoneController.text.trim();
      vCard.workPhone = workPhoneController.text.trim();
      vCard.workEmail = workEmailController.text.trim();
      vCard.email = emailController.text.trim();
      vCard.otherEmail = otherEmailController.text.trim();
      vCard.jobTitle = jobTitleController.text.trim();
      vCard.organization = organizationController.text.trim();
      vCard.url = urlController.text.trim();
      vCard.workUrl = workUrlController.text.trim();
      vCard.note = noteController.text.trim();
      vCard.otherPhone = otherPhoneController.text.trim();

      Map<String, String> card = {
        'vCard': vCard.getFormattedString(),
        'uid': vCard.uid.toString(),
        'firstName': firstNameController.text.trim(),
        'middleName': middleNameController.text.trim(),
        'lastName': lastNameController.text.trim(),
        'cellPhone': cellPhoneController.text.trim(),
        'homePhone': homePhoneController.text.trim(),
        'workPhone': workPhoneController.text.trim(),
        'workEmail': workEmailController.text.trim(),
        'email': emailController.text.trim(),
        'otherEmail': otherEmailController.text.trim(),
        'jobTitle': jobTitleController.text.trim(),
        'organization': organizationController.text.trim(),
        'url': urlController.text.trim(),
        'workUrl': workUrlController.text.trim(),
        'note': noteController.text.trim(),
        'otherPhone': otherPhoneController.text.trim(),
      };

      widget.onSave(card);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        appBar: AppAppBar(title: widget.initialCard == null ? 'Novo Cartão Virtual' : 'Editar Cartão Virtual'),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
                key: _formKey,
                child: ListView(children: [
                  ContactsHelper()
                      .buildTitleRowData('Dados Pessoais:', MediaQuery.of(context).size, showDivider: false),
                  ContactsHelper().buildTextField(firstNameController, 'Nome', _onChangedTextField, (_) {
                    FocusScope.of(context).requestFocus(middleNameFocusNode);
                  }, validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe o primeiro nome.';
                    }
                    return null;
                  }, textInputAction: TextInputAction.next, focusNode: firstNameFocusNode),
                  ContactsHelper().buildTextField(middleNameController, 'Nome do Meio', _onChangedTextField, (_) {
                    FocusScope.of(context).requestFocus(lastNameFocusNode);
                  }, textInputAction: TextInputAction.next, focusNode: middleNameFocusNode),
                  ContactsHelper().buildTextField(lastNameController, 'Sobrenome', _onChangedTextField, (_) {
                    FocusScope.of(context).requestFocus(cellPhoneFocusNode);
                  }, textInputAction: TextInputAction.next, focusNode: lastNameFocusNode),
                  ContactsHelper().buildTextField(cellPhoneController, 'Celular', _onChangedTextField, (_) {
                    FocusScope.of(context).requestFocus(homePhoneFocusNode);
                  }, validator: (value) {
                    if (value != null && value.isNotEmpty && !regexTelefoneGlobal.hasMatch(value)) {
                      return 'Informe um celular válido.';
                    }
                    return null;
                  },
                      textInputAction: TextInputAction.next,
                      focusNode: cellPhoneFocusNode,
                      inputFormatters: [PhoneInputFormatter()],
                      keyboardType: TextInputType.phone),
                  ContactsHelper().buildTextField(homePhoneController, 'Tel. Residencial', _onChangedTextField, (_) {
                    FocusScope.of(context).requestFocus(emailFocusNode);
                  }, validator: (value) {
                    if (value != null && value.isNotEmpty && !regexTelefoneGlobal.hasMatch(value)) {
                      return 'Informe um telefone válido.';
                    }
                    return null;
                  },
                      textInputAction: TextInputAction.next,
                      focusNode: homePhoneFocusNode,
                      inputFormatters: [PhoneInputFormatter()],
                      keyboardType: TextInputType.phone),
                  ContactsHelper().buildTextField(emailController, 'Email', _onChangedTextField, (_) {
                    FocusScope.of(context).requestFocus(urlFocusNode);
                  }, validator: (value) {
                    if (value != null && value.isNotEmpty && !regexEmail.hasMatch(value)) {
                      return 'Informe um email válido.';
                    }
                    return null;
                  }, textInputAction: TextInputAction.next, focusNode: emailFocusNode),
                  ContactsHelper().buildTextField(urlController, 'URL', _onChangedTextField, (_) {
                    FocusScope.of(context).requestFocus(organizationFocusNonde);
                  }, validator: (value) {
                    if (value != null && value.isNotEmpty && !regexURL.hasMatch(value)) {
                      return 'Informe uma URL válida.';
                    }
                    return null;
                  }, textInputAction: TextInputAction.next, focusNode: urlFocusNode, keyboardType: TextInputType.url),
                  ContactsHelper().buildTitleRowData('Dados Empresarias:', MediaQuery.of(context).size),
                  ContactsHelper().buildTextField(organizationController, 'Organização', _onChangedTextField, (_) {
                    FocusScope.of(context).requestFocus(jobTitleFocusNode);
                  }, readOnly: false, textInputAction: TextInputAction.next, focusNode: organizationFocusNonde),
                  ContactsHelper().buildTextField(jobTitleController, 'Cargo', _onChangedTextField, (_) {
                    FocusScope.of(context).requestFocus(workPhoneFocusNode);
                  }, textInputAction: TextInputAction.next, focusNode: jobTitleFocusNode),
                  ContactsHelper().buildTextField(workPhoneController, 'Celular Empresarial', _onChangedTextField, (_) {
                    FocusScope.of(context).requestFocus(workEmailFocusNode);
                  }, validator: (value) {
                    if (value != null && value.isNotEmpty && !regexTelefoneGlobal.hasMatch(value)) {
                      return 'Informe um telefone válido.';
                    }
                    return null;
                  },
                      textInputAction: TextInputAction.next,
                      focusNode: workPhoneFocusNode,
                      inputFormatters: [PhoneInputFormatter()],
                      keyboardType: TextInputType.phone),
                  ContactsHelper().buildTextField(workEmailController, 'Email Empresarial', _onChangedTextField, (_) {
                    FocusScope.of(context).requestFocus(workUrlFocusNode);
                  }, validator: (value) {
                    if (value != null && value.isNotEmpty && !regexEmail.hasMatch(value)) {
                      return 'Informe um email válido.';
                    }
                    return null;
                  },
                      textInputAction: TextInputAction.next,
                      focusNode: workEmailFocusNode,
                      keyboardType: TextInputType.emailAddress),
                  ContactsHelper().buildTextField(workUrlController, 'URL do Trabalho', _onChangedTextField, (_) {
                    FocusScope.of(context).requestFocus(otherEmailFocusNode);
                  }, validator: (value) {
                    if (value != null && value.isNotEmpty && !regexURL.hasMatch(value)) {
                      return 'Informe uma URL válida.';
                    }
                    return null;
                  },
                      textInputAction: TextInputAction.next,
                      focusNode: workUrlFocusNode,
                      keyboardType: TextInputType.url),
                  ContactsHelper().buildTitleRowData('Outros dados:', MediaQuery.of(context).size),
                  ContactsHelper().buildTextField(otherEmailController, 'Email (Outro)', _onChangedTextField, (_) {
                    FocusScope.of(context).requestFocus(otherPhoneFocusNode);
                  }, validator: (value) {
                    if (value != null && value.isNotEmpty && !regexEmail.hasMatch(value)) {
                      return 'Informe um email válido.';
                    }
                    return null;
                  },
                      textInputAction: TextInputAction.next,
                      focusNode: otherEmailFocusNode,
                      keyboardType: TextInputType.emailAddress),
                  ContactsHelper().buildTextField(otherPhoneController, 'Tel. (Outro)', _onChangedTextField, (_) {
                    FocusScope.of(context).requestFocus(noteFocusNode);
                  }, validator: (value) {
                    if (value != null && value.isNotEmpty && !regexTelefoneGlobal.hasMatch(value)) {
                      return 'Informe um telefone válido.';
                    }
                    return null;
                  },
                      textInputAction: TextInputAction.next,
                      focusNode: otherPhoneFocusNode,
                      inputFormatters: [PhoneInputFormatter()],
                      keyboardType: TextInputType.phone),
                  ContactsHelper().buildTextField(noteController, 'Nota', _onChangedTextField, null,
                      textInputAction: TextInputAction.done, focusNode: noteFocusNode),
                  const SizedBox(height: 20),
                  ValueListenableBuilder<bool>(
                      valueListenable: _buttonEnabled,
                      builder: (context, isEnabled, child) {
                        return ElevatedButton(
                            onPressed: isEnabled ? _saveForm : null,
                            child: Text(widget.initialCard == null ? 'Gerar QrCode' : 'Salvar'));
                      })
                ]))));
  }

  _onChangedTextField(_) => _validateForm();
}
