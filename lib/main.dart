import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/services.dart';
import 'package:rich_clipboard/rich_clipboard.dart';

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

  // returnnya adalah string dari nama pengarang yang sudah diubah
  String namaPengarang(List nama_pengarang) {
    String namaPengarang = '';
    if (nama_pengarang.length != 0) {
      // bersihkan isi list nama
      nama_pengarang.removeWhere((item) => item.length == 0);
      if (kDebugMode) {
        print(nama_pengarang);
      }

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
      else if (nama_pengarang.length == 1) {
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
        print('nama pengarang' + namaPengarang);
      }
    }
    return namaPengarang;
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
  List<TextEditingController> controllerNamaPengarang = [
    TextEditingController(),
  ];
  //controller untuk apa style
  List<TextEditingController> controllerAPAStyle = [];
  // list nama pengarang (dipakai untuk parding data nama pengarang ke fungsi apastyle)
  List<String> nama_pengarang = [''];

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
                    TextEditingController controller =
                        controllerNamaPengarang[index];

                    // masukkan value nama pengarang ke dalam controller agar ketika widget berubah isi teks tidak berubah
                    String title = '${namaPengarangListInput[index]}';
                    return Center(
                      child: // jika merupakan input nama pengarang maka tambahakn elevated button untuk opsi tambah pengaran
                          Row(
                        children: [
                          // nama pengarang
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              // gunakan widget focus untuk check apakah text sedang aktif atau tidak
                              child: Focus(
                                onFocusChange: (value) {
                                  if (!value) {
                                    // masukkan value nama ke dalam list
                                    nama_pengarang[index] = controller.text;
                                    // panggil fungsi untuk proses nama
                                    setState(() {
                                      result = (namaPengarang(nama_pengarang));
                                    });

                                    if (kDebugMode) {
                                      print('text' + controller.text);
                                    }
                                  }
                                },
                                child: TextField(
                                  controller: controller,
                                  onChanged: (value) {
                                    controller.text;
                                  },
                                  decoration: InputDecoration(
                                    labelText: title,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: Colors.blue,
                                      ),
                                    ),
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
                                    controllerNamaPengarang.add(
                                      TextEditingController(),
                                    );
                                    nama_pengarang.add('');
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
            ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
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
                                // jika tahun terbit
                                if (index == 0) {
                                  listInputAPA[index] = ' ($value). ';
                                } // jika judul buku
                                else if (index == 1) {
                                  listInputAPA[index] = '$value. ';
                                } // jika penerbit
                                else if (index == 2) {
                                  listInputAPA[index] = '$value.';
                                }
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
                : Container(), // ganti kode ini jika mau menambahkan style lain
            // tombol buat dapus
            //  ElevatedButton.icon(
            //   onPressed: () {
            //     // assign datanya secara manual
            //     String tahun_terbit = controllerAPAStyle[0].text;

            //     if (kDebugMode) {
            //       print(tahun_terbit);
            //       print(controllerAPAStyle.length);
            //     }
            //     if (selectedStyle == 'APA(Buku)') {
            //       namaPengarang(nama_pengarang);
            //     }
            //   },
            //   label: Text('buat sitasi'),
            //   icon: Icon(Icons.create),
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: Colors.blueAccent,
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(8),
            //     ),
            //     padding: const EdgeInsets.symmetric(
            //       horizontal: 20,
            //       vertical: 12,
            //     ),
            //   ),
            // )

            // bagian salin dapus
            selectedStyle != ''
                ? Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: TextEditingController(
                          text:
                              r'<tml><body>$result${listInputAPA[0]}<i>${listInputAPA[1]}</i>${listInputAPA[2]}</body></html>',
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          text: result,
                          children: [
                            // tahun terbit
                            TextSpan(text: listInputAPA[0]),
                            TextSpan(
                              // judul buku di italic kan
                              text: listInputAPA[1],
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                            // penerbit
                            TextSpan(text: listInputAPA[2]),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      ElevatedButton.icon(
                        onPressed: () {
                          RichClipboardData data = RichClipboardData(
                            html:
                                '<html><body>' +
                                result +
                                listInputAPA[0] +
                                '<i>' +
                                listInputAPA[1] +
                                '</i>' +
                                listInputAPA[2] +
                                '</body></html>',
                            text:
                                '<html><body>' +
                                result +
                                listInputAPA[0] +
                                '<i>' +
                                listInputAPA[1] +
                                '</i>' +
                                listInputAPA[2] +
                                '</body></html>',
                          );
                          // salin
                          RichClipboard.setData(data);
                          //Clipboard.setData(ClipboardData(text: "<i>data</i>"));

                          // tampilkan snackbar
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Text Disalin'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
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
                )
                : Text('Pilih Style Daftar Pustaka'),
          ],
        ),
      ),
    );
  }
}
