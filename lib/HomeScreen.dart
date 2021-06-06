import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/rendering.dart';
import 'package:icar/functions.dart';
import 'package:icar/globalVar.dart';
import 'package:timeago/timeago.dart' as tAgo;

class HomeScreen extends StatefulWidget {
  //const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var variable;
  FirebaseAuth auth = FirebaseAuth.instance;
  String userName;
  String userNumber;
  String carPrice;
  String carModel;
  String carColor;
  String description;
  String urlImage;
  String carLocation;
  QuerySnapshot cars;

  carMethods carObj = new carMethods();

  Future showDialogForAddingData() async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Post a New Ad",
              style: TextStyle(
                  fontSize: 24, fontFamily: 'Bebas', letterSpacing: 2.0),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter Name',
                  ),
                  onChanged: (value) {
                    this.userName = value;
                  },
                ),
                SizedBox(
                  height: 5,
                ),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter Number',
                  ),
                  onChanged: (value) {
                    this.userNumber = value;
                  },
                ),
                SizedBox(
                  height: 5,
                ),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter Car Price',
                  ),
                  onChanged: (value) {
                    this.carPrice = value;
                  },
                ),
                SizedBox(
                  height: 5,
                ),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter Car Model',
                  ),
                  onChanged: (value) {
                    this.carModel = value;
                  },
                ),
                SizedBox(
                  height: 5,
                ),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter Car Color',
                  ),
                  onChanged: (value) {
                    this.carColor = value;
                  },
                ),
                SizedBox(
                  height: 5,
                ),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter Description',
                  ),
                  onChanged: (value) {
                    this.description = value;
                  },
                ),
                SizedBox(
                  height: 5,
                ),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter Image URL',
                  ),
                  onChanged: (value) {
                    this.urlImage = value;
                  },
                ),
                SizedBox(
                  height: 5,
                ),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter Car Location',
                  ),
                  onChanged: (value) {
                    this.carLocation = value;
                  },
                ),
                SizedBox(
                  height: 5,
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel")),
              ElevatedButton(
                onPressed: () {
                  Map<String, dynamic> carData = {
                    'userName': this.userName,
                    'uId': userId,
                    'userNumber': this.userNumber,
                    'carPrice': this.carPrice,
                    'carModel': this.carModel,
                    'carColor': this.carColor,
                    'carLocation': this.carLocation,
                    'description': this.description,
                    'urlImage': this.urlImage,
                    'imgPro': userImageUrl,
                    'time': DateTime.now(),
                  };
                  carObj.addData(carData).then((value) {
                    print("Data added Successfully");
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomeScreen()));
                  }).catchError((onError) {
                    print(onError);
                  });
                },
                child: Text('Add Now'),
              ),
            ],
          );
        });
  }

  getMyData() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get()
        .then((results) {
      setState(() {
        userImageUrl = results.data()['imgPro'];
        getUserName = results.data()['userName'];
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userId = FirebaseAuth.instance.currentUser.uid;
    userEmail = FirebaseAuth.instance.currentUser.email;
    carObj.getData().then((results) {
      setState(() {
        cars = results;
      });
    });

    getMyData();
  }

  @override
  Widget build(BuildContext context) {
    Widget showCarList() {
      if (cars != null) {
        return ListView.builder(
          itemBuilder: (context, i) {
            return Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  ListTile(
                      leading: GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: NetworkImage(
                                  cars.docs[i]['imgPro'],
                                ),
                                fit: BoxFit.fill),
                          ),
                        ),
                      ),
                      title: GestureDetector(
                        onTap: () {},
                        child: Text(cars.docs[i]['userName']??[]),
                      ),
                      subtitle: GestureDetector(
                        onTap: () {},
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              cars.docs[i]['carLocation'],
                              style: TextStyle(
                                color: Colors.black.withOpacity(0.6),
                              ),
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Icon(
                              Icons.location_pin,
                              color: Colors.grey,
                            )
                          ],
                        ),
                      ),
                      trailing: cars.docs[i]['uId'] == userId
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GestureDetector(
                                  onTap: () {},
                                  child: Icon(Icons.edit_outlined),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                GestureDetector(
                                  onTap: () {},
                                  child: Icon(Icons.delete_forever_sharp),
                                )
                              ],
                            )
                          : Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [],
                            )),
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Image.network(
                      cars.docs[i]['urlImage'],
                      fit: BoxFit.fill,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      ('\$ ' + cars.docs[i]['carPrice']),
                      style: TextStyle(
                          fontFamily: "Bebas", letterSpacing: 2, fontSize: 24),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15, right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.directions_car),
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Align(
                                child: Text(cars.docs[i]['carModel']),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.watch_later_outlined),
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Align(
                                child: Text(tAgo.format(
                                    (cars.docs[i]['time']).toDate())),
                                alignment: Alignment.topLeft,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15, right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.brush_outlined),
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Align(
                                child: Text(cars.docs[i]['carColor']),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.phone_android),
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Align(
                                child: Text(cars.docs[i]['userNumber']),
                                alignment: Alignment.topLeft,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15, right: 15),
                    child: Text(
                      cars.docs[i]['description'],
                      textAlign: TextAlign.justify,
                      style: TextStyle(color: Colors.black.withOpacity(0.6)),
                    ),
                  ),
                  SizedBox(height: 10,)
                ],
              ),
            );
          },
          itemCount: cars.docs.length,
          padding: EdgeInsets.all(10),
        );
      }
      else{
        return Text("Loading...!!");
      }
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.refresh,
            color: Colors.white,
          ),
          onPressed: () {},
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Icon(
                Icons.person,
                color: Colors.white,
              ),
            ),
          ),
          TextButton(
            onPressed: () {},
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Icon(
                Icons.search,
                color: Colors.white,
              ),
            ),
          ),
          TextButton(
            onPressed: () {},
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Icon(
                Icons.login_outlined,
                color: Colors.white,
              ),
            ),
          ),
        ],
        flexibleSpace: Container(
          decoration: new BoxDecoration(
            gradient: new LinearGradient(
                colors: [Colors.black, Colors.redAccent],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp),
          ),
        ),
        title: Text("Home Page"),
      ),
      body: Center(
        child: Container(
          child: showCarList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialogForAddingData();
        },
        tooltip: 'Add post',
        child: Icon(Icons.add),
      ),
    );
  }
}
