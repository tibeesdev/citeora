import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Citeora',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xfff9f7f4)),
      ),
      home: const MyHomePage(title: 'Citeora'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // list style daftar pustaka
  List<String> listStyle = [
    'APA',
    'MLA',
    'Chicago',
    'IEEE',
    'Harvard',
    'Vancouver',
    'Turabian',
    'CSE',
    'AMA',
  ];

  // list input
  // list input asli
  List<String> listInput = ['Nama Pengarang', 'Judul', 'Tahun Terbit'];
  // list input modifikasi
  List<String> modifiedListInput = [];
  @override
  Widget build(BuildContext context) {
    // assign data list input modifikasi
    modifiedListInput = listInput;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          Image.asset(
            'assets/images/citeora(banner).png',
            width: 100,
            height: 100,
            fit: BoxFit.cover,
            alignment: Alignment.center,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: modifiedListInput.length,
              itemBuilder: (context, index) {
                return Center(child: Text(modifiedListInput[index]));
              },
            ),
          ],

          // children: <Widget>[
          //   // dropdown di bagian paling atas
          //   Padding(
          //     padding: EdgeInsets.all(10),
          //     child: DropdownButtonFormField2(
          //       items:
          //           listStyle
          //               .map(
          //                 (String item) => DropdownMenuItem(
          //                   value: item,
          //                   child: Text(
          //                     item,
          //                     style: const TextStyle(
          //                       fontSize: 14,
          //                       fontWeight: FontWeight.bold,
          //                       color: Color.fromARGB(255, 0, 0, 0),
          //                     ),
          //                     overflow: TextOverflow.ellipsis,
          //                   ),
          //                 ),
          //               )
          //               .toList(),
          //       onChanged: (value) {
          //         print(value);
          //       },
          //       decoration: InputDecoration(
          //         labelText: 'Pilih Gaya Penulisan',
          //         border: OutlineInputBorder(
          //           borderRadius: BorderRadius.circular(10),
          //           borderSide: BorderSide(color: Colors.blue),
          //         ),
          //       ),
          //     ),
          //   ),
          //   Row(
          //     children: [
          //       // nama pengarang
          //       Expanded(
          //         child: Padding(
          //           padding: const EdgeInsets.all(10),
          //           child: TextField(
          //             decoration: InputDecoration(
          //               labelText: 'Nama Pengarang',
          //               border: OutlineInputBorder(
          //                 borderRadius: BorderRadius.circular(10),
          //                 borderSide: BorderSide(color: Colors.blue),
          //               ),
          //             ),
          //           ),
          //         ),
          //       ),
          //       // button tambah nama pengarang
          //       ElevatedButton(
          //         onPressed: () {
          //           // aksi untuk menambah nama pengarang
          //           // menambah input nama pengarang
          //         },
          //         child: const Text(
          //           '+',
          //           style: TextStyle(
          //             fontSize: 20,
          //             fontWeight: FontWeight.bold,
          //             color: Color.fromARGB(255, 0, 0, 0),
          //           ),
          //         ),
          //         style: ElevatedButton.styleFrom(
          //           shape: RoundedRectangleBorder(
          //             borderRadius: BorderRadius.circular(10),
          //           ),
          //           padding: EdgeInsets.all(20),
          //           backgroundColor: const Color.fromARGB(255, 249, 252, 255),
          //         ),
          //       ),
          //     ],
          //   ),
          // ],
        ),
      ),
    );
  }
}
