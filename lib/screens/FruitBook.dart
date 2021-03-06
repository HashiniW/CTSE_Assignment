import 'package:learn_a_fruit_flutter_app/api/fruit_api.dart';
import 'package:learn_a_fruit_flutter_app/notifier/auth_notifier.dart';
import 'package:learn_a_fruit_flutter_app/notifier/fruit_notifier.dart';
import 'package:learn_a_fruit_flutter_app/screens/fruit_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:learn_a_fruit_flutter_app/screens/detail.dart';

class FruitBook extends StatefulWidget {
  @override
  _FruitBookState createState() => _FruitBookState();
}

class _FruitBookState extends State<FruitBook> {
  @override
  void initState() {
    FruitNotifier fruitNotifier = Provider.of<FruitNotifier>(context, listen: false);
    getFruits(fruitNotifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context);
    FruitNotifier fruitNotifier = Provider.of<FruitNotifier>(context);

    Future<void> _refreshList() async {
      getFruits(fruitNotifier);
    }

    print("Opening Fruit Book");
    return Scaffold(
      appBar: AppBar(
        title: Text(
          authNotifier.user != null ? authNotifier.user.displayName : "Fruit Book",
        ),
        actions: <Widget>[
          // action button
          FlatButton(
            onPressed: () => signout(authNotifier),
            child: Text(
              "Logout",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
        ],
      ),
      body: new RefreshIndicator(
        child: ListView.separated(
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              leading: Image.network(
                fruitNotifier.fruitList[index].image != null
                    ? fruitNotifier.fruitList[index].image
                    : 'https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg',
                width: 300,
                fit: BoxFit.cover,
              ),
              title: Text(fruitNotifier.fruitList[index].name),
              subtitle: Text(fruitNotifier.fruitList[index].category),
              onTap: () {
                fruitNotifier.currentFruit = fruitNotifier.fruitList[index];
                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                  return FruitDetail();
                }));
              },
            );
          },
          itemCount: fruitNotifier.fruitList.length,
          separatorBuilder: (BuildContext context, int index) {
            return Divider(
              color: Colors.black,
            );
          },
        ),
        onRefresh: _refreshList,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          fruitNotifier.currentFruit = null;
          Navigator.of(context).push(
            MaterialPageRoute(builder: (BuildContext context) {
              return FruitForm(
                isUpdating: false,
              );
            }),
          );
        },
        child: Icon(Icons.add),
        foregroundColor: Colors.white,
      ),
    );
  }
}
