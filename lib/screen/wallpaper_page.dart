import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'fullscreen_page.dart';

class WallpaperScreen extends StatefulWidget {
  const WallpaperScreen({super.key});

  @override
  State<WallpaperScreen> createState() => _WallpaperScreenState();
}

class _WallpaperScreenState extends State<WallpaperScreen> {
  List images = [];
  int page = 1;
  bool isLoading = false;
  bool hasMore = true;
  bool _showAppBar = true;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchapi();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    // Hide/show app bar logic
    if (_scrollController.offset > 100 && _showAppBar) {
      setState(() => _showAppBar = false);
    } else if (_scrollController.offset <= 100 && !_showAppBar) {
      setState(() => _showAppBar = true);
    }

    // Load more when reaching bottom
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent &&
        !isLoading &&
        hasMore) {
      loadmore();
    }
  }

  fetchapi() async {
    setState(() => isLoading = true);
    try {
      final response = await http.get(
        Uri.parse('https://api.pexels.com/v1/curated?per_page=20&page=$page'),
        headers: {
          'Authorization': 'zWHG08BBSzWRBQ0At1p3n2Eg3PEN5PId4n3kOxGHiVwfWFDrBrt4UZ85',
        },
      );
      Map result = jsonDecode(response.body);
      setState(() {
        images = result['photos'];
        isLoading = false;
        hasMore = result['photos'].isNotEmpty;
      });
    } catch (error) {
      setState(() => isLoading = false);
    }
  }

  loadmore() async {
    if (isLoading || !hasMore) return;

    setState(() => isLoading = true);

    try {
      final response = await http.get(
        Uri.parse('https://api.pexels.com/v1/curated?per_page=20&page=${page + 1}'),
        headers: {
          'Authorization': 'zWHG08BBSzWRBQ0At1p3n2Eg3PEN5PId4n3kOxGHiVwfWFDrBrt4UZ85',
        },
      );

      Map result = jsonDecode(response.body);
      setState(() {
        page++;
        images.addAll(result['photos']);
        isLoading = false;
        hasMore = result['photos'].isNotEmpty;
      });
    } catch (error) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      extendBodyBehindAppBar: true,
      appBar: _showAppBar ? AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text('Wallpapers',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 28,
              shadows: [
              Shadow(
              blurRadius: 10,
              color: Colors.black54,
              offset: Offset(1, 1),
              )
              ],
            )),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.7),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ) : null,
      body: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.only(top: kToolbarHeight + 20),
            sliver: images.isEmpty && isLoading
                ? const SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                  strokeWidth: 3,
                ),
              ),
            )
                : SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 0.7,
              ),
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FullscreenPage(
                                imageurl: images[index]['src']['large2x'],
                              ),
                            ),
                          );
                        },
                        child: Hero(
                          tag: images[index]['src']['large2x'],
                          child: Stack(
                            children: [
                              Image.network(
                                images[index]['src']['medium'],
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, progress) {
                                  if (progress == null) return child;
                                  return AspectRatio(
                                    aspectRatio: images[index]['width'] /
                                        images[index]['height'],
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        value: progress.expectedTotalBytes !=
                                            null
                                            ? progress.cumulativeBytesLoaded /
                                            progress.expectedTotalBytes!
                                            : null,
                                        color: Colors.black.withOpacity(0.5),
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      colors: [
                                        Colors.black.withOpacity(0.8),
                                        Colors.transparent,
                                      ],
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          images[index]['photographer'],
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const Icon(
                                        Icons.favorite_border,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
                childCount: images.length,
              ),
            ),
          ),
          if (isLoading && images.isNotEmpty)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          if (!hasMore && images.isNotEmpty)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(bottom: 24),
                child: Center(
                  child: Text(
                    'No more wallpapers',
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        },
        backgroundColor: Colors.black.withOpacity(0.8),
        child: const Icon(Icons.arrow_upward, color: Colors.white),
        elevation: 2,
      ),
    );
  }
}