import 'package:flutter/foundation.dart';
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
  // hasil sitasi
  String result = '';
  // list style daftar pustaka
  List<String> listStyle = [
    'APA(Buku)',
    'APA(Jurnal)',
        'MLA',
    'Chicago',
    'IEEE',
    'Harvard',
    'Vancouver',
    'Turabian',
    'CSE',
    'AMA',
  ];

  // style yang dipilih
  String? selectedStyle = '';

  // list input
  // list input asli
  List<String> listInput = [
    'Tahun Terbit',
    'Judul',
    'Kota Publikasi',
    'Nama Penerbit',
  ];

  void namaPengarang(List nama_pengarang) {
    if (nama_pengarang.length > 1) {
      // bersihkan isi list nama
      nama_pengarang.removeWhere((item) => item.length == 0);
      if (kDebugMode) {
        print(nama_pengarang);
      }

      String namaPengarang = '';
      // cek jumlah pengarang jika lebih dari  1
      if (nama_pengarang.length > 2) {
        // jika lebih dari 3 orang
        // loop setiap nama pengarang
        for (String element in nama_pengarang) {
          // split nama pengarang dengan spasi
          List nama = element.split(" ");
          // ambil nama belakang pengaran
          String nama_pengarang_dibalik = nama[nama.length - 1] + ',';
          // ambil inisial nama
          String inisial_nama = '';
          for (var i = 0; i < nama.length - 1; i++) {
            inisial_nama += ' ${nama[i][0]}.';
          }
          // cek jika namanya merupakan indeks terakhir agar bisa ditambahkan tanda "&"
          if (element == nama_pengarang[nama_pengarang.length - 1]) {
            // jika data di indeks terkahir
            namaPengarang += ' & ' + nama_pengarang_dibalik + inisial_nama;
          } else {
            namaPengarang += ' ' + nama_pengarang_dibalik + inisial_nama + ',';
          }
        }
      } else if (nama_pengarang.length == 2) {
        // jika lebih 1 tapi tidak lebih dari 3
        // loop setiap nama pengarang
        for (String element in nama_pengarang) {
          // split nama pengarang dengan spasi
          List nama = element.split(" ");
          // ambil nama belakang pengaran
          String nama_pengarang_dibalik = nama[nama.length - 1] + ',';
          // ambil inisial nama
          String inisial_nama = '';
          for (var i = 0; i < nama.length - 1; i++) {
            inisial_nama += ' ${nama[i][0]}.';
          }
          // cek jika namanya merupakan indeks terakhir agar bisa ditambahkan tanda "&"
          if (element == nama_pengarang[nama_pengarang.length - 1]) {
            // jika data di indeks terkahir
            namaPengarang += ' dan ' + nama_pengarang_dibalik + inisial_nama;
          } else {
            namaPengarang += ' ' + nama_pengarang_dibalik + inisial_nama + ',';
          }
        }
      }
      // jika pengarang hanya 1
      else {
        String element = nama_pengarang[0];
        // split nama
        List nama = element.split(' ');
        // inisial nama
        String inisial_nama = '';
        for (var i = 0; i < nama.length - 1; i++) {
          inisial_nama += ' ${nama[i][0]}.';
        }

        // masukkan nama ke variabel
        namaPengarang = nama[nama.length - 1] + inisial_nama;
      }
      if (kDebugMode) {
        print(namaPengarang);
      }
    }
  }

  List dummyNamaPengarang = [
    'Amelia Putri Pratama',
    'Surya Wijaya',
    'Citra Lestari',
  ];

  // list input APA
  List listAPABuku = ['Tahun Penerbitan', 'Judul Buku', 'Penerbit'];
  List<String> listInputAPA = ['', '', ''];
  // list input untuk nama pengarang (dipakai untuk judul textinput)
  List<String> namaPengarangListInput = ['Nama Pengarang'];
  // controller untuk nama pengarang
  List<TextEditingController> controllerNamaPengarang = [];
  //controller untuk apa style
  List<TextEditingController> controllerAPAStyle = [];
  // list nama pengarang (dipakai untuk parding data nama pengarang ke fungsi apastyle)
  List<String> nama_pengarang = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // buat controller untuk apa style
    for (var element in listAPABuku) {
      TextEditingController controller = TextEditingController();
      controllerAPAStyle.add(controller);
    }
  }

  @override
  Widget build(BuildContext context) {
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
            kDebugMode
                ? ElevatedButton(onPressed: () {}, child: Text('data'))
                : Container(),
            // dropdown di bagian paling atas
            Padding(
              padding: EdgeInsets.all(10),
              child: DropdownButtonFormField2(
                items:
                    listStyle
                        .map(
                          (String item) => DropdownMenuItem(
                            value: item,
                            child: Text(
                              item,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                        .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedStyle = value;
                  });
                  if (kDebugMode) {
                    print(value);
                  }
                },
                decoration: InputDecoration(
                  labelText: 'Pilih Gaya Penulisan',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
              ),
            ),

            // list builder khusus untuk nama pengarang
            selectedStyle != ''
                ? ListView.builder(
                  shrinkWrap: true,
                  itemCount: namaPengarangListInput.length,
                  itemBuilder: (context, index) {
                    // buat ccontroller (buat store value dari list, kalo gak pake controller setiap kali ada tambahan nama pengarang, nama pengarang sebelumnya dihapus dari kotak teks)
                    TextEditingController controller = TextEditingController();
                    controllerNamaPengarang.add(controller);
                    // inisiasi value awal untuk list namapengarang
                    nama_pengarang.add('');
                    // masukkan value nama pengarang ke dalam controller agar ketika widget berubah isi teks tidak berubah
                    controller.text = nama_pengarang[index];
                    String title = '${namaPengarangListInput[index]}';
                    return Center(
                      child: // jika merupakan input nama pengarang maka tambahakn elevated button untuk opsi tambah pengaran
                          Row(
                        children: [
                          // nama pengarang
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: TextField(
                                controller: controller,
                                onChanged: (value) {
                                  // masukkan value nama pengarang ke dalam list
                                  nama_pengarang[index] = value;
                                  if (kDebugMode) {
                                    print(value);
                                    print(nama_pengarang);
                                  }
                                  //styleAPABuku(nama_pengarang);
                                },

                                decoration: InputDecoration(
                                  labelText: title,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: Colors.blue),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // lakukan pengecekan, jika Nama pengarang berada di indeks terakhir maka gunakan tombol tambah
                          // jika bukan di indeks terakhir maka gunakan tombol sampah untuk menghapus
                          index == 0
                              ?
                              // button tambah nama pengarang
                              ElevatedButton(
                                onPressed: () {
                                  // aksi untuk menambah nama pengarang
                                  // menambah input nama pengarang
                                  setState(() {
                                    namaPengarangListInput.add(
                                      'Nama Pengarang',
                                    );
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: EdgeInsets.all(20),
                                  backgroundColor: const Color.fromARGB(
                                    255,
                                    249,
                                    252,
                                    255,
                                  ),
                                ),
                                child: const Text(
                                  '+',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                  ),
                                ),
                              )
                              : // hapus nama pengarang
                              ElevatedButton(
                                onPressed: () {
                                  // aksi untuk menambah nama pengarang
                                  // menambah input nama pengarang
                                  namaPengarangListInput.removeAt(index);
                                  nama_pengarang.removeAt(index);
                                  controllerNamaPengarang.removeAt(index);
                                  setState(() {});
                                },
                                child: const Icon(Icons.delete),
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: EdgeInsets.all(20),
                                  backgroundColor: const Color.fromARGB(
                                    255,
                                    249,
                                    252,
                                    255,
                                  ),
                                ),
                              ),
                        ],
                      ),
                    );
                  },
                )
                : Container(),
            // list builder untuk item lain
            // cek stylenya
            selectedStyle == 'APA(Buku)'
                ? ListView.builder(
                  shrinkWrap: true,
                  itemCount: listAPABuku.length,
                  itemBuilder: (context, index) {
                    String title = listInput[index];
                    // controller
                    TextEditingController controller =
                        controllerAPAStyle[index];
                    return Center(
                      child: Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: TextField(
                            onChanged: (value) {
                              // masukkan data dari controller ke dalam list yang berisi string untuk tanggal, judul, dan penerbit
                              setState(() {
                                listInputAPA[index] = value;
                              });
                            },
                            controller: controller,
                            decoration: InputDecoration(
                              labelText: title,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                )
                : Text(
                  'pilih style',
                ), // ganti kode ini jika mau menambahkan style lain
            // tombol buat dapus
            ElevatedButton.icon(
              onPressed: () {
                // assign datanya secara manual
                String tahun_terbit = controllerAPAStyle[0].text;

                if (kDebugMode) {
                  print(tahun_terbit);
                  print(controllerAPAStyle.length);
                }
                if (selectedStyle == 'APA(Buku)') {
                  namaPengarang(nama_pengarang);
                }
              },
              label: Text('buat sitasi'),
              icon: Icon(Icons.create),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
            ),

            // bagian salin dapus
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  RichText(
                    text: TextSpan(
                      text: result,
                      children: [
                        // tahun terbit
                        TextSpan(text: ' (${listInputAPA[0]}). '),
                        TextSpan(
                          // judul buku di italic kan
                          text: listInputAPA[1] + '. ',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                        TextSpan(text: listInputAPA[2] + '.'),
                      ],
                    ),
                  ),
                  Text('$result', style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () {},
                    label: Text('salin'),
                    icon: Icon(Icons.copy),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          // children: <Widget>[
          //   // dropdown di bagian paling atas
          //   Padding(
          //widget//     padding: EdgeInsets.all(10),
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
          ///widget/                     ),
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
          //widget   Row(
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
