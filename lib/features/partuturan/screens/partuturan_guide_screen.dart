import 'package:flutter/material.dart';

class PartuturanGuideScreen extends StatelessWidget {
  const PartuturanGuideScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panduan Partuturan'),
      ),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            Container(
              color: Theme.of(context).primaryColor,
              child: const TabBar(
                tabs: [
                  Tab(text: 'Hula-hula'),
                  Tab(text: 'Dongan Tubu'),
                  Tab(text: 'Boru'),
                ],
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                indicatorColor: Colors.white,
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildHulahulaTab(),
                  _buildDonganTubuTab(),
                  _buildBoruTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHulahulaTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Hula-hula',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Hula-hula adalah istilah dalam adat Batak Toba untuk menyebut keluarga laki-laki dari pihak istri atau ibu.',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          const Text(
            'Tutur sapa dalam Hula-hula:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          _buildPartuturanItem(
            term: 'Bona Ni Ari',
            description: 'Tulang dari ompu kandung',
          ),
          _buildPartuturanItem(
            term: 'Bona Tulang',
            description: 'Tulang dari ayah',
          ),
          _buildPartuturanItem(
            term: 'Ompu Bao',
            description: 'Kedua orang tua dari ibu kandung',
          ),
          _buildPartuturanItem(
            term: 'Tulang',
            description: 'Saudara laki-laki ibu kandung',
          ),
          _buildPartuturanItem(
            term: 'Nantulang',
            description: 'Istri tulang',
          ),
          _buildPartuturanItem(
            term: 'Lae',
            description: 'Anak laki-laki tulang',
          ),
          _buildPartuturanItem(
            term: 'Bao',
            description: 'Besan',
          ),
          _buildPartuturanItem(
            term: 'Paramaan/Tulang Na Poso',
            description:
                'Panggilan kepada anak laki-laki dari abang namboru oleh namboru/amangboru',
          ),
        ],
      ),
    );
  }

  Widget _buildDonganTubuTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Dongan Tubu (Sabutuha)',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Dongan tubu adalah saudara laki-laki semarga, atau teman lahir, dalam adat Batak Toba.',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          const Text(
            'Tutur sapa dalam Dongan Sabutuha:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          _buildPartuturanItem(
            term: 'Ompu Parsadaan',
            description:
                'Ompu yang bisa dilacak sebagai persamaan antara dua orang semarga (tingkat tertinggi)',
          ),
          _buildPartuturanItem(
            term: 'Ompu Mangulahi',
            description: 'Ompu dari Ompu',
          ),
          _buildPartuturanItem(
            term: 'Ama Mangulahi',
            description: 'Bapak dari ompu suhut',
          ),
          _buildPartuturanItem(
            term: 'Ompu Suhut',
            description: 'Ompu kandung / ayahnya ayah',
          ),
          _buildPartuturanItem(
            term: 'Ama Suhut',
            description: 'Ayah kandung',
          ),
          _buildPartuturanItem(
            term: 'Haha',
            description: 'Abang kandung',
          ),
          _buildPartuturanItem(
            term: 'Anggi',
            description: 'Adik kandung',
          ),
          _buildPartuturanItem(
            term: 'Anak',
            description: 'Anak',
          ),
          _buildPartuturanItem(
            term: 'Pahompu',
            description: 'Cucu perempuan dan laki-laki',
          ),
          _buildPartuturanItem(
            term: 'Nini',
            description: 'Cicit laki-laki',
          ),
          _buildPartuturanItem(
            term: 'Nono',
            description: 'Cicit perempuan',
          ),
          _buildPartuturanItem(
            term: 'Ondok-ondok',
            description: 'Cucu dari cucu laki-laki',
          ),
          _buildPartuturanItem(
            term: 'Ompu Boru',
            description: 'Orang tua perempuan dari ayah',
          ),
          _buildPartuturanItem(
            term: 'Ina Pangintubu',
            description: 'Ibu kandung',
          ),
          _buildPartuturanItem(
            term: 'Haha Boru',
            description: 'Istri dari abang kandung',
          ),
          _buildPartuturanItem(
            term: 'Anggi Boru',
            description: 'Istri adik laki-laki',
          ),
        ],
      ),
    );
  }

  Widget _buildBoruTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Boru',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Boru adalah kelompok orang dari saudara perempuan atau saudara perempuan dari laki-laki. Boru biasanya menjadi pihak yang memegang andil besar dalam menyukseskan pesta pernikahan atau acara adat lainnya.',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          const Text(
            'Tutur sapa dalam Boru:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          _buildPartuturanItem(
            term: 'Ito',
            description:
                'Saudara perempuan satu marga, anak perempuan dari namboru',
          ),
          _buildPartuturanItem(
            term: 'Lae',
            description: 'Anak laki-laki tulang, anak laki-laki dari namboru',
          ),
          _buildPartuturanItem(
            term: 'Amangboru',
            description: 'Suami dari saudara perempuan ayah',
          ),
          _buildPartuturanItem(
            term: 'Namboru',
            description: 'Saudara perempuan ayah',
          ),
          _buildPartuturanItem(
            term: 'Hela',
            description: 'Suami dari anak perempuan',
          ),
          _buildPartuturanItem(
            term: 'Boru',
            description: 'Anak kandung perempuan',
          ),
          _buildPartuturanItem(
            term: 'Ito Mangulahi',
            description: 'Namboru kandung ayah kandung',
          ),
          _buildPartuturanItem(
            term: 'Lae Mangulahi',
            description: 'Suami dari Ito Mangulahi',
          ),
          _buildPartuturanItem(
            term: 'Bere',
            description: 'Semua keturunan dari adik/kakak perempuan',
          ),
          _buildPartuturanItem(
            term: 'Pariban',
            description: 'Anak perempuan dari tulang',
          ),
          _buildPartuturanItem(
            term: 'Tulang rorobot',
            description: 'Tulang ibu beserta keturunannya',
          ),
          _buildPartuturanItem(
            term: 'Nantulang rorobot',
            description: 'Istri dari tulang rorobot',
          ),
        ],
      ),
    );
  }

  Widget _buildPartuturanItem(
      {required String term, required String description}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              term,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade900,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              description,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
