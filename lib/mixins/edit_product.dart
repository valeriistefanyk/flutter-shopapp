import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../providers/products.dart';
import '../providers/product.dart';

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

mixin EditProductMixin<T extends StatefulWidget> on State<T> {
  final priceFocusNode = FocusNode();
  final descriptionFocusNode = FocusNode();
  final imageUrlController = TextEditingController();
  final form = GlobalKey<FormState>();
  final editedProduct = _EditedProduct(
    title: '',
    price: 0,
    imageUrl: '',
    description: '',
  );
  var initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };
  var isInit = true;
  var isLoading = false;

  void onDidChangeDependencies() {
    if (isInit) {
      var arguments = ModalRoute.of(context)!.settings.arguments;
      if (arguments != null) {
        final productId = arguments as String;
        final existingProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        editedProduct.id = existingProduct.id;
        editedProduct.title = existingProduct.title;
        editedProduct.price = existingProduct.price;
        editedProduct.description = existingProduct.description;
        editedProduct.imageUrl = existingProduct.imageUrl;
        editedProduct.isFavorite = existingProduct.isFavorite;

        initValues = {
          'title': existingProduct.title,
          'description': existingProduct.description,
          'price': existingProduct.price.toString(),
          'imageUrl': '',
        };
        imageUrlController.text = editedProduct.imageUrl;
      }
    }
    isInit = false;
  }

  void onDispose() {
    priceFocusNode.dispose();
    descriptionFocusNode.dispose();
    imageUrlController.dispose();
  }

  Future<void> saveForm() async {
    if (!form.currentState!.validate()) {
      return;
    }
    form.currentState!.save();

    setState(() {
      isLoading = true;
    });

    var product = Product(
      id: '',
      title: editedProduct.title,
      description: editedProduct.description,
      price: editedProduct.price,
      imageUrl: editedProduct.imageUrl,
      isFavorite: editedProduct.isFavorite,
    );
    if (editedProduct.id == null) {
      try {
        await Provider.of<Products>(context, listen: false).addProduct(product);
      } catch (error) {
        await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: const Text('An error occurred!'),
                  content: const Text('Something went wrong!'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                        },
                        child: const Text('Ok')),
                  ],
                ));
      }
    } else {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(editedProduct.id!, product);
    }
    setState(() {
      isLoading = false;
    });
    Navigator.of(context).pop();
  }

  TextInputFormatter allowNumbersFormatter() {
    return FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}'));
  }

  bool checkIsValidUrl(String url) {
    return Uri.parse(url).isAbsolute;
  }
}
