import 'package:diatribapp/blocs/artist_bloc.dart';
import 'package:diatribapp/blocs/news_bloc.dart';
import 'package:diatribapp/blocs/profile_bloc.dart';
import 'package:diatribapp/feed_page.dart';
import 'package:diatribapp/my_shows.dart';
import 'package:diatribapp/profile/profile_page.dart';
import 'package:diatribapp/search_artist_page.dart';
import 'package:diatribapp/sign_in_page.dart';
import 'package:diatribapp/tema.dart';
import 'package:diatribapp/util.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

import 'blocs/posts_bloc.dart';
import 'blocs/user_bloc.dart';
import 'models/Event.dart';
import 'services/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Diatribapp'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String initialPage = 'Feed';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        bloc: UserBloc(),
        child: MaterialApp(
            title: 'myDentist',
            theme: ThemeData(brightness: Brightness.light),
            home: currentUser != null
                ? NavBarPage(
                    initialPage: initialPage.isNotEmpty ? initialPage : null,
                  )
                : BlocProvider(child: SignInWidget(), bloc: UserBloc())));
  }
}

class NavBarPage extends StatefulWidget {
  NavBarPage({Key? key, this.initialPage}) : super(key: key);

  final String? initialPage;

  @override
  _NavBarPageState createState() => _NavBarPageState();
}

/// This is the private State class that goes with NavBarPage.
class _NavBarPageState extends State<NavBarPage> {
  String _currentPage = 'Feed';

  List<Event> shows = [];
  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialPage ?? _currentPage;
  }

  @override
  Widget build(BuildContext context) {
    final tabs = {
      'Feed': BlocProvider(bloc: PostsBloc(), child: FeedWidget()),
      'News': BlocProvider(bloc: NewsBloc(), child: MyShowsWidget()),
      'Search': BlocProvider(bloc: ArtistBloc(), child: SearchArtistWidget()),
      'Profile': BlocProvider(bloc: ProfileBloc(), child: ProfileWidget()),
    };
    final currentIndex = tabs.keys.toList().indexOf(_currentPage);
    return Scaffold(
      body: tabs[_currentPage],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (i) => setState(() => _currentPage = tabs.keys.toList()[i]),
        backgroundColor: Colors.white,
        selectedItemColor: Tema.of(context).spotifyColor,
        unselectedItemColor: Tema.of(context).darkGreen,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.feed_outlined,
              size: 24,
            ),
            activeIcon: Icon(
              Icons.feed_sharp,
              size: 24,
            ),
            label: 'Feed',
            tooltip: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.newspaper_outlined,
              size: 24,
            ),
            activeIcon: Icon(
              Icons.newspaper_sharp,
              size: 24,
            ),
            label: 'Novedades',
            tooltip: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search_rounded,
              size: 24,
            ),
            activeIcon: Icon(
              Icons.search_outlined,
              size: 24,
            ),
            label: 'Search',
            tooltip: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_outline,
              size: 24,
            ),
            activeIcon: Icon(
              Icons.person,
              size: 24,
            ),
            label: 'Perfil',
            tooltip: '',
          ),
        ],
      ),
    );
  }
}
