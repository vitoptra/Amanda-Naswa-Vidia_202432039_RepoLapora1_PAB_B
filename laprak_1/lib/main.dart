import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class Cafe {
  final String name;
  final String location;
  final String category;
  final double rating;
  final int priceLevel;
  final bool hasWifi;
  final IconData icon;

  const Cafe({
    required this.name,
    required this.location,
    required this.category,
    required this.rating,
    required this.priceLevel,
    required this.hasWifi,
    required this.icon,
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const espresso = Color(0xFF49392F);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CafeHunt',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF806B55),
          surface: const Color(0xFFFAF7F1),
        ),
        scaffoldBackgroundColor: const Color(0xFFFAF7F1),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFAF7F1),
          foregroundColor: espresso,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: espresso,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ),
      home: const CafeHuntHome(),
    );
  }
}

class CafeHuntHome extends StatefulWidget {
  const CafeHuntHome({super.key});

  @override
  State<CafeHuntHome> createState() => _CafeHuntHomeState();
}

class _CafeHuntHomeState extends State<CafeHuntHome> {
  final TextEditingController searchController = TextEditingController();

  final List<Cafe> cafes = const [
    Cafe(
      name: 'Sunday Morning',
      location: 'Jakarta Selatan',
      category: 'Cozy',
      rating: 4.8,
      priceLevel: 2,
      hasWifi: true,
      icon: Icons.coffee_rounded,
    ),
    Cafe(
      name: 'The Reading Room',
      location: 'Jakarta Pusat',
      category: 'Study Spot',
      rating: 4.7,
      priceLevel: 2,
      hasWifi: true,
      icon: Icons.menu_book_rounded,
    ),
    Cafe(
      name: 'Olive Garden Cafe',
      location: 'Jakarta Barat',
      category: 'Outdoor',
      rating: 4.6,
      priceLevel: 3,
      hasWifi: false,
      icon: Icons.park_rounded,
    ),
    Cafe(
      name: 'Maison de Café',
      location: 'Jakarta Selatan',
      category: 'Aesthetic',
      rating: 4.9,
      priceLevel: 3,
      hasWifi: true,
      icon: Icons.local_cafe_rounded,
    ),
  ];

  final Set<String> favorites = {'Sunday Morning'};
  String selectedCategory = 'All';

  final List<String> categories = const [
    'All',
    'Cozy',
    'Study Spot',
    'Outdoor',
    'Aesthetic',
  ];

  List<Cafe> get filteredCafes {
    final keyword = searchController.text.toLowerCase().trim();

    return cafes.where((cafe) {
      final matchesCategory =
          selectedCategory == 'All' || cafe.category == selectedCategory;
      final matchesSearch =
          cafe.name.toLowerCase().contains(keyword) ||
          cafe.location.toLowerCase().contains(keyword);
      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  String priceLabel(int level) => '\$' * level;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.local_cafe_rounded, size: 27),
            SizedBox(width: 9),
            Text(
              'CafeHunt',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Favorit',
            onPressed: () {
              setState(() {
                selectedCategory = 'All';
                searchController.clear();
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Kamu punya ${favorites.length} kafe favorit.'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            icon: const Icon(Icons.favorite_border_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            // Membatasi lebar konten agar tetap rapi di layar browser yang lebar.
            constraints: const BoxConstraints(maxWidth: 640),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 28),
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFE9DDCC), Color(0xFFF4EDE2)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'YOUR NEXT COFFEE SPOT',
                        style: TextStyle(
                          color: Color(0xFF806B55),
                          fontSize: 10,
                          letterSpacing: 2,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Find your\nlittle escape.',
                        style: TextStyle(
                          color: Color(0xFF49392F),
                          fontSize: 29,
                          height: 1.12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 9),
                      Text(
                        'Temukan tempat nyaman untuk kopi, cerita, dan ide baru.',
                        style: TextStyle(
                          color: Color(0xFF6D5A4B),
                          fontSize: 13,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: SummaryCard(
                        icon: Icons.local_cafe_outlined,
                        title: 'Total Kafe',
                        value: '${cafes.length}',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SummaryCard(
                        icon: Icons.favorite_rounded,
                        title: 'Favorit',
                        value: '${favorites.length}',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 23),
                const Text(
                  'Find your vibe',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF49392F),
                  ),
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: categories.map((category) {
                      final isSelected = selectedCategory == category;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(category),
                          selected: isSelected,
                          onSelected: (_) {
                            setState(() => selectedCategory = category);
                          },
                          selectedColor: const Color(0xFF49392F),
                          backgroundColor: Colors.white,
                          labelStyle: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : const Color(0xFF665548),
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                          side: BorderSide(
                            color: isSelected
                                ? const Color(0xFF49392F)
                                : const Color(0xFFE8DFD3),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 18),
                TextField(
                  controller: searchController,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'Cari nama kafe atau lokasi...',
                    hintStyle: const TextStyle(fontSize: 13),
                    prefixIcon: const Icon(Icons.search_rounded),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: Color(0xFFE8DFD3)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: Color(0xFFE8DFD3)),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Curated for you',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF49392F),
                        ),
                      ),
                    ),
                    Text(
                      '${filteredCafes.length} places',
                      style: const TextStyle(
                        color: Color(0xFF8C7A68),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (filteredCafes.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Column(
                      children: [
                        Icon(
                          Icons.search_off_rounded,
                          size: 34,
                          color: Color(0xFF9B8976),
                        ),
                        SizedBox(height: 8),
                        Text('Kafe tidak ditemukan'),
                        SizedBox(height: 4),
                        Text(
                          'Coba kata kunci atau kategori lain.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black54, fontSize: 12),
                        ),
                      ],
                    ),
                  )
                else
                  ...filteredCafes.map((cafe) {
                    return CafeCard(
                      cafe: cafe,
                      priceLabel: priceLabel(cafe.priceLevel),
                      isFavorite: favorites.contains(cafe.name),
                      onFavoritePressed: () {
                        setState(() {
                          if (favorites.contains(cafe.name)) {
                            favorites.remove(cafe.name);
                          } else {
                            favorites.add(cafe.name);
                          }
                        });
                      },
                      onDetailsPressed: () {
                        showModalBottomSheet(
                          context: context,
                          showDragHandle: true,
                          backgroundColor: const Color(0xFFFAF7F1),
                          builder: (context) {
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(24, 8, 24, 30),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    cafe.icon,
                                    size: 38,
                                    color: const Color(0xFF806B55),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    cafe.name,
                                    style: const TextStyle(
                                      fontSize: 23,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF49392F),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text('${cafe.location} · ${cafe.category}'),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Rating ${cafe.rating}  ·  ${priceLabel(cafe.priceLevel)}',
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    cafe.hasWifi
                                        ? 'Wi-Fi tersedia — cocok untuk belajar atau bekerja.'
                                        : 'Pilihan untuk menikmati suasana dan bersantai.',
                                  ),
                                  const SizedBox(height: 18),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        setState(() {
                                          if (favorites.contains(cafe.name)) {
                                            favorites.remove(cafe.name);
                                          } else {
                                            favorites.add(cafe.name);
                                          }
                                        });
                                        Navigator.pop(context);
                                      },
                                      icon: const Icon(Icons.favorite_rounded),
                                      label: Text(
                                        favorites.contains(cafe.name)
                                            ? 'Hapus dari Favorit'
                                            : 'Simpan ke Favorit',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    );
                  }),
                const SizedBox(height: 8),
                const Center(
                  child: Text(
                    'Made for your coffee moments ☕',
                    style: TextStyle(color: Color(0xFF9B8976), fontSize: 11),
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

class SummaryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const SummaryCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: Color(0xFFECE4D9)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: const Color(0xFFF2EADF),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(icon, color: const Color(0xFF806B55), size: 21),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF49392F),
                    ),
                  ),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF8C7A68),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CafeCard extends StatelessWidget {
  final Cafe cafe;
  final String priceLabel;
  final bool isFavorite;
  final VoidCallback onFavoritePressed;
  final VoidCallback onDetailsPressed;

  const CafeCard({
    super.key,
    required this.cafe,
    required this.priceLabel,
    required this.isFavorite,
    required this.onFavoritePressed,
    required this.onDetailsPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 13),
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: Color(0xFFECE4D9)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(13),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 78,
              height: 92,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFE8DCCB), Color(0xFFF6F0E7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(cafe.icon, size: 35, color: const Color(0xFF806B55)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cafe.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF49392F),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 14,
                        color: Color(0xFF8C7A68),
                      ),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          cafe.location,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF8C7A68),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 9,
                    runSpacing: 5,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            size: 15,
                            color: Color(0xFFC08B3C),
                          ),
                          const SizedBox(width: 3),
                          Text(
                            cafe.rating.toString(),
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        priceLabel,
                        style: const TextStyle(
                          color: Color(0xFF806B55),
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (cafe.hasWifi)
                        const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.wifi_rounded,
                              size: 14,
                              color: Color(0xFF718064),
                            ),
                            SizedBox(width: 3),
                            Text('Wi-Fi', style: TextStyle(fontSize: 11)),
                          ],
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: onDetailsPressed,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF49392F),
                            side: const BorderSide(color: Color(0xFFD8C8B5)),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            visualDensity: VisualDensity.compact,
                          ),
                          child: const Text(
                            'Detail',
                            style: TextStyle(fontSize: 11),
                          ),
                        ),
                      ),
                      const SizedBox(width: 7),
                      IconButton(
                        tooltip: isFavorite
                            ? 'Hapus favorit'
                            : 'Tambah favorit',
                        onPressed: onFavoritePressed,
                        visualDensity: VisualDensity.compact,
                        constraints: const BoxConstraints(
                          minWidth: 38,
                          minHeight: 36,
                        ),
                        padding: EdgeInsets.zero,
                        style: IconButton.styleFrom(
                          backgroundColor: const Color(0xFFF5EFE6),
                        ),
                        icon: Icon(
                          isFavorite
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          color: isFavorite
                              ? const Color(0xFF98645C)
                              : const Color(0xFF806B55),
                          size: 19,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
