import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tentang Batak Toba'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'assets/images/batak_toba_header.jpg',
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 24),

            // Introduction
            const Text(
              'Suku Batak Toba',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Suku Batak Toba adalah salah satu sub-etnis dari suku Batak yang mendiami wilayah di sekitar Danau Toba, Sumatera Utara, Indonesia. Masyarakat Batak Toba memiliki sistem kekerabatan yang unik dan kompleks, yang tercermin dalam berbagai aspek kehidupan mereka.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),

            // Marga system
            _buildSection(
                title: 'Sistem Marga',
                content:
                    'Marga adalah identitas genealogis yang menunjukkan asal-usul seseorang dalam masyarakat Batak Toba. Sistem marga bersifat patrilineal, artinya diwariskan dari ayah ke anak. Marga berfungsi sebagai pengelompokan sosial, pengatur perkawinan, dan penanda identitas dalam masyarakat Batak Toba.'),

            // Dalihan Na Tolu
            _buildSection(
              title: 'Dalihan Na Tolu',
              content:
                  'Dalihan Na Tolu (Tungku Tiga Kaki) adalah falsafah hidup masyarakat Batak Toba yang mengatur interaksi sosial. Tiga unsur dalam Dalihan Na Tolu adalah:\n\n'
                  '1. Hula-hula: Kelompok pemberi istri (somba marhula-hula)\n'
                  '2. Boru: Kelompok penerima istri (elek marboru)\n'
                  '3. Dongan Tubu/Sabutuha: Kelompok satu marga (manat mardongan tubu)',
            ),

            // Partuturan
            _buildSection(
                title: 'Partuturan (Tutur Sapa)',
                content:
                    'Partuturan adalah sistem pemanggilan atau tutur sapa dalam adat Batak Toba. Setiap orang dipanggil dengan istilah tertentu berdasarkan hubungan kekerabatan mereka. Sistem partuturan sangat penting dalam interaksi sosial masyarakat Batak Toba.'),

            // Tarombo
            _buildSection(
                title: 'Tarombo (Silsilah)',
                content:
                    'Tarombo adalah silsilah keluarga yang mencatat hubungan kekerabatan dalam masyarakat Batak Toba. Tarombo sangat penting untuk menentukan posisi seseorang dalam struktur adat dan menghindari perkawinan sedarah. Dalam tarombo, garis keturunan laki-laki lebih diutamakan sesuai dengan sistem patrilineal.'),

            // References
            const SizedBox(height: 24),
            const Text(
              'Referensi',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _buildReferenceItem(
              'Simanjuntak, B. A. (2006). Struktur Sosial dan Sistem Politik Batak Toba Hingga 1945.',
            ),
            _buildReferenceItem(
              'Vergouwen, J. C. (2004). Masyarakat dan Hukum Adat Batak Toba.',
            ),
            _buildReferenceItem(
              'Situmorang, S. (1993). Toba Na Sae: Sejarah Lembaga Sosial Politik Abad XIII-XX.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required String content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildReferenceItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}
