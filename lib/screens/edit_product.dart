import 'package:flutter/material.dart';
import '../mixins/edit_product.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  const EditProductScreen({Key? key}) : super(key: key);

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen>
    with EditProductMixin {
  @override
  void didChangeDependencies() {
    onDidChangeDependencies();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    onDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Edit Product'),
          actions: [
            IconButton(
              onPressed: () => saveForm(context),
              icon: const Icon(Icons.save),
            )
          ],
        ),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: form,
                  child: ListView(
                    children: [
                      TextFormField(
                        initialValue: initValues['title'],
                        decoration: const InputDecoration(
                          labelText: 'Title',
                        ),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(priceFocusNode);
                        },
                        onSaved: (value) {
                          editedProduct.title = value ?? '';
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
                        initialValue: initValues['price'],
                        decoration: const InputDecoration(labelText: 'Price'),
                        textInputAction: TextInputAction.next,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        inputFormatters: [
                          allowNumbersFormatter(),
                        ],
                        focusNode: priceFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(descriptionFocusNode);
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
                          editedProduct.price = double.parse(value!);
                        },
                      ),
                      TextFormField(
                        initialValue: initValues['description'],
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
                          editedProduct.description = value ?? '';
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
                            child: imageUrlController.text.isEmpty ||
                                    !checkIsValidUrl(imageUrlController.text)
                                ? const Text('Enter a URL')
                                : FittedBox(
                                    child: Image.network(
                                      imageUrlController.text,
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
                            controller: imageUrlController,
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
                              editedProduct.imageUrl = value ?? '';
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
                                    onPressed: () => saveForm(context),
                                    child: const Text('Save'),
                                  ),
                                ),
                              ]))
                    ],
                  ),
                ),
              ));
  }
}
