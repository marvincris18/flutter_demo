import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/auth_state.dart';
import 'screens/login_screen.dart';
import 'widgets/user_profile_widget.dart';
import 'screens/demo_auth_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MyAppState()),
        ChangeNotifierProvider(create: (context) => AuthState()),
      ],
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: Consumer<AuthState>(
          builder: (context, authState, child) {
            if (authState.isLoading) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            
            if (authState.isAuthenticated) {
              return MyHomePage();
            } else {
              return const LoginScreen();
            }
          },
        ),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  var favorites = <WordPair>[];

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}


class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SafeArea(
            child: NavigationRail(
              extended: false,
              destinations: [
                NavigationRailDestination(
                  icon: Icon(Icons.home),
                  label: Text('Home'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.favorite),
                  label: Text('Favorites'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.person),
                  label: Text('Profile'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.bug_report),
                  label: Text('Demo'),
                ),
              ],
              selectedIndex: _selectedIndex,
              onDestinationSelected: (value) {
                setState(() {
                  _selectedIndex = value;
                });
              },
            ),
          ),
          Expanded(
            child: Container(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: _getSelectedPage(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getSelectedPage() {
    switch (_selectedIndex) {
      case 0:
        return GeneratorPage();
      case 1:
        return FavoritesPage();
      case 2:
        return ProfilePage();
      case 3:
        return DemoAuthPage();
      default:
        return GeneratorPage();
    }
  }
}


class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigCard(pair: pair),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                },
                icon: Icon(icon),
                label: Text('Like'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    
    if (appState.favorites.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 64,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            SizedBox(height: 16),
            Text(
              'No favorites yet',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Go to the home page and like some word pairs!',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: appState.favorites.length,
      itemBuilder: (context, index) {
        var pair = appState.favorites[index];
        return Card(
          child: ListTile(
            leading: Icon(Icons.favorite),
            title: Text(pair.asLowerCase),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                // Remove from favorites
                appState.favorites.remove(pair);
                appState.notifyListeners();
              },
            ),
          ),
        );
      },
    );
  }
}

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Profile',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          SizedBox(height: 16),
          UserProfileWidget(),
          SizedBox(height: 24),
          Consumer<MyAppState>(
            builder: (context, appState, child) {
              return Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Statistics',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(Icons.favorite, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Favorite words: ${appState.favorites.length}'),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ...

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
     final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
      
     );

     return Card(
      color: theme.colorScheme.primary,    // ← And also this.
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          pair.asLowerCase,
          style: style,
          semanticsLabel: "${pair.first} ${pair.second}",
        ),
      ),
    );  
    }
}   