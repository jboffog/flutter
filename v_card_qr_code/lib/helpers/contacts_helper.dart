import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class ContactsHelper {
  Widget buildTitleRowData(String title, Size size, {bool showDivider = true}) {
    return Padding(
        padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
        child: Column(children: [
          if (showDivider)
            Padding(
                padding: EdgeInsets.only(left: size.width * 0.40, right: size.width * 0.40),
                child: const Divider(color: Colors.grey, thickness: 1)),
          Text(title, textAlign: TextAlign.left, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
        ]));
  }

  Widget buildTextField(
      TextEditingController controller, String label, Function(String)? onChanged, Function(String)? onFieldSubmitted,
      {bool readOnly = false,
      String? Function(String?)? validator,
      TextInputAction? textInputAction,
      FocusNode? focusNode,
      List<TextInputFormatter>? inputFormatters,
      TextInputType? keyboardType}) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: TextFormField(
            keyboardType: keyboardType,
            controller: controller,
            decoration: InputDecoration(labelText: label),
            readOnly: readOnly,
            validator: validator,
            onChanged: onChanged,
            textInputAction: textInputAction,
            focusNode: focusNode,
            inputFormatters: inputFormatters,
            onFieldSubmitted: onFieldSubmitted));
  }

  String? getPhone(List<Phone> phones, String label) {
    for (var phone in phones) {
      if (phone.label.name == label) {
        return phone.number;
      }
    }
    return null;
  }

  String? getURL(List<Website> sites, String label) {
    for (var site in sites) {
      if (site.label.name == label) {
        return site.url;
      }
    }
    return null;
  }

  String? getEmail(List<Email> emails, String label) {
    for (var email in emails) {
      if (email.label.name == label) {
        return email.address;
      }
    }
    return null;
  }

  Organization? getOrganization(List<Organization> organizations) {
    if (organizations.isNotEmpty) {
      return organizations.first;
    }
    return null;
  }

  String? getAddress(List<Address> addresses, String label) {
    for (var address in addresses) {
      if (address.label.name == label) {
        return address.toString();
      }
    }
    return null;
  }

  String getCompleteName(Map<String, String> card) {
    String fullName;
    fullName = card['firstName']!;
    if (card['middleName']!.isNotEmpty) {
      fullName = '$fullName ${card['middleName']!}';
    }
    if (card['lastName']!.isNotEmpty) {
      fullName = '$fullName ${card['lastName']!}';
    }

    return fullName;
  }
}
