import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.dart';

import '../providers/products.dart';

class _EditedProduct {
  String? id;
  String title;
  double price;
  String imageUrl;
  String description;
  bool isFavorite = false;

  _EditedProduct({
    this.id,
    required this.title,
    required this.price,
    required this.imageUrl,
    required this.description,
  });
}

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  const EditProductScreen({Key? key}) : super(key: key);

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  final _editedProduct = _EditedProduct(
    title: '',
    price: 0,
    imageUrl: '',
    description: '',
  );
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      var arguments = ModalRoute.of(context)!.settings.arguments;
      if (arguments != null) {
        final productId = arguments as String;
        final existingProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _editedProduct.id = existingProduct.id;
        _editedProduct.title = existingProduct.title;
        _editedProduct.price = existingProduct.price;
        _editedProduct.description = existingProduct.description;
        _editedProduct.imageUrl = existingProduct.imageUrl;
        _editedProduct.isFavorite = existingProduct.isFavorite;

        _initValues = {
          'title': existingProduct.title,
          'description': existingProduct.description,
          'price': existingProduct.price.toString(),
          'imageUrl': '',
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _saveForm() {
    if (!_form.currentState!.validate()) {
      return;
    }
    _form.currentState!.save();

    setState(() {
      _isLoading = true;
    });

    var product = Product(
      id: '',
      title: _editedProduct.title,
      description: _editedProduct.description,
      price: _editedProduct.price,
      imageUrl: _editedProduct.imageUrl,
      isFavorite: _editedProduct.isFavorite,
    );
    if (_editedProduct.id == null) {
      Provider.of<Products>(context, listen: false)
          .addProduct(product)
          .then((_) {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      });
    } else {
      Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id!, product);
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Edit Product'),
          actions: [
            IconButton(
              onPressed: _saveForm,
              icon: const Icon(Icons.save),
            )
          ],
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _form,
                  child: ListView(
                    children: [
                      TextFormField(
                        initialValue: _initValues['title'],
                        decoration: const InputDecoration(
                          labelText: 'Title',
                        ),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        onSaved: (value) {
                          _editedProduct.title = value ?? '';
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Value cannot be null';
                          }
                          if (value.isEmpty) {
                            return 'Please provide a value';
                          }
                          if (value.length < 3) {
                            return 'Title must be at least two characters long';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        initialValue: _initValues['price'],
                        decoration: const InputDecoration(labelText: 'Price'),
                        textInputAction: TextInputAction.next,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        inputFormatters: [
                          allowNumbersFormatter(),
                        ],
                        focusNode: _priceFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode);
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a price';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          if (double.parse(value) <= 0) {
                            return 'Please enter a number greater then zero';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedProduct.price = double.parse(value!);
                        },
                      ),
                      TextFormField(
                        initialValue: _initValues['description'],
                        decoration:
                            const InputDecoration(labelText: 'Description'),
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a description';
                          }
                          if (value.length < 10) {
                            return 'Should be at least 10 characters long';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedProduct.description = value ?? '';
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            margin: const EdgeInsets.only(top: 8, right: 10),
                            decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.grey),
                            ),
                            child: _imageUrlController.text.isEmpty ||
                                    !checkIsValidUrl(_imageUrlController.text)
                                ? const Text('Enter a URL')
                                : FittedBox(
                                    child: Image.network(
                                      _imageUrlController.text,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                          Expanded(
                              child: TextFormField(
                            decoration:
                                const InputDecoration(labelText: 'Image URL'),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageUrlController,
                            onEditingComplete: () {
                              setState(() {});
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter an image URL';
                              }
                              if (!checkIsValidUrl(value)) {
                                return 'Please enter a valid URL';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _editedProduct.imageUrl = value ?? '';
                            },
                          )),
                        ],
                      ),
                      Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(
                                  width: 100,
                                  child: ElevatedButton(
                                    onPressed: _saveForm,
                                    child: const Text('Save'),
                                  ),
                                ),
                              ]))
                    ],
                  ),
                ),
              ));
  }

  TextInputFormatter allowNumbersFormatter() {
    return FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}'));
  }

  bool checkIsValidUrl(String url) {
    return Uri.parse(url).isAbsolute;
  }
}
