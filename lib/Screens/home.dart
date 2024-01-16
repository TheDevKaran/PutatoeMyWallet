import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:managment/Screens/add.dart';
import 'package:managment/data/model/add_date.dart';
import 'package:managment/data/utlity.dart';



class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String selectedAccountType = 'Savings';
  var history;
  final box = Hive.box<Add_data>('data');
  final List<String> day = [
    'Monday',
    "Tuesday",
    "Wednesday",
    "Thursday",
    'friday',
    'saturday',
    'sunday'
  ];
  bool _showImage = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(color: Color(0xFFF7F7F7),
        child: SafeArea(
            child: ValueListenableBuilder(
                valueListenable: box.listenable(),
                builder: (context, value, child) {
                  return CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: Column(
                          children: [
                            SizedBox(height: 340, child: _head()),
                            _rewardCalculation(),
                            SizedBox(height: 10,),
                            _BankingService(),
                          ],
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 30),
                          child: Text(
                            'Transactions',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 19,
                              color: Color(0xff7db6bc),
                            ),
                          ),
                        ),
                      ),

                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                              (context, index) {
                            history = box.values.toList()[index];
                            return getList(history, index);
                          },
                          childCount: box.length,
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Visibility(
                          visible: _showImage,
                          child: _imagetrans(),
                        ),
                      ),
                    ],
                  );
                })),
      ),
    );
  }

  Widget getList(Add_data history, int index) {
    return Dismissible(
        key: UniqueKey(),
        onDismissed: (direction) {
          history.delete();
        },
        child: get(index, history));
  }

  ListTile get(int index, Add_data history) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Image.asset('images/${history.name}.png', height: 40),
      ),
      title: Text(
        history.name,
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        '${day[history.datetime.weekday - 1]}  ${history.datetime
            .year}-${history.datetime.day}-${history.datetime.month}',
        style: TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: Text(
        history.amount,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 19,
          color: history.IN == 'Income' ? Colors.green : Colors.red,
        ),
      ),
    );
  }

  Widget _head() {
    return Stack(
      children: [
        Column(
          children: [
            Container(
              width: double.infinity,
              height: 240,
              decoration: BoxDecoration(
                color: Color(0xff419ea6),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20, left: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(icon: Icon(
                          Icons.arrow_back, size: 30, color: Colors.white,),
                            onPressed: () {

                            }),
                        Text(
                          'Putatoe Wallet',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        Positioned(
          top: 140,
          left: 37,
          child: Container(
            height: 170,
            width: 320,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Color(0xff017d8b),
                  offset: Offset(0, 0),
                  blurRadius: 0,
                  spreadRadius: 6,
                ),
              ],
              color: Color(0xff1a8a95),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                SizedBox(height: 10),


                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Row(
                    children: [
                      Text(
                        '\₹ ${total()}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 7),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Available Balance',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.circle,
                                  color: Color(0xff419ea6),
                                  size: 38,
                                ),
                              ),
                            ], mainAxisAlignment: MainAxisAlignment.center,

                          ), Text("P", style: TextStyle(fontSize: 20,
                              color: Colors.white),)
                        ], alignment: Alignment.center,
                      ),
                      SizedBox(width: 7),
                      Text(' ${income()}', style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 17,
                        color: Colors.white,),),
                      Row(
                        children: [
                          SizedBox(width: 67),
                          GestureDetector(
                            onTap: (){Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) => Add_Screen()));},
                            child: Container(padding: EdgeInsets.all(7),
                              decoration: BoxDecoration(color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Text(
                                'Transfer Money',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Reward Points",
                        style: TextStyle(color: Colors.white,),)
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _rewardCalculation() {
    return Container(alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(horizontal: 7),
      padding: EdgeInsets.only(left: 5),
      decoration: BoxDecoration(
        color: Color(0xff419ea6),
        borderRadius: BorderRadius.circular(13),),
      height: 70,
      child: Text(
        "100 reward points = 1 putatoe credit \n 1 putatoe credit = 1 rupee\n Can be redeemed to your bank account on amount above 10,000",
        style: TextStyle(color: Colors.white, fontSize: 13),),
    );
  }

  Widget _BankingService() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 7),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),),
      height: 120,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        GestureDetector(onTap: () {
          _showAddMoneyDialog(context);
        },
          child: Column(
            children: [
              Image.asset('Assets/money.png', height: 80, width: 80,),
              Text('Add Money', style: TextStyle(color: Color(0xff419ea6)),)
            ],
          ),
        ),
        GestureDetector(onTap: () {
          _showAddAadharDialog(context);
        },
          child: Column(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('Assets/redeem.png', height: 80, width: 80,),
              Text('Redeem as', style: TextStyle(color: Color(0xff419ea6)),),
              Text('data', style: TextStyle(color: Color(0xff419ea6)))
            ],
          ),
        ),
        GestureDetector(onTap: () {
          _showNoBank(context);
        },
          child: Column(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('Assets/bank.png', height: 80, width: 80,),
              Text("Send money to", style: TextStyle(color: Color(0xff419ea6))),
              Text("Bank", style: TextStyle(color: Color(0xff419ea6)))
            ],
          ),
        )
      ]),);
  }

  Widget _imagetrans() {
    return Container(child: Image.asset('Assets/new.jpeg'),);
  }



  Future<void> _launchUPIApp(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
          content: Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            height: 80, // Adjust the height as needed
            width: 570,
            child: Center(
              child: Column(
                children: [
                  Container(
                    color: Color(0xffdbedef),
                    child: Column(
                      children: [
                        Text(
                          "Select Payment Method",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xff077d82),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            Center(
              child: Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Process the entered amount (amountController.text)
                    // Close the dialog
                    // _makePayment(); // Call the method to initiate the payment
                  },
                  style: ElevatedButton.styleFrom(
                    onPrimary: Color(0xff1b8893), // Set the background color
                    primary: Color(0xffdbedef), // Set the text color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ), // Set the border radius to 0 for a rectangular shape
                  ),
                  child: Text('CONTINUE'),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Future<void> _makePayment() async {
  //   try {
  //     final res = await EasyUpiPaymentPlatform.instance.startPayment(
  //       EasyUpiPaymentModel(
  //         payeeVpa: 'gaurav.jajoo@upi',
  //         payeeName: 'Gaurav Jajoo',
  //         amount: 10.0,
  //         description: 'Testing payment',
  //       ),
  //     );
  //     // TODO: add your success logic here
  //     print(res);
  //   } on EasyUpiPaymentException {
  //     // TODO: add your exception logic here
  //   }
  // }

  Future<void> _showAddMoneyDialog(BuildContext context) async {
    TextEditingController amountController = TextEditingController();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Column(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('Add Money to Wallet', style: TextStyle(
                      color: Color(0xff419ea6), fontWeight: FontWeight.bold)),
                  SizedBox(width: 10,),
                  GestureDetector(onTap: () {
                    Navigator.of(context).pop();
                  },
                      child: Icon(Icons.close, color: Color(0xff419ea6),))
                ],
              ),
              Text('Enter Amount', style: TextStyle(color: Color(0xff419ea6)))
            ],
          )),
          content: Container(height: 70, width: 570,
            child: Center(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      // Give focus to the TextField when the label is tapped
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                    child: TextField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(iconColor: Color(0xff419ea6),
                        hintText: ' 0',
                        fillColor: Color(0xff419ea6),
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.currency_rupee, color: Color(
                            0xff419ea6)),
                      ), // Make the TextField read-only
                    ),
                  )
                ],
              ),
            ),
          ),
          actions: [
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Process the entered amount (amountController.text)
                  // Close the dialog
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => Add_Screen()));
                },
                style: ElevatedButton.styleFrom(
                  onPrimary: Color(0xff1b8893), // Set the background color
                  primary: Color(0xffdbedef), // Set the text color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ), // Set the border radius to 0 for a rectangular shape
                ),
                child: Text('ADD'),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showAddAadharDialog(BuildContext context) async {
    TextEditingController aadharController = TextEditingController();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(contentPadding: EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
          title: Column(
            children: [
              Container(
                color: Color(0xffdbedef),
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  'Enter Aadhar Card Number',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
          content: Container(
            height: 80, // Adjust the height as needed
            width: 570,
            child: Center(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      // Give focus to the TextField when the label is tapped
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: aadharController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          iconColor: Color(0xff419ea6),
                          hintText: ' Enter your Aadhar Card Number',
                          fillColor: Color(0xff419ea6),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            Center(
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Process the entered amount (amountController.text)
                        // Close the dialog
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xff1b8893), // Set the background color
                        onPrimary: Color(0xffdbedef), // Set the text color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                          side: BorderSide(color: Color(0xff1b8893)),
                        ), // Set the border radius to 0 for a rectangular shape
                      ),
                      child: Text('SUBMIT'),
                    ),
                  ),
                  SizedBox(width: 5,),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Process the entered amount (amountController.text)
                        // Close the dialog
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        onPrimary: Color(0xffdbedef),
                        // Set the background color
                        primary: Color(0xff1b8893),
                        // Set the text color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                          side: BorderSide(color: Color(0xff1b8893)),
                        ), // Set the border radius to 0 for a rectangular shape
                      ),
                      child: Text('CANCEL'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showAddAccountDialog(BuildContext context) async {
    TextEditingController accnumController = TextEditingController();
    TextEditingController accnameController = TextEditingController();
    TextEditingController ifscController = TextEditingController();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
          title: Column(
            children: [
              Container(

                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  'ADD BANK ACCOUNT',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
          content: Container(
            height: 310, // Adjust the height as needed
            width: 570,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Account Number :'),
                  TextField(
                    controller: accnumController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      iconColor: Color(0xff419ea6),
                      hintText: ' Enter Account Number',
                      fillColor: Color(0xff419ea6),
                      border: OutlineInputBorder(),
                    ),
                  ),

                  DropdownButton<String>(hint: Text('Select Account Type'),
                    value: selectedAccountType,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedAccountType = newValue!;
                      });
                    },
                    items: <String>['Savings', 'Checking']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  Text('Account Holder Name :'),
                  TextField(
                    controller: accnameController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      iconColor: Color(0xff419ea6),
                      hintText: 'Enter Account Holder Name',
                      fillColor: Color(0xff419ea6),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  Text('IFSC Code :'),
                  TextField(
                    controller: ifscController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      iconColor: Color(0xff419ea6),
                      hintText: 'Enter IFSC Code',
                      fillColor: Color(0xff419ea6),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Process the entered amount (amountController.text)
                  // Close the dialog
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  primary: Color(0xff1b8893), // Set the background color
                  onPrimary: Color(0xffdbedef), // Set the text color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: Color(0xff1b8893)),
                  ), // Set the border radius to 0 for a rectangular shape
                ),
                child: Text('ADD ACCOUNT'),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showNoBank(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
          content: Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            height: 80, // Adjust the height as needed
            width: 570,
            child: Center(
              child: Column(
                children: [
                  Container(
                    color: Color(0xffdbedef),
                    child: Column(
                      children: [
                        Text(
                          "No Bank Accounts!",
                          style: TextStyle(fontWeight: FontWeight.bold,
                              color: Color(0xff077d82)),
                        ),
                        Text(
                          "Please add a Bank Account",
                          style: TextStyle(fontWeight: FontWeight.bold,
                              color: Color(0xff509ca4)),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            Center(
              child: Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Process the entered amount (amountController.text)
                    // Close the dialog
                    _showAddAccountDialog(context);
                  },
                  style: ElevatedButton.styleFrom(
                    onPrimary: Color(0xff1b8893), // Set the background color
                    primary: Color(0xffdbedef), // Set the text color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ), // Set the border radius to 0 for a rectangular shape
                  ),
                  child: Text('ADD A BANK ACCOUNT'),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

}
