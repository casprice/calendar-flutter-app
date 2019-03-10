import 'package:flutter/material.dart';

class ToDoListPage extends StatelessWidget {
  ToDoListPage();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do List',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: new MyApp(),
    );
  }
}

// This class calls the main page of the checklist
class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => new MyAppState();
}

// This is the state that extends MyApp that includes all the working functions
class MyAppState extends State<MyApp> {

  TextEditingController eCtrl = new TextEditingController();
  bool showDialog = false;

  static const String Archive = "Deleted Tasks";
  static const String Clear = "Clear All";

  // This is for the pop up menu
  static const List<String> choices = <String>[
    Archive,
  ];

  // List of all the to-do items
  static List<String> textList = [];

  // List of the boolean values for checkbox for each item
  static List<bool> checkValue = [];

  // List of things that people removed/completed
  static List<String> removedList = [];

  // List of boolean values for checkbox in the archive
  static List<bool> checkValueRemove = [];

  @override
  Widget build(BuildContext context) {
    //return new MaterialApp(
    return new Scaffold(
      // Helps with bottom overflow
        resizeToAvoidBottomPadding: true,
        // Creates the title bar
        appBar: new AppBar(
          title: new Text('To-Do List',
              style: TextStyle(color: Colors.white,
                  fontSize: 24.0)),
          backgroundColor: Colors.deepPurple,
          actions: <Widget>[

            // Button to add
            new IconButton(
              icon: new Icon(Icons.add_circle),
              onPressed: () {
                setState(() {
                  showDialog = true;
                });
              },
            ),

            // Button to delete
            new IconButton(
              icon: new Icon(Icons.delete),
              onPressed: () {
                int counter = 0;
                while (counter < textList.length) {
                  if (checkValue[counter] == true) {
                    // Adds deleted text into the deleted list
                    removedList.add(textList[counter]);
                    checkValueRemove.add(false);

                    // Removes from the list
                    checkValue.removeAt(counter);
                    textList.removeAt(counter);
                    counter = 0;
                  } else {
                    counter++;
                  }
                }
                setState(() {});
              },
            ),

            // Creates the popup menu to access deleted tasks
            new PopupMenuButton<String>(
              onSelected: choiceAction,
              itemBuilder: (BuildContext context) {
                return choices.map((String choice) {
                  return new PopupMenuItem(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ],
        ),

        // This is the background color
        backgroundColor: Colors.white,
        body: new Column(
          children: <Widget>[
            showDialog == true ?
            new AlertDialog(
              title: new Text("Add to your To-Do list"),
              content: new TextField(
                controller: eCtrl,
                decoration: new InputDecoration.collapsed(hintText: "ADD"),
                maxLines: 3,
                onSubmitted: (String text) { },
              ),
              actions: <Widget>[

                // This is the cancel button for to add a task into the task list
                new FlatButton(
                    onPressed: () {
                      setState(() {
                        showDialog = false;
                        eCtrl.clear();
                      });
                    },
                    child: new Text("CANCEL")
                ),

                // This is the button to add it into the task list
                new FlatButton(
                    onPressed: () {
                      setState(() {
                        showDialog = false;
                        if ((eCtrl.text.isNotEmpty)) {
                          textList.add(eCtrl.text);
                          checkValue.add(false);
                          eCtrl.clear();
                        }
                      });
                    },
                    child: new Text("OK!")
                )
              ],
            ) : new Text(""),

            // Construct the check list
            new Flexible(
                child: new ListView.builder(
                    itemCount: textList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return new Row(
                        children: <Widget>[
                          new Checkbox(
                            value: checkValue[index],
                            onChanged: (bool newValue) {
                              checkValue[index] = newValue;
                              setState(() { });
                            },
                          ),
                          new Text(textList[index]),
                        ],
                      );
                    })
            )
          ],
        )
    );
    //);
  }

  // This is called by the popup menu button to push the archived page
  void choiceAction(String choice) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SecondPage()),
    );
  }
}

// This is the class that creates the state for the second page
class SecondPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return new SecondPageState();
  }
}

