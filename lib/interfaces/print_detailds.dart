import 'package:flutter/material.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:karum_manger/models/color.dart';
import 'package:karum_manger/models/print_postion.dart';
import 'package:karum_manger/models/print_product.dart';
import 'package:karum_manger/models/size.dart';

class FixedPrintCustomizer extends StatefulWidget {
  final PrintProduct product;
  const FixedPrintCustomizer({Key? key, required this.product}) : super(key: key);

  @override
  State<FixedPrintCustomizer> createState() => _FixedPrintCustomizerState();
}

class _FixedPrintCustomizerState extends State<FixedPrintCustomizer> {
  final NumberFormat _priceFormatter = NumberFormat('#,##0', 'en_US');

  late final List<PrintPosition> _positions;
  late PrintPosition _selectedPosition;
  String? _selectedSizeOption;
  ProductSize? _selectedSize;
  ProductColor? _selectedColor;
  int _quantity = 1;
  late Image _uploadedImage;
  @override
  void initState() {
    super.initState();
    _positions = widget.product.positions;
    _selectedPosition = _positions.first;
    _selectedSize=widget.product.sizes.first;
    _selectedColor=_selectedSize!.colors.first;
    _uploadedImage =Image.network(widget.product.pictureUrl??"https://picsum.photos/600/400?random=1");
    if (widget.product.incart && _positions.first.availableSizes.isNotEmpty) {
      _selectedSizeOption = _positions.first.availableSizes.first;
    }
  }

  
  List<ProductSize> _getValidSizes() {
    return widget.product.sizes
        .where((size) => size.colors.any((color) => color.count > 0))
        .toList();
  }

  List<ProductColor> _getValidColorsForSize(ProductSize size) {
    return size.colors.where((color) => color.count > 0).toList();
  }

  @override
  Widget build(BuildContext context) {
    final bool isInCart = widget.product.incart;
    final validSizes = _getValidSizes();
    final validColors = _selectedSize != null ? _getValidColorsForSize(_selectedSize!) : <ProductColor>[];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F7F9),
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            widget.product.name,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          backgroundColor: const Color(0xFF535170),
          centerTitle: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 90),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. Preview Box
                  AspectRatio(
                    aspectRatio: 1.0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Positioned.fill(
                              child: Image.asset(
                                _selectedPosition.imageUrl,
                                fit: BoxFit.contain,
                              ),
                            ),
                            Align(
                              alignment: _selectedPosition.printAlignment,
                              child: Container(
                                width: _selectedPosition.printAreaSize.width,
                                height: _selectedPosition.printAreaSize.height,
                                
                                child:ClipRRect(
                                        borderRadius: BorderRadius.circular(6),
                                        child: _uploadedImage,
                                      )
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'الموضع:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 110,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _positions.length,
                      itemBuilder: (context, index) {
                        final pos = _positions[index];
                        final isSelected = pos.id == _selectedPosition.id;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedPosition = pos;
                              if (!isInCart) {
                                _selectedSizeOption = null;
                              }
                            });
                          },
                          child: Container(
                            width: 90,
                            margin: const EdgeInsets.only(left: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected ? const Color(0xFF535170) : Colors.grey[300]!,
                                width: isSelected ? 2.5 : 1,
                              ),
                            ),
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.asset(pos.imageUrl, fit: BoxFit.cover),
                                  ),
                                ),
                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.black.withOpacity(isSelected ? 0.2 : 0.4),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 6,
                                  right: 6,
                                  child: Icon(
                                    Icons.check_circle,
                                    color: isSelected ? const Color(0xFF535170) : Colors.transparent,
                                    size: 18,
                                  ),
                                ),
                                Positioned(
                                  bottom: 8,
                                  left: 4,
                                  right: 4,
                                  child: Text(
                                    pos.titleAr,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'السعر:',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          '${_priceFormatter.format(widget.product.price)} د.ع',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF535170),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // 3. Product Sizes
                  if (validSizes.isNotEmpty) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'الحجم المختار:',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: validSizes.map((prodSize) {
                              final isSelected = _selectedSize == prodSize;
                              return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: isSelected ? const Color(0xFF535170) : Colors.grey[100],
                                    border: Border.all(
                                      color: isSelected ? const Color(0xFF535170) : Colors.grey[400]!,
                                    ),
                                  ),
                                  child: Text(
                                    prodSize.size,
                                    style: TextStyle(
                                      color: isSelected ? Colors.white : Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],

                  // Color Selection
                  if (_selectedSize != null && validColors.isNotEmpty) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'الألوان المتوفرة:',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: validColors.map((appColor) {
                              final isSelected = _selectedColor == appColor;
                              return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: appColor.color,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: isSelected ? Colors.black : Colors.grey[300]!,
                                      width: isSelected ? 2.5 : 1,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        '${appColor.count}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                      if (isSelected) ...[
                                        const SizedBox(width: 4),
                                        const Icon(Icons.check, color: Colors.white, size: 14),
                                      ],
                                    ],
                                  ),
                                );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],

                  // Print Size Option Selection
                  Text(
                    'اختر مقاس الطباعة — ${_selectedPosition.titleAr}:',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _selectedPosition.availableSizes.map((sizeOpt) {
                      final isSelected = sizeOpt == _selectedSizeOption;
                      return ChoiceChip(
                        label: Text(sizeOpt),
                        selected: isSelected,
                        selectedColor: const Color(0xFF535170),
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        onSelected: (selected) {
                          setState(() {
                            _selectedSizeOption = selected ? sizeOpt : null;
                          });
                        },
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 12),

                  // Quantity Controller
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'الكمية:',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: Row(
                            children: [
                             
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  '$_quantity',
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ),
                              
                            ],
                          ),
                        ),
                      ],
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