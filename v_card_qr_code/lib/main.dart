import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter/widgets.dart';
import 'package:v_card_qr_code/helpers/color.dart';
import 'package:v_card_qr_code/screens/virtual_card/virtual_card_screen.dart';
import 'package:v_card_qr_code/screens/widgets/app_bar.dart';
import 'package:v_card_qr_code/screens/widgets/app_scaffold.dart';
import 'screens/virtual_card/saved_cards_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() => runApp(const VirtualCardProfile());

class VirtualCardProfile extends StatelessWidget {
  const VirtualCardProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Virtual Card Profile',
        theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: AppColors().primaryColor), useMaterial3: true),
        home: const MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  Map<String, String>? currentCard;
  late TabController _tabController;
  final List<Tab> tabs = <Tab>[const Tab(text: 'Cartão Virtual'), const Tab(text: 'Meus Cartões Virtuais')];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: tabs.length);
    _loadLastCard();
  }

  void _loadLastCard() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cardString = prefs.getString('last');
    if (cardString != null) {
      setState(() => currentCard = Map<String, String>.from(json.decode(cardString)));
    }
  }

  Future<void> _handleLastCardVisibility(Map<String, String> card) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('last', json.encode(card));
    _loadLastCard();
  }

  void onNewCard(Map<String, String> card) async {
    setState(() => currentCard = card);

    await _handleLastCardVisibility(card);
  }

  void onCardSelected(Map<String, String> card) async {
    setState(() => currentCard = card);

    await _handleLastCardVisibility(card);

    setState(() => _tabController.index = 0);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return PopScope(
        canPop: false,
        child: AppScaffold(
          appBar: const AppAppBar(
            title: 'Virtual Card Profile',
          ),
          body: Column(
            children: [
              // Container(
              //   color: AppColors().secundaryColor,
              //   child: Padding(
              //     padding: const EdgeInsets.only(left: 58.0, right: 58.0, top: 0),
              //     child: Image.asset('assets/images/app_footer.png', fit: BoxFit.contain),
              //   ),
              // ),
              Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [AppColors().secundaryColor, AppColors().secundaryColor])),
                child: TabBar(
                    controller: _tabController,
                    tabs: tabs,
                    labelColor: Colors.white,
                    indicatorColor: Colors.white,
                    unselectedLabelColor: Colors.white54),
              ),
              Expanded(
                child: TabBarView(controller: _tabController, children: [
                  VirtualCardScreen(onNewCard: onNewCard, card: currentCard),
                  SavedCardsScreen(onCardSelected: onCardSelected)
                ]),
              ),
            ],
          ),
          bottomNavigationBar:
              // _tabController.index == 0 ? Image.asset('assets/images/app_footer.jpg', fit: BoxFit.cover) : null,
              Container(
            color: AppColors().secundaryColor,
            child: Padding(
              padding: const EdgeInsets.only(left: 58.0, right: 58.0, top: 0),
              child: Image.asset('assets/images/app_footer.png', fit: BoxFit.contain),
            ),
          ),
        ));
  }
}