// This is the second page for the archive list
class SecondPageState extends State<SecondPage> {

  @override
  void initState() {
    super.initState();
  }

  bool showReAddDialog = false;
  bool showDeleteDialog = false;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
            title: new Text("Archived List"),
            backgroundColor: Colors.lightGreen,
            actions: <Widget>[

              // Button to add back into the list from deleted
              new IconButton(
                icon: new Icon(Icons.add_circle),
                onPressed: () {

                  setState(() {
                    if ( MyAppState.checkValueRemove.contains(true) ) {
                      showReAddDialog = true;
                    }
                  });
                },
              ),

              // Button to permanently delete task
              new IconButton(
                  icon: new Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      if ( MyAppState.checkValueRemove.contains(true) ) {
                        showDeleteDialog = true;
                      }
                    });
                  }),
            ]
        ),
        backgroundColor: Colors.white,
        body: new Column(
          children: <Widget>[

            // Show alert dialog asking confirmation to recover deleted task
            showReAddDialog == true ?
            new AlertDialog(
              title: new Text("Re-add to your To-Do list?"),
              actions: <Widget>[

                // This is the button of to confirm yes
                new FlatButton(
                    onPressed: () {
                      int counterRemoved = 0;
                      while (counterRemoved < MyAppState.removedList.length) {
                        if (MyAppState.checkValueRemove[counterRemoved] ==
                            true) {
                          // Adds it back into the text list
                          MyAppState.textList.add(
                              MyAppState.removedList[counterRemoved]);
                          MyAppState.checkValue.add(false);

                          // Removes items from the deleted file
                          MyAppState.removedList.removeAt(counterRemoved);
                          MyAppState.checkValueRemove.removeAt(counterRemoved);

                          counterRemoved = 0;
                        } else {
                          counterRemoved++;
                        } // End if-statement
                      } // End while loop

                      setState(() {
                        showReAddDialog = false;
                      }); //Navigator.of(context).pop();
                    },
                    child: new Text("Yes")
                ),

                // This is the button to cancel recovering
                new FlatButton(
                    onPressed: () {
                      setState(() {
                        showReAddDialog = false;
                      });
                    },
                    child: new Text("Cancel")
                )
              ],
            ) : new Text(""),

            // Show the delete permanently dialog
            showDeleteDialog == true ?
            new AlertDialog(
              title: new Text("Do you want to delete this forever?"),
              actions: <Widget>[

                // Button for yes to delete permanently
                new FlatButton(
                    onPressed: () {
                      int counterRemoved = 0;
                      while (counterRemoved < MyAppState.removedList.length) {
                        if (MyAppState.checkValueRemove[counterRemoved] ==
                            true) {

                          // Removes items from the deleted file
                          MyAppState.removedList.removeAt(counterRemoved);
                          MyAppState.checkValueRemove.removeAt(counterRemoved);
                          counterRemoved = 0;
                        } else {
                          counterRemoved++;
                        } // End if-statement
                      } // End while loop

                      setState(() {
                        showDeleteDialog = false;
                      }); //Navigator.of(context).pop();
                    },
                    child: new Text("Yes")
                ),

                // This is the button to cancel deleting permanently
                new FlatButton(
                    onPressed: () {
                      setState(() {
                        showDeleteDialog = false;
                      });
                    },
                    child: new Text("Cancel")
                )
              ],
            ) : new Text(""),

            // Constructs the list
            new Flexible(
                child: new ListView.builder(
                    itemCount: MyAppState.removedList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return new Row(
                        children: <Widget>[
                          new Checkbox(
                            value: MyAppState.checkValueRemove[index],
                            onChanged: (bool newValue) {
                              MyAppState.checkValueRemove[index] = newValue;
                              setState(() {});
                            },
                          ),
                          new Text(MyAppState.removedList[index]),
                        ],
                      );
                    }
                )
            )
          ],
        )
    );
  }
}