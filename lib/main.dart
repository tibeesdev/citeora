import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

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
  // mapping string untuk dirubah menjadi italic
  Map<String, String> italicMap = {
    // Huruf kapital A-Z
    'A': '\u{1D434}', 'B': '\u{1D435}', 'C': '\u{1D436}', 'D': '\u{1D437}',
    'E': '\u{1D438}', 'F': '\u{1D439}', 'G': '\u{1D43A}', 'H': '\u{1D43B}',
    'I': '\u{1D43C}', 'J': '\u{1D43D}', 'K': '\u{1D43E}', 'L': '\u{1D43F}',
    'M': '\u{1D440}', 'N': '\u{1D441}', 'O': '\u{1D442}', 'P': '\u{1D443}',
    'Q': '\u{1D444}', 'R': '\u{1D445}', 'S': '\u{1D446}', 'T': '\u{1D447}',
    'U': '\u{1D448}', 'V': '\u{1D449}', 'W': '\u{1D44A}', 'X': '\u{1D44B}',
    'Y': '\u{1D44C}', 'Z': '\u{1D44D}',

    // Huruf kecil a-z (kecuali 'h' yang pakai simbol khusus)
    'a': '\u{1D44E}', 'b': '\u{1D44F}', 'c': '\u{1D450}', 'd': '\u{1D451}',
    'e': '\u{1D452}', 'f': '\u{1D453}', 'g': '\u{1D454}', 'h': '\u{210E}',
    'i': '\u{1D456}', 'j': '\u{1D457}', 'k': '\u{1D458}', 'l': '\u{1D459}',
    'm': '\u{1D45A}', 'n': '\u{1D45B}', 'o': '\u{1D45C}', 'p': '\u{1D45D}',
    'q': '\u{1D45E}', 'r': '\u{1D45F}', 's': '\u{1D460}', 't': '\u{1D461}',
    'u': '\u{1D462}', 'v': '\u{1D463}', 'w': '\u{1D464}', 'x': '\u{1D465}',
    'y': '\u{1D466}', 'z': '\u{1D467}',

    // Angka 0–9 (dalam Mathematical Bold Italic — paling mirip dengan italic)
    '0': '\u{1D7CE}', '1': '\u{1D7CF}', '2': '\u{1D7D0}', '3': '\u{1D7D1}',
    '4': '\u{1D7D2}', '5': '\u{1D7D3}', '6': '\u{1D7D4}', '7': '\u{1D7D5}',
    '8': '\u{1D7D6}', '9': '\u{1D7D7}',

    // Tanda baca (tidak ada versi italic resmi, fallback ke karakter biasa)
    '.': '.', ',': ',', '!': '!', '?': '?', ':': ':', ';': ';',
    '\'': '\'', '"': '"', '(': '(', ')': ')', '[': '[', ']': ']',
    '{': '{', '}': '}', '<': '<', '>': '>', '/': '/', '\\': '\\',
    '|': '|', '-': '-', '_': '_', '+': '+', '=': '=', '*': '*',
    '&': '&', '%': '%', '#': '#', '@': '@', '^': '^', '~': '~',
    '`': '`', ' ': ' ',
  };

  // hasil nama yang sudah dirubah
  String nama_pengarang_yang_sudah_dirubah = '';
  // list style daftar pustaka
  List<String> get listStyle => [
    'APA(Buku)',
    'APA(Buku/Organisasi)',
    'APA(Buku/Terjemahan)',
    'APA(Jurnal)',
    'APA(Jurnal Online)',
    'APA(E-Book)',
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

  // mappping pilihan style dengan data yang diperlukan untuk diinput
  Map<String, List<String>> get mapStyletoInput => {
    listStyle[0]: [
      'Tahun Penerbitan',
      'Judul Buku',
      'Kota Penerbit',
      'Penerbit',
    ], // APA style untuk buku
    listStyle[1]: [
      'Nama Organisasi',
      'Tahun Penerbitan',
      'Judul Buku',
      'Kota Penerbit',
      'Penerbit',
    ], // apa style untuk buku yang diterbitkan oleh organisasi

    listStyle[2]: [
      // APA style untuk buku terjemahan
      'Tahun Penerbitan',
      'Judul Buku (Terjemahan)',
      'Penerjemah',
      'Kota Penerbit',
      'Penerbit (Terjemahan)',
    ],

    listStyle[3]: [
      // APA style untuk jurnal
      'Tahun Penerbitan',
      'Judul Artikel',
      'Nama Jurnal',
      'volume',
      'Isu atau Nomor',
      'Halaman(1-5)',
      'Tautan (opsional)',
    ],
    listStyle[4]: [
      // APA style untuk jurnal yang didapat online
      'Tahun Penerbitan',
      'Judul Artikel',
      'Nama Jurnal',
      'volume',
      'Isu atau Nomor',
      'Halaman(1-5)',
      'DOI atau Tautan',
    ],
    listStyle[5]: [
      // APA style untuk E-Book
      'Tahun Terbit',
      'Judul E-Book',
      'Edisi (Jika Ada)',
      'Penerbit',

      'Tautan E-Book',
    ],
  };

  // list string untuk input (karena inisiasi tidak mungkin di dalam builder)
  List<String> listInput = []; //['', '', ''];
  // list input untuk nama pengarang (dipakai untuk judul textinput)
  List<String> namaPengarangListInput = ['Nama Pengarang'];

  // controller
  //global input controller untuk input data mengenai dapus
  List<TextEditingController> inputController = [];
  // controller untuk nama pengarang
  List<TextEditingController> controllerNamaPengarang = [
    TextEditingController(),
  ];

  // list nama pengarang (dipakai untuk parding data nama pengarang ke fungsi apastyle)
  List<String> nama_pengarang = [''];
  // list input

  // mengubah text menjadi italic
  String toItalic(String input) {
    return input.split('').map((c) => italicMap[c] ?? c).join();
  }

  // mengubah nama pengarang sesuai dengan APA style
  // returnnya adalah string dari nama pengarang yang sudah diubah
  String formatAPAAuthors(List<String> authors) {
    // Ubah setiap nama menjadi format: Nama Belakang, Inisial Nama Depan
    List<String> formatted =
        authors.map((fullName) {
          List<String> parts = fullName.trim().split(' ');
          if (parts.length == 1)
            return fullName; // Nama tunggal, kembalikan apa adanya
          String lastName = parts.last;
          String initials = parts
              .sublist(0, parts.length - 1)
              .map((name) => '${name[0].toUpperCase()}.')
              .join(' ');
          return '$lastName, $initials';
        }).toList();

    // Gabungkan berdasarkan jumlah penulis
    if (formatted.length == 1) {
      return formatted[0];
    } else if (formatted.length == 2) {
      return '${formatted[0]} & ${formatted[1]}';
    } else if (formatted.length <= 20) {
      return '${formatted.sublist(0, formatted.length - 1).join(', ')}, & ${formatted.last}';
    } else {
      return '${formatted.sublist(0, 19).join(', ')}, ... ${formatted.last}';
    }
  }

  // buka link
  void _launchUrl(String link) {
    final Uri url = Uri.parse(link); // Ganti dengan link kamu

    launchUrl(url);
  }

  // format string sesuai dengan gaya
  String formatted_string = '';
  String formatString(String style, String value, int index) {
    // style adalah style dapus yang dipilih user
    // value adalah input user di index tertentu
    // index adalah index yang dipilih user
    if (style == listStyle[0]) {
      // user memilih style apa untuk buku
      if (index == 0) {
        listInput[index] = ' ($value). ';
      } // jika judul buku
      else if (index == 1) {
        listInput[index] = '$value. ';
      } // jika penerbit
      else if (index == 2) {
        listInput[index] = '$value: ';
      } else if (index == 3) {
        listInput[index] = '$value.';
      }

      formatted_string =
          listInput[0] + listInput[1] + listInput[2] + listInput[3];
    } else if (style == listStyle[1]) {
      // user memilih style apa jika bukunya dipublish organisasi

      if (index == 0) {
        // organisasi penulis buku
        listInput[index] = '$value. ';
      } // jika judul buku
      else if (index == 1) {
        // tahun terbit
        listInput[index] = '($value). ';
      } // jika penerbit
      else if (index == 2) {
        // judul buku
        listInput[index] = toItalic(value) + '. ';
      } else if (index == 3) {
        // kota penerbit
        listInput[index] = '$value: ';
      } else if (index == 4) {
        // penerbit
        listInput[index] = '$value.';
      }
      formatted_string =
          listInput[0] +
          listInput[1] +
          listInput[2] +
          listInput[3] +
          listInput[4];
    } else if (style == listStyle[2]) {
      //APA style untuk buku terjemahan
      if (index == 0) {
        //Tahun Penerbitan
        listInput[index] = '($value). ';
      } else if (index == 1) {
        // judul buku
        listInput[index] = toItalic(value) + '. ';
      } else if (index == 2) {
        // penerjemah
        String new_value = '';
        for (String item in value.split(' ')) {
          if (item == value.split(' ')) {
            /// jika indeks pertama
            new_value += item[0];
          } else {
            new_value += item;
          }
        }
        listInput[index] = '($new_value, Penerjemah). ';
      } else if (index == 3) {
        // kota penerbit
        listInput[index] = '$value: ';
      } else if (index == 4) {
        // penerbit
        listInput[index] = '$value.';
      }

      formatted_string =
          listInput[0] +
          listInput[1] +
          listInput[2] +
          listInput[3] +
          listInput[4];

      ///jurnal online
    } else if (selectedStyle == listStyle[3]) {
      // untuk jurnal
      if (index == 0) {
        // Tahun Penerbitan
        listInput[index] = ' ($value). ';
      } else if (index == 1) {
        // Judul Artikel
        listInput[index] = '$value. ';
      } else if (index == 2) {
        // Nama Jurnal
        listInput[index] = toItalic(value) + ', ';
      } else if (index == 3) {
        // volume
        listInput[index] = value;
      } else if (index == 4) {
        // isu atau nomor
        listInput[index] = '($value), ';
      } else if (index == 5) {
        // halaman
        listInput[index] = '$value. ';
      } else if (index == 6) {
        // DOI atau url

        listInput[index] = value;
      }

      formatted_string =
          listInput[0] +
          listInput[1] +
          listInput[2] +
          listInput[3] +
          listInput[4] +
          listInput[5] +
          listInput[6];

      ///jurnal online
    } else if (selectedStyle == listStyle[4]) {
      // untuk jurnal
      if (index == 0) {
        // Tahun Penerbitan
        listInput[index] = ' ($value). ';
      } else if (index == 1) {
        // Judul Artikel
        listInput[index] = '$value. ';
      } else if (index == 2) {
        // Nama Jurnal
        listInput[index] = toItalic(value) + ', ';
      } else if (index == 3) {
        // volume
        listInput[index] = value;
      } else if (index == 4) {
        // isu atau nomor
        listInput[index] = '($value), ';
      } else if (index == 5) {
        // halaman
        listInput[index] = '$value. ';
      } else if (index == 6) {
        // DOI atau url

        listInput[index] = value;
      }

      formatted_string =
          listInput[0] +
          listInput[1] +
          listInput[2] +
          listInput[3] +
          listInput[4] +
          listInput[5] +
          listInput[6];

      // E-book
    } else if (selectedStyle == listStyle[5]) {
      if (index == 0) {
        // Tahun Terbit
        listInput[index] = ' ($value). ';
      } else if (index == 1) {
        // Judul E-Book
        listInput[index] = toItalic(value);
      } else if (index == 2) {
        // Edisi (Jika Ada)
        if (value.isNotEmpty) {
          listInput[index] = '(Edisi $value)';
        } else {
          listInput[index] = '';
        }
        listInput[index] += '. ';
      } else if (index == 3) {
        // penerbit
        listInput[index] = value + '. ';
      } else if (index == 4) {
        // Tautan E-Book
        listInput[index] = value;
      }

      formatted_string =
          listInput[0] +
          listInput[1] +
          listInput[2] +
          listInput[3] +
          listInput[4];
    }

    return formatted_string; // return string yang sudah di format
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset(
          'assets/images/Citeora(banner).png',
          height: 40, // atur tinggi sesuai kebutuhan
          fit: BoxFit.contain,
          alignment: Alignment.centerLeft,
        ),
        leadingWidth: 1024,

        backgroundColor: Color(0xFFF8F5F0), // primary background color,
        surfaceTintColor:
            Colors.transparent, // cegah perubahan warna ketika scroll

        actions: [
          // tombol github
          TextButton(
            onPressed: () {
              // buka url
              _launchUrl('https://github.com/tibeesdev/citeora');
            },
            child: Text(
              'GitHub',
              style: TextStyle(
                color: Color(0xFF24334E),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Color(0xFFF8F5F0),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: 200, maxWidth: 800),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // teks Pembuat daftar pustaka otomatis
                teksJudul(),

                // teks cara pembuatan
                teksSubJudul(),

                // bagian input user
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey, width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color:
                            Colors.grey
                                .withValues(), // Warna bayangan dengan tingkat opasitas
                        spreadRadius:
                            1.0, // Seberapa jauh bayangan menyebar dari kotak
                        blurRadius: 5.0, // Tingkat keburaman bayangan
                        offset: Offset(
                          0,
                          2,
                        ), // Posisi offset bayangan (horizontal, vertikal)
                      ),
                    ],
                  ),

                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        // dropdown di bagian paling atas
                        dropDownStyleDAPUS(),

                        // list builder khusus untuk nama pengarang
                        selectedStyle == listStyle[0] ||
                                selectedStyle == listStyle[2] ||
                                selectedStyle == listStyle[3] ||
                                selectedStyle == listStyle[4] ||
                                selectedStyle == listStyle[5]
                            ? widgetNamaPengarang()
                            : Container(),
                        ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                        // list builder untuk item lain

                        // cek stylenya
                        selectedStyle ==
                                listStyle[0] // APA buku
                            ? widgetStyleAPABuku()
                            : Container(), // ganti kode ini jika mau menambahkan style lain
                        selectedStyle == listStyle[1]
                            ? widgetStyleAPABuku()
                            : Container(), // APA Buku dari organisasi
                        selectedStyle == listStyle[2]
                            ? widgetStyleAPABuku()
                            : Container(), // APA buku terjemahan
                        selectedStyle == listStyle[3]
                            ? widgetStyleAPABuku()
                            : Container(), // APA buku dari jurnal
                        selectedStyle == listStyle[4]
                            ? widgetStyleAPABuku()
                            : Container(), // APA buku dari jurnal
                        selectedStyle == listStyle[5]
                            ? widgetStyleAPABuku()
                            : Container(), // APA buku dari jurnal
                      ],
                    ),
                  ),
                ),

                // bagian salin dapus
                selectedStyle != '' ? widgetSalin(context) : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding dropDownStyleDAPUS() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: DropdownButtonFormField2(
        alignment: Alignment.center,
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

          // style yang dipilih APA(buku)
          // inisiasi controller
          // hapus semua value list
          listInput = [];
          for (var i = 0; i < mapStyletoInput[value]!.length; i++) {
            inputController.add(TextEditingController()); // inisiasi controller
            // tambah string kosong
            listInput.add('');
          }

          if (kDebugMode) {
            print(value);
          }
        },
        decoration: InputDecoration(
          labelText: 'Pilih Gaya Penulisan',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.black),
          ),
        ),
      ),
    );
  }

  Padding teksSubJudul() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Text(
        'Pilih gaya penulisan, masukkan data, dan salin daftar pustaka dalam hitungan detik.',
        style: TextStyle(color: Color(0xFF24334E), fontSize: 20),
      ),
    );
  }

  Padding teksJudul() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Text(
        'Pembuat Daftar Pustaka Otomatis',
        style: TextStyle(
          color: Color(0xFF24334E),
          fontSize: 34,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  ListView widgetNamaPengarang() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: namaPengarangListInput.length,
      itemBuilder: (context, index) {
        // buat ccontroller (buat store value dari list, kalo gak pake controller setiap kali ada tambahan nama pengarang, nama pengarang sebelumnya dihapus dari kotak teks)
        TextEditingController controller = controllerNamaPengarang[index];

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
                          nama_pengarang_yang_sudah_dirubah = (formatAPAAuthors(
                            nama_pengarang,
                          ));
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
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // lakukan pengecekan, jika Nama pengarang berada di indeks pertama maka gunakan tombol tambah
              // jika bukan di indeks terakhir maka gunakan tombol sampah untuk menghapus
              index == 0
                  ?
                  // button tambah nama pengarang
                  ElevatedButton(
                    onPressed: () {
                      // aksi untuk menambah nama pengarang
                      // menambah input nama pengarang
                      setState(() {
                        namaPengarangListInput.add('Nama Pengarang');
                        controllerNamaPengarang.add(TextEditingController());
                        nama_pengarang.add('');
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.all(20),
                      backgroundColor: Colors.white,
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
                      backgroundColor: const Color.fromARGB(255, 249, 252, 255),
                    ),
                  ),
            ],
          ),
        );
      },
    );
  }

  ListView widgetStyleAPABuku() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: mapStyletoInput[selectedStyle]!.length, // ambil list dari key
      itemBuilder: (context, index) {
        String title = mapStyletoInput[selectedStyle]![index];
        // controller
        TextEditingController controller = inputController[index];
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              onChanged: (value) {
                // masukkan data dari controller ke dalam list yang berisi string untuk tanggal, judul, dan penerbit
                setState(() {
                  formatString(selectedStyle!, value, index);
                  // jika tahun terbit
                  // if (index == 0) {
                  //   listInput[index] = ' ($value). ';
                  // } // jika judul buku
                  // else if (index == 1) {
                  //   listInput[index] = '$value. ';
                  // } // jika penerbit
                  // else if (index == 2) {
                  //   listInput[index] = '$value.';
                  // }
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
        );
      },
    );
  }

  Padding widgetSalin(BuildContext context) {
    String result = '';
    result = nama_pengarang_yang_sudah_dirubah + formatted_string;

    return Padding(
      padding: EdgeInsets.all(10),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey, width: 1),
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color:
                  Colors.grey
                      .withValues(), // Warna bayangan dengan tingkat opasitas
              spreadRadius: 1.0, // Seberapa jauh bayangan menyebar dari kotak
              blurRadius: 5.0, // Tingkat keburaman bayangan
              offset: Offset(
                0,
                2,
              ), // Posisi offset bayangan (horizontal, vertikal)
            ),
          ],
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 800, minWidth: 200),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
                  textAlign: TextAlign.center,
                  controller: TextEditingController(text: result),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.all(10),
                child: ElevatedButton.icon(
                  onPressed: () {
                    String text = result;
                    Clipboard.setData(ClipboardData(text: text));
                    // tampilkan snackbar
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Text Disalin'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  label: Text(
                    'salin',
                    style: TextStyle(color: Color(0xFFFFFAF2)),
                  ),
                  icon: Icon(Icons.copy, color: Color(0xFFFFFAF2)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF24334E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
