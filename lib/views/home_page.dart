import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final db = Hive.box('mytodo');

  final nameController = TextEditingController();
  final designationController = TextEditingController();

  List myTodolist = [
    // ['homework', "maths"],
    // ['workout', "leg day"],
  ];

  void addtoList({required String name, required String designation}) {
    setState(() {
      myTodolist.add([name, designation]);
    });
    db.put('todolist', myTodolist);
  }

  void delete(int index) {
    setState(() {
      myTodolist.removeAt(index);
    });
    db.put('todolist', myTodolist);
  }

  @override
  void initState() {
    myTodolist = db.get('todolist');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade200,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.green,
        title: const Text(
          'ToDo',
          style: TextStyle(
            fontSize: 28,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemCount: myTodolist.length,
                itemBuilder: (context, index) {
                  return Container(
                    height: 90,
                    decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(13)),
                    child: Center(
                      child: ListTile(
                        title: Text(
                          myTodolist[index][0],
                          style: const TextStyle(
                            fontSize: 28,
                            color: Colors.black,
                          ),
                        ),
                        subtitle: Text(
                          myTodolist[index][1],
                          style: const TextStyle(
                            fontSize: 23,
                            color: Colors.black,
                          ),
                        ),
                        trailing: IconButton(
                            onPressed: () {
                              delete(index);
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                              size: 29,
                            )),
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) => const Divider(),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          nameController.text = '';
          designationController.text = '';
          showModalBottomSheet(
            backgroundColor: Colors.transparent,
            context: context,
            builder: (BuildContext context) => Container(
              height: 900,
              decoration: BoxDecoration(
                  color: Colors.greenAccent,
                  borderRadius: BorderRadius.circular(22)),
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    //textfield 1
                    Container(
                      height: 60,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade400,
                          borderRadius: BorderRadius.circular(15)),
                      child: Center(
                        child: TextField(
                          cursorColor: Colors.grey,
                          style: const TextStyle(fontSize: 23),
                          controller: nameController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Name',
                            prefixText: ' ',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    //textfield 2
                    Container(
                      height: 60,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade400,
                          borderRadius: BorderRadius.circular(15)),
                      child: Center(
                        child: TextField(
                          cursorColor: Colors.grey,
                          style: const TextStyle(fontSize: 23),
                          controller: designationController,
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Designation',
                              prefixText: ' '),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    //save button
                    GestureDetector(
                      onTap: () {
                        addtoList(
                          name: nameController.text,
                          designation: designationController.text,
                        );
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        width: 80,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: const Center(
                            child: Text(
                          'Save',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 23,
                          ),
                        )),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
