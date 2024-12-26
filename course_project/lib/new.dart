import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp()); // Fixed capitalization
}

class MyApp extends StatelessWidget {
  // Fixed capitalization
  const MyApp({super.key}); // Fixed capitalization

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter App',
      home: MyHomePage(),
      debugShowCheckedModeBanner: false, // Added to remove debug banner
    );
  }
}

class MyHomePage extends StatefulWidget {
  // if we wanna use transactions as i said ACTION we need to add Stateful Widget
  // Changed to StatefulWidget for managing transactions
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _transactions = [
    Transaction(
        id: '6758393',
        title: 'Secret Services',
        amount: 345.6,
        date: DateTime(2012)),
    Transaction(
        id: '482732', title: 'MIT', amount: 573.6, date: DateTime.now()),
  ];

  final titleController = TextEditingController();
  final amountController = TextEditingController();

  void _addNewTransaction(String title, double amount) {
    final newTx = Transaction(
      id: DateTime.now().toString(),
      title: title,
      amount: amount,
      date: DateTime.now(),
    );

    setState(() {
      _transactions.add(newTx);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Removed extra MaterialApp
      appBar: AppBar(
        title: const Text('TransactionWidgets'),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 30,
        ),
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          icon: const Icon(Icons.settings, color: Colors.white),
          // Changed to white
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_a_photo, color: Colors.white),
            // Changed to white
            onPressed: () {},
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.add_alarm_outlined,
              color: Colors.white, // Changed to white
            ),
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Colors.blueAccent, // Changed color
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_alarm),
            label: 'Add Alarm',
            backgroundColor: Colors.blueAccent,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
            backgroundColor: Colors.blueAccent,
          ),
        ],
      ),
      body: SingleChildScrollView(
        // Added for scrolling
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 5,
              margin: const EdgeInsets.all(10),
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(labelText: 'Title'),
                    ),
                    TextField(
                      controller: amountController,
                      decoration: const InputDecoration(labelText: 'Amount'),
                      keyboardType:
                      TextInputType.number, // Added for number input
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      // Changed to ElevatedButton
                      onPressed: () {
                        _addNewTransaction(
                          titleController.text,
                          double.parse(amountController.text),
                        );
                      },
                      child: const Text('Add Transaction'),
                    )
                  ],
                ),
              ),
            ),
            Container(
              height: 300, // Added fixed height
              child: ListView.builder(
                // Changed to ListView.builder for better performance
                itemCount: _transactions.length,
                itemBuilder: (ctx, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 10,
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        child: Padding(
                          padding: const EdgeInsets.all(6),
                          child: FittedBox(
                            child: Text('\$${_transactions[index].amount}'),
                          ),
                        ),
                      ),
                      title: Text(
                        _transactions[index].title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(
                        _transactions[index].date.toString(),
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Transaction {
  final String id;
  final String title;
  final double amount;
  final DateTime date;

  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
  });
}
