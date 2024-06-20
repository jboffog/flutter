import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:v_card_qr_code/helpers/contacts_helper.dart';
import 'package:v_card_qr_code/screens/widgets/app_bar.dart';
import 'package:v_card_qr_code/screens/widgets/app_scaffold.dart';

class ContactDetailsScreen extends StatefulWidget {
  final Contact contact;
  final Function(Contact) onGenerateVCard;

  const ContactDetailsScreen({super.key, required this.contact, required this.onGenerateVCard});

  @override
  State<ContactDetailsScreen> createState() => _ContactDetailsScreenState();
}

class _ContactDetailsScreenState extends State<ContactDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        appBar: const AppAppBar(title: 'Detalhes do Contato'),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(shrinkWrap: true, children: [
              if (_hasPersonalData(widget.contact))
                ContactsHelper().buildTitleRowData('Dados Pessoais:', MediaQuery.of(context).size, showDivider: false),
              _buildDetailRow('Nome Completo', widget.contact.displayName),
              _buildDetailRow('Nome', widget.contact.name.first),
              _buildDetailRow('Nome do Meio', widget.contact.name.middle),
              _buildDetailRow('Sobrenome', widget.contact.name.last),
              _buildDetailRow('Prefixo', widget.contact.name.prefix),
              _buildDetailRow('Sufixo', widget.contact.name.suffix),
              _buildDetailRow('Celular', ContactsHelper().getPhone(widget.contact.phones, PhoneLabel.mobile.name)),
              _buildDetailRow('Telefone Res.', ContactsHelper().getPhone(widget.contact.phones, PhoneLabel.home.name)),
              _buildDetailRow(
                  'Endereço Res.', ContactsHelper().getAddress(widget.contact.addresses, AddressLabel.home.name)),
              _buildDetailRow('Email', ContactsHelper().getEmail(widget.contact.emails, EmailLabel.home.name)),
              _buildDetailRow('Url', ContactsHelper().getURL(widget.contact.websites, WebsiteLabel.home.name)),
              _buildDetailRow(
                  'Url secundária', ContactsHelper().getURL(widget.contact.websites, WebsiteLabel.homepage.name)),
              /////////////////////////////////
              if (_hasOrganizacionalData(widget.contact))
                ContactsHelper().buildTitleRowData('Dados Empresarias:', MediaQuery.of(context).size),
              _buildDetailRow('Organização', ContactsHelper().getOrganization(widget.contact.organizations)?.company),
              _buildDetailRow('Cargo', ContactsHelper().getOrganization(widget.contact.organizations)?.title),
              _buildDetailRow('Email', ContactsHelper().getEmail(widget.contact.emails, EmailLabel.work.name)),
              _buildDetailRow('Telefone', ContactsHelper().getPhone(widget.contact.phones, PhoneLabel.work.name)),
              _buildDetailRow(
                  'Endereço', ContactsHelper().getAddress(widget.contact.addresses, AddressLabel.work.name)),
              _buildDetailRow('Url', ContactsHelper().getURL(widget.contact.websites, WebsiteLabel.work.name)),
              /////////////////////////////////
              if (_hasOtherData(widget.contact))
                ContactsHelper().buildTitleRowData('Outros dados:', MediaQuery.of(context).size),
              _buildDetailRow('Tel. (Outro)', ContactsHelper().getPhone(widget.contact.phones, PhoneLabel.other.name)),
              _buildDetailRow('Url (Outro)', ContactsHelper().getURL(widget.contact.websites, WebsiteLabel.other.name)),
              _buildDetailRow('Url Custom', ContactsHelper().getURL(widget.contact.websites, WebsiteLabel.custom.name)),
              _buildDetailRow('Nota', widget.contact.notes.isNotEmpty ? widget.contact.notes.first.note : null),

              const SizedBox(height: 20),
              UnconstrainedBox(
                  child: SizedBox(
                      width: 180,
                      child: ElevatedButton(
                          onPressed: () {
                            widget.onGenerateVCard(widget.contact);
                            Navigator.of(context).pop();
                          },
                          child: const Text('Gerar vCard'))))
            ])));
  }

  bool _hasPersonalData(Contact contact) {
    return (widget.contact.displayName.isNotEmpty ||
        widget.contact.name.first.isNotEmpty ||
        widget.contact.name.middle.isNotEmpty ||
        widget.contact.name.last.isNotEmpty ||
        widget.contact.name.prefix.isNotEmpty ||
        widget.contact.name.suffix.isNotEmpty ||
        ContactsHelper().getPhone(widget.contact.phones, PhoneLabel.mobile.name) != null ||
        ContactsHelper().getAddress(widget.contact.addresses, AddressLabel.home.name) != null ||
        ContactsHelper().getEmail(widget.contact.emails, EmailLabel.home.name) != null ||
        ContactsHelper().getURL(widget.contact.websites, WebsiteLabel.home.name) != null ||
        ContactsHelper().getURL(widget.contact.websites, WebsiteLabel.homepage.name) != null);
  }

  bool _hasOrganizacionalData(Contact contact) {
    return (ContactsHelper().getURL(widget.contact.websites, WebsiteLabel.work.name) != null ||
        ContactsHelper().getAddress(widget.contact.addresses, AddressLabel.work.name) != null ||
        ContactsHelper().getPhone(widget.contact.phones, PhoneLabel.work.name) != null ||
        ContactsHelper().getEmail(widget.contact.emails, EmailLabel.work.name) != null ||
        ContactsHelper().getOrganization(widget.contact.organizations)?.company != null ||
        ContactsHelper().getOrganization(widget.contact.organizations)?.title != null);
  }

  bool _hasOtherData(Contact contact) {
    return (ContactsHelper().getPhone(widget.contact.phones, PhoneLabel.other.name) != null ||
        ContactsHelper().getURL(widget.contact.websites, WebsiteLabel.other.name) != null ||
        ContactsHelper().getURL(widget.contact.websites, WebsiteLabel.custom.name) != null ||
        (widget.contact.notes.isNotEmpty && widget.contact.notes.first.note.isNotEmpty));
  }

  Widget _buildDetailRow(String label, String? value) {
    return value != null && value.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
              Flexible(child: Text(value))
            ]))
        : const SizedBox();
  }
}
