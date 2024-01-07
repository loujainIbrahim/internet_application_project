import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../utils/default_button.dart';


class GroupScreen extends StatefulWidget {
  GroupScreen({super.key});

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  List<bool> selectedItems = List.generate(10, (index) => false);

  final List<GridItem> gridItems = [
    GridItem(name: 'Item 1'),
    GridItem(name: 'Item 2'),
    GridItem(name: 'Item 3'),
    GridItem(name: 'Item 4'),
    GridItem(name: 'Item 5'),
    GridItem(name: 'Item 6'),
    GridItem(name: 'Item 7'),
    GridItem(name: 'Item 8'),
    GridItem(name: 'Item 9'),
    GridItem(name: 'Item 10'),
    GridItem(name: 'Item 11'),
    GridItem(name: 'Item 12'),
    GridItem(name: 'Item 13'),
    GridItem(name: 'Item 14'),
    // Add more items as needed
  ];

  void printSelectedItems() {
    List<GridItem> selectedList = [];

    for (int i = 0; i < gridItems.length; i++) {
      if (gridItems[i].isSelected) {
        selectedList.add(gridItems[i]);
      }
    }

    // Print selected items
    print('Selected Items:');
    for (var item in selectedList) {
      print(item.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Group'),
        centerTitle: true,
      ),
      body: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 2,
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0,
                mainAxisExtent: 220,
              ),
              itemCount: gridItems.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onLongPress: () {
                    // Handle long press to select item
                    setState(() {
                      gridItems[index].isSelected =
                          !gridItems[index].isSelected;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 220,
                      decoration: BoxDecoration(
                        color: Colors.white30,
                        border: Border.all(
                          color: Colors.black, // Set the color of the border
                          width: 1.0, // Set the width of the border
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(
                              10.0), // Set the radius of the corners
                        ),
                      ),
                      child:Column(
                        children: [
                          Container(
                            height: 150,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/images/l.jpg'),fit: BoxFit.fill
                              ),
                              color: Colors.white30,
                              border: Border.all(
                                color: Colors.white, // Set the color of the border
                                width: 0.0, // Set the width of the border
                              ),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10.0),    // Adjust the radius as needed
                                topRight: Radius.circular(10.0),
                              ),
                            ),
                          ),
                          SizedBox(height: 10,),
                          Row( mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text("abd.txt",style: TextStyle(fontSize: 24),),
                              Checkbox(
                                value: gridItems[index].isSelected,
                                onChanged: (value) {
                                  setState(() {
                                    gridItems[index].isSelected = value ?? false;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      )

                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width / 2,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // Number of columns in the grid
                  crossAxisSpacing: 4.0, // Spacing between columns
                  mainAxisSpacing: 4.0, // Spacing between rows
                  mainAxisExtent: 220),
              itemCount: 20, // Number of items in the grid
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GroupScreen()));
                    },
                    child: Container(
                      height: 250,
                      decoration: BoxDecoration(
                        color: Colors.white30,
                        border: Border.all(
                          color: Colors.black, // Set the color of the border
                          width: 1.0, // Set the width of the border
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(
                              10.0), // Set the radius of the corners
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundImage:
                                  AssetImage('assets/images/l.jpg'),
                            ),
                            Text(
                              'ahmad',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              'ahmad@gmail.com',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            defaultbutton(
                                width: 100,
                                height: 30,
                                backround: Colors.orange,
                                text: 'delete',
                                function: () {}),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

Future<String> loadTextFileContent(String fileName) async {
  return await rootBundle.loadString('assets/files/$fileName');
}

class GridItem {
  String name;
  bool isSelected;

  GridItem({required this.name, this.isSelected = false});
}
/**
 * GridTile(

    child: FutureBuilder<String>(
    future: loadTextFileContent('abd.txt'),
    builder: (context, snapshot) {
    if (snapshot.hasData) {
    return Center(
    child: Text(snapshot.data!),
    );
    } else {
    return Center(
    child: CircularProgressIndicator(),
    );
    }
    },
    ),
    );
 * */
