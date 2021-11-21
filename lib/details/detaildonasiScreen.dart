import 'package:earthgrow/details/jumlahtransferScreen.dart';
import 'package:flutter/material.dart';

class DetailDonasi extends StatefulWidget {
  const DetailDonasi({Key? key}) : super(key: key);

  @override
  _DetailDonasiState createState() => _DetailDonasiState();
}

class _DetailDonasiState extends State<DetailDonasi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        title: Text('Detail'),
      ),
      body: Stack(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTORmUEM7MrEvMh8XjCeQhKvYdtKQC5GTZRYQ&usqp=CAU',
                    fit: BoxFit.cover,
                    height: 250,
                    width: double.infinity,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Bantu saya membangun rumah tani',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text('5/20 Hari tersisa'),
                SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total terkumpul'),
                    Text(
                      'Rp. 5.000.000',
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Diiklankan oleh'),
                    Text(
                      'Kharisma Mahardika',
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => JumlahTransfer()),
                );
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    'Donasi Sekarang',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
