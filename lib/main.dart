import 'package:flutter/material.dart';
import 'package:realm/realm.dart';

part 'main.g.dart';

@RealmModel()
class _Stuff {
  @PrimaryKey()
  @MapTo('_id')
  late ObjectId id;
}

final app = App(AppConfiguration('evil-app-mggjg'));
final userProvider = () async {
  return app.currentUser ?? await app.logIn(Credentials.anonymous());
}();

final realmProvider = () async {
  return Realm(Configuration.flexibleSync(
    await userProvider,
    [Stuff.schema],
  ));
}();

Future<void> main() async {
  final realm = await realmProvider;
  runApp(MyApp(realm: realm));
}

class MyApp extends StatelessWidget {
  final Realm realm;
  const MyApp({super.key, required this.realm});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Material(
        child: Center(
          child: Text(
            'successfully opened realm at:\n${realm.config.path}}',
          ),
        ),
      ),
    );
  }
}
