import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:getx/app/constants/app_constants.dart';
import 'package:getx/app/di/service_locator.dart';
import 'package:getx/app/models/product.dart';
import 'package:getx/app/routes/app_routes.dart';
import 'package:getx/app/services/api_service.dart';
import 'package:getx/app/utils/price_formatter.dart';
import 'package:getx/app/views/widgets/app_network_image.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  static const _minimumQueryLength = 3;
  static const _debounceDuration = Duration(milliseconds: 350);

  final _textController = TextEditingController();
  final _apiService = getIt<ApiService>();
  Timer? _debounce;
  List<Product> _results = [];
  String _query = '';
  String? _errorMessage;
  bool _isLoading = false;
  int _requestId = 0;

  void _onQueryChanged(String value) {
    final query = value.trim();
    _query = query;
    _debounce?.cancel();
    final requestId = ++_requestId;

    if (query.length < _minimumQueryLength) {
      setState(() {
        _results = [];
        _errorMessage = null;
        _isLoading = true;
      });
      return;
    }

    setState(() {
      _results = [];
      _errorMessage = null;
      _isLoading = false;
    });
    _debounce = Timer(_debounceDuration, () => _search(query, requestId));
  }

  Future<void> _search(String query, int requestId) async {
    if (query.length < _minimumQueryLength) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final results = await _apiService.searchProducts(query);
      if (!mounted || requestId != _requestId) return;
      setState(() {
        _results = results;
      });
    } on Object catch (error) {
      if (!mounted || requestId != _requestId) return;
      debugPrint('Product search failed: $error');
      setState(() {
        _errorMessage = 'Search failed. Please try again.';
      });
    } finally {
      if (mounted && requestId == _requestId) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _submitSearch(String _) {
    _debounce?.cancel();
    if (_query.length >= _minimumQueryLength) {
      _search(_query, ++_requestId);
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        titleSpacing: 0,
        title: TextField(
          controller: _textController,
          autofocus: true,
          textInputAction: TextInputAction.search,
          onChanged: _onQueryChanged,
          onSubmitted: _submitSearch,
          decoration: InputDecoration(
            hintText: 'Search products',
            hintStyle: const TextStyle(color: AppConstants.textGrey),
            border: InputBorder.none,
            suffixIcon: _textController.text.isEmpty
                ? null
                : IconButton(
                    tooltip: 'Clear search',
                    onPressed: () {
                      _textController.clear();
                      _onQueryChanged('');
                    },
                    icon: const Icon(Icons.close),
                  ),
          ),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_query.length < _minimumQueryLength) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Enter at least 3 characters to search',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppConstants.textGrey, fontSize: 15),
          ),
        ),
      );
    }

    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppConstants.meeshoPink),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: AppConstants.textGrey),
              const SizedBox(height: 8),
              Text(_errorMessage!, textAlign: TextAlign.center),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => _search(_query, ++_requestId),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (_results.isEmpty) {
      return const Center(
        child: Text(
          'No products found',
          style: TextStyle(color: AppConstants.textGrey, fontSize: 15),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: _results.length,
      separatorBuilder: (context, index) =>
          const Divider(height: 1, indent: 96, endIndent: 16),
      itemBuilder: (context, index) =>
          _SearchResultTile(product: _results[index]),
    );
  }
}

class _SearchResultTile extends StatelessWidget {
  final Product product;

  const _SearchResultTile({required this.product});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.toNamed(AppRoutes.productDetails, arguments: product),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: AppNetworkImage(
                imageUrl: product.thumbnail,
                width: 68,
                height: 68,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.category,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppConstants.textGrey,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    PriceFormatter.format(product.price),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right, color: AppConstants.textGrey),
          ],
        ),
      ),
    );
  }
}
