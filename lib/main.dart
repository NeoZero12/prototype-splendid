import 'package:flutter/material.dart';

void main() {
  runApp(const PasarSplendidApp());
}

class PasarSplendidApp extends StatelessWidget {
  const PasarSplendidApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pasar Splendid Malang',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Plus Jakarta Sans',
        scaffoldBackgroundColor: const Color(0xFFF8FAFC), // slate-50
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF059669), // emerald-600
          primary: const Color(0xFF059669),
          surface: Colors.white,
        ),
        useMaterial3: true,
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  void _openTab(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          DashboardScreen(onNavigate: _openTab),
          const ForumScreen(),
          const PetaScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _openTab,
        indicatorColor: const Color(0xFFD1FAE5), // emerald-100
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.store_outlined),
            selectedIcon: Icon(Icons.store, color: Color(0xFF059669)),
            label: 'Beranda',
          ),
          NavigationDestination(
            icon: Icon(Icons.forum_outlined),
            selectedIcon: Icon(Icons.forum, color: Color(0xFF059669)),
            label: 'Forum',
          ),
          NavigationDestination(
            icon: Icon(Icons.map_outlined),
            selectedIcon: Icon(Icons.map, color: Color(0xFF059669)),
            label: 'Peta Lokasi',
          ),
        ],
      ),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  final ValueChanged<int> onNavigate;

  const DashboardScreen({super.key, required this.onNavigate});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ScrollController _scrollController = ScrollController();
  final FocusNode _searchFocusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey _catalogKey = GlobalKey();
  String? _selectedSector;
  String _searchQuery = '';

  static const List<SectorInfo> _sectors = [
    SectorInfo(
      title: 'Pasar Burung',
      desc: 'Burung berkicau, sangkar, pakan & perlengkapan.',
      tag: 'Burung',
      tagColor: Color(0xFFF59E0B),
      icon: Icons.flutter_dash,
      imageUrl: 'https://images.unsplash.com/photo-1522858547137-f1dcec554f55?w=500&auto=format&fit=crop&q=80',
    ),
    SectorInfo(
      title: 'Pasar Ikan Hias',
      desc: 'Ikan air tawar, akuarium custom, aquascape & filter.',
      tag: 'Ikan Hias',
      tagColor: Color(0xFF0EA5E9),
      icon: Icons.set_meal_outlined,
      imageUrl: 'https://images.unsplash.com/photo-1520301255226-bf5f144451c1?w=500&auto=format&fit=crop&q=80',
    ),
    SectorInfo(
      title: 'Pasar Bunga',
      desc: 'Anggrek, tanaman hias, pot, pupuk & media tanam.',
      tag: 'Bunga',
      tagColor: Color(0xFF10B981),
      icon: Icons.local_florist_outlined,
      imageUrl: 'https://images.unsplash.com/photo-1508610048659-a06b669e3321?w=500&auto=format&fit=crop&q=80',
    ),
    SectorInfo(
      title: 'Hewan Peliharaan',
      desc: 'Kelinci, kucing, hamster, reptil hias, & pakan.',
      tag: 'Hewan',
      tagColor: Color(0xFFF43F5E),
      icon: Icons.pets_outlined,
      imageUrl: 'https://images.unsplash.com/photo-1548767797-d8c844163c4c?w=500&auto=format&fit=crop&q=80',
    ),
  ];
  static const SectorInfo _allSectorsOption = SectorInfo(
    title: 'Semua sektor',
    desc: '',
    tag: 'Semua',
    tagColor: Color(0xFF059669),
    icon: Icons.grid_view_rounded,
    imageUrl: '',
  );

  @override
  void dispose() {
    _scrollController.dispose();
    _searchFocusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _scrollToCatalog() {
    final context = _catalogKey.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOut,
      );
    }
  }

  void _showNotifications() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Notifikasi'),
        content: const Text('Belum ada notifikasi baru.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _showHelp() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Bantuan'),
        content: const Text(
          'Jelajahi katalog sektor, cari kebutuhanmu, atau buka Forum dan Peta dari akses cepat.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Mengerti'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.store, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pasar Splendid',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                Text(
                  'Kota Malang',
                  style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Notifikasi',
            icon: const Icon(Icons.notifications_none_outlined, color: Color(0xFF334155)),
            onPressed: _showNotifications,
          ),
          IconButton(
            tooltip: 'Bantuan',
            icon: const Icon(Icons.headset_mic_outlined, color: Color(0xFF059669)),
            onPressed: _showHelp,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                onChanged: (value) => setState(() => _searchQuery = value.trim().toLowerCase()),
                decoration: const InputDecoration(
                  hintText: 'Cari burung, ikan, tanaman...',
                  hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                  prefixIcon: Icon(Icons.search, color: Color(0xFF94A3B8)),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Hero Banner (Menggunakan Image.asset ke folder images/pasar.jpg)
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'images/pasar.jpg', // Path asset lokal sesuai folder
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  height: 180,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.85),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'PASAR FLORA DAN FAUNA MALANG',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Pasar Splendid Malang',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'Pusat transaksi & destinasi wisata terpadu flora, fauna, & ikan hias.',
                        style: TextStyle(
                          color: Color(0xFFCBD5E1),
                          fontSize: 12,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Stat Cards Horizontal Scroll
            SizedBox(
              height: 80,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: const [
                  StatCard(
                    title: 'Jam Operasional',
                    value: '07:00 - 17:00',
                    subtitle: 'Buka Setiap Hari',
                    icon: Icons.access_time,
                    iconBgColor: Color(0xFFECFDF5),
                    iconColor: Color(0xFF059669),
                  ),
                  SizedBox(width: 12),
                  StatCard(
                    title: 'Est. Pengunjung / Hari',
                    value: '1,250+',
                    subtitle: 'Ramai saat Weekend',
                    icon: Icons.people_outline,
                    iconBgColor: Color(0xFFEFF6FF),
                    iconColor: Color(0xFF2563EB),
                  ),
                  SizedBox(width: 12),
                  StatCard(
                    title: 'Anggota Komunitas',
                    value: '340 Active',
                    subtitle: 'Grup Diskusi',
                    icon: Icons.chat_bubble_outline,
                    iconBgColor: Color(0xFFF3E8FF),
                    iconColor: Color(0xFF9333EA),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const SectionHeading(
              title: 'Akses Cepat',
              subtitle: 'Buka fitur yang kamu butuhkan',
            ),
            const SizedBox(height: 12),
            QuickAccessGrid(
              items: [
                QuickAccessItem(
                  label: 'Cari',
                  icon: Icons.search,
                  color: const Color(0xFF2563EB),
                  onTap: () => _searchFocusNode.requestFocus(),
                ),
                QuickAccessItem(
                  label: 'Katalog',
                  icon: Icons.grid_view_rounded,
                  color: const Color(0xFF059669),
                  onTap: _scrollToCatalog,
                ),
                QuickAccessItem(
                  label: 'Forum',
                  icon: Icons.forum_outlined,
                  color: const Color(0xFF9333EA),
                  onTap: () => widget.onNavigate(1),
                ),
                QuickAccessItem(
                  label: 'Peta Lokasi',
                  icon: Icons.map_outlined,
                  color: const Color(0xFFEA580C),
                  onTap: () => widget.onNavigate(2),
                ),
                QuickAccessItem(
                  label: 'Notifikasi',
                  icon: Icons.notifications_none_outlined,
                  color: const Color(0xFFDB2777),
                  onTap: _showNotifications,
                ),
                QuickAccessItem(
                  label: 'Bantuan',
                  icon: Icons.headset_mic_outlined,
                  color: const Color(0xFF0891B2),
                  onTap: _showHelp,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Katalog sector selector
            SectionHeading(
              key: _catalogKey,
              title: 'Katalog Sektor Utama',
              subtitle: 'Pilih sektor untuk melihat katalog',
            ),
            const SizedBox(height: 14),
            SizedBox(
              height: 96,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _sectors.length + 1,
                separatorBuilder: (context, index) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final isAllOption = index == 0;
                  final sector = isAllOption ? _allSectorsOption : _sectors[index - 1];
                  final isSelected = isAllOption
                      ? _selectedSector == null
                      : _selectedSector == sector.title;
                  return SectorSelector(
                    sector: sector,
                    selected: isSelected,
                    onTap: () => setState(() => _selectedSector = isAllOption ? null : sector.title),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            if (_selectedSector != null || _searchQuery.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _selectedSector ?? 'Hasil pencarian',
                        style: const TextStyle(
                          color: Color(0xFF475569),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => setState(() {
                        _selectedSector = null;
                        _searchQuery = '';
                        _searchController.clear();
                      }),
                      child: const Text('Reset'),
                    ),
                  ],
                ),
              ),
            Builder(
              builder: (context) {
                final visibleSectors = _sectors.where((sector) {
                  final matchesSector = _selectedSector == null || sector.title == _selectedSector;
                  final query = _searchQuery;
                  final matchesQuery = query.isEmpty ||
                      sector.title.toLowerCase().contains(query) ||
                      sector.desc.toLowerCase().contains(query) ||
                      sector.tag.toLowerCase().contains(query);
                  return matchesSector && matchesQuery;
                }).toList();
                if (visibleSectors.isEmpty) {
                  return const EmptyCatalogResult();
                }
                return GridView.builder(
                  itemCount: visibleSectors.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.85,
                  ),
                  itemBuilder: (context, index) {
                    final sector = visibleSectors[index];
                    return SectorCard(
                      title: sector.title,
                      desc: sector.desc,
                      tag: sector.tag,
                      tagColor: sector.tagColor,
                      imageUrl: sector.imageUrl,
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ForumScreen extends StatelessWidget {
  const ForumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forum Komunitas', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_comment_outlined, color: Color(0xFF059669)),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ForumItemCard(
            tag: '[Burung]',
            tagColor: Color(0xFFFEF3C7),
            textColor: Color(0xFFB45309),
            title: 'Rekomendasi pakan racikan agar Murai Batu makin gacor?',
            author: 'KicauMania_Malang',
            time: '2 jam yang lalu',
            replies: 24,
            likes: 18,
          ),
          ForumItemCard(
            tag: '[Aquascape]',
            tagColor: Color(0xFFE0F2FE),
            textColor: Color(0xFF0369A1),
            title: 'Inpo agar chana saya semakin bringas bagaimana, soalnya chana saya tidak galak sama sekali',
            author: 'ChanaTheExplorer',
            time: '3 jam yang lalu',
            replies: 15,
            likes: 32,
          ),
          ForumItemCard(
            tag: '[Tanaman]',
            tagColor: Color(0xFFD1FAE5),
            textColor: Color(0xFF047857),
            title: 'Tips perawatan Anggrek Bulan bagi pemula agar cepat berbunga kembali',
            author: 'FloraLover88',
            time: '1 hari yang lalu',
            replies: 42,
            likes: 50,
          ),
          ForumItemCard(
            tag: '[Member]',
            tagColor: Color(0xFFE0F2FE),
            textColor: Color(0xFF0369A1),
            title: 'Sebagai informasi kepada semua orang khususnya orang luar malang, jika ke splendid jangan jam 4 atau 3 karena jam segitu mulai banyak yang sudah tutup',
            author: 'Mbass Chantik 💕',
            time: '1 jam yang lalu',
            replies: 95,
            likes: 102,
          ),
        ],
      ),
    );
  }
}

class PetaScreen extends StatelessWidget {
  const PetaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Peta & Denah Lokasi', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.location_on, color: Color(0xFF059669)),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Pasar Splendid Malang',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        'Jl. Brawijaya, Kauman, Kec. Klojen, Kota Malang (Dekat Tugu Balai Kota)',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFCBD5E1)),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.map, size: 64, color: Color(0xFF64748B)),
                      const SizedBox(height: 12),
                      const Text(
                        'Peta Lokasi Interaktif',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF334155)),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Dapat diintegrasikan dengan google_maps_flutter',
                        style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0F172A),
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {},
                        icon: const Icon(Icons.open_in_new, size: 16),
                        label: const Text('Buka di Google Maps'),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom Widgets
class SectorInfo {
  final String title;
  final String desc;
  final String tag;
  final Color tagColor;
  final IconData icon;
  final String imageUrl;

  const SectorInfo({
    required this.title,
    required this.desc,
    required this.tag,
    required this.tagColor,
    required this.icon,
    required this.imageUrl,
  });
}

class SectionHeading extends StatelessWidget {
  final String title;
  final String subtitle;

  const SectionHeading({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 3),
        Text(
          subtitle,
          style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
        ),
      ],
    );
  }
}

class QuickAccessItem {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const QuickAccessItem({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}

class QuickAccessGrid extends StatelessWidget {
  final List<QuickAccessItem> items;

  const QuickAccessGrid({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: items.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.1,
      ),
      itemBuilder: (context, index) {
        final item = items[index];
        return Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: item.onTap,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: item.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Icon(item.icon, color: item.color, size: 22),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    item.label,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF334155),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class SectorSelector extends StatelessWidget {
  final SectorInfo sector;
  final bool selected;
  final VoidCallback onTap;

  const SectorSelector({
    super.key,
    required this.sector,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = sector.tagColor;
    return SizedBox(
      width: 82,
      child: Material(
        color: selected ? color.withOpacity(0.1) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: selected ? color : const Color(0xFFE2E8F0),
                width: selected ? 1.5 : 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(sector.icon, color: color, size: 26),
                const SizedBox(height: 6),
                Text(
                  sector.tag,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: selected ? color : const Color(0xFF475569),
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EmptyCatalogResult extends StatelessWidget {
  const EmptyCatalogResult({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: const Column(
        children: [
          Icon(Icons.search_off, color: Color(0xFF94A3B8), size: 28),
          SizedBox(height: 8),
          Text(
            'Katalog tidak ditemukan',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 3),
          Text(
            'Coba kata kunci atau sektor lainnya.',
            style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
          ),
        ],
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title, style: const TextStyle(fontSize: 10, color: Color(0xFF64748B))),
                Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                Text(subtitle, style: const TextStyle(fontSize: 10, color: Color(0xFF059669), fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
        ],
      ),
    );
  }
}

class SectorCard extends StatelessWidget {
  final String title;
  final String desc;
  final String tag;
  final Color tagColor;
  final String imageUrl;

  const SectorCard({
    super.key,
    required this.title,
    required this.desc,
    required this.tag,
    required this.tagColor,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(
                  imageUrl,
                  height: 100,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: tagColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    tag,
                    style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A)),
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  style: const TextStyle(fontSize: 10, color: Color(0xFF64748B)),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ForumItemCard extends StatelessWidget {
  final String tag;
  final Color tagColor;
  final Color textColor;
  final String title;
  final String author;
  final String time;
  final int replies;
  final int likes;

  const ForumItemCard({
    super.key,
    required this.tag,
    required this.tagColor,
    required this.textColor,
    required this.title,
    required this.author,
    required this.time,
    required this.replies,
    required this.likes,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: tagColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  tag,
                  style: TextStyle(color: textColor, fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E293B)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Oleh: $author • $time',
            style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
          ),
          const Divider(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(Icons.chat_bubble_outline, size: 14, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text('$replies Balasan', style: const TextStyle(fontSize: 11, color: Colors.grey)),
              const SizedBox(width: 16),
              Icon(Icons.thumb_up_outlined, size: 14, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text('$likes Suka', style: const TextStyle(fontSize: 11, color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }
}
