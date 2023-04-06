import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import 'package:url_launcher/url_launcher.dart';

import '../../../applocalizations.dart';
import '../../../widgets/snackbar.dart';

class DonateLogic extends GetxController {
  showDogeCopied(BuildContext context) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context)
        .showSnackBar(MySnackBar(AppLocalizations.of(context).translate('dogeAddressCopied'), 'dogeAddressCopied', false, context: context));
  }

  final _url = 'https://idpay.ir/todoapp';
  final _dogeAdress = 'bnb1g3thz6z0t2gz2fffthdvv6mxpjvgfacp7hfjml';
  Future<void> copyDogeAdress() async {
    ClipboardData data = ClipboardData(text: _dogeAdress);
    print(data.text);
    await Clipboard.setData(data);
  }

  void launchURL() async {
    await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
  }
}
