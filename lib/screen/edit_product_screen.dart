import 'package:flutter/material.dart';
import 'package:shopapp/providers/product.dart';
import 'package:shopapp/providers/products_provider.dart';
import 'package:shopapp/screen/order_screen.dart';
import 'package:shopapp/screen/user_prudoct.dart';
import 'package:shopapp/widgets/app_drawer.dart';
import '../providers/product.dart';
import 'package:provider/provider.dart';

class EditProdcutScreen extends StatefulWidget {
  static final routeId = '/EditProdcutScreen';

  @override
  _EditProdcutScreenState createState() => _EditProdcutScreenState();
}

class _EditProdcutScreenState extends State<EditProdcutScreen> {
  final _priceFocusNode = FocusNode();
  final _decFocusNode = FocusNode();
  final _imagUrlController = TextEditingController();
  final _imagUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct =
      Product(id: null, title: "", desctiption: "", price: 0, imgeUrl: '');
  var _isinite = true;
  var _isLoading = false;

  var _initValuse = {
    'title': '',
    'prive': '0',
    'descrition': '',
    'imageUrl': ''
  };

  @override
  void initState() {
    _imagUrlFocusNode.addListener(imgUrlLisener);
    super.initState();
  }

  void imgUrlLisener() {
    if (!_imagUrlFocusNode.hasFocus) {
      return;
    }

    setState(() {});
  }

  @override
  void didChangeDependencies() {
    if (_isinite) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).fingById(productId);
        _initValuse = {
          'title': _editedProduct.title,
          'price': _editedProduct.price.toString(),
          'descrition': _editedProduct.desctiption,
          //  'imageUrl': _editedProduct.imgeUrl
          'imageUrl': "",
        };
        _imagUrlController.text = _editedProduct.imgeUrl;
      }
    }

    _isinite = false;

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imagUrlFocusNode.removeListener(imgUrlLisener);
    _priceFocusNode.dispose();
    _decFocusNode.dispose();
    _imagUrlController.dispose();
    _imagUrlFocusNode.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      print("bbbb");

      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedProduct.id != null) {
      print(_editedProduct.id);
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (e) {
        await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('An error Occurred'),
                  content: Text('Somethong went wrong'),
                  actions: [
                    FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Ok'))
                  ],
                ));
      } finally {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Eidt Product"),
        actions: [
          IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                _saveForm();
              })
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _initValuse['title'],
                      decoration: InputDecoration(labelText: 'Title ,'),
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      textInputAction: TextInputAction.next,
                      onSaved: (newValue) {
                        _editedProduct = Product(
                            isFaborite: _editedProduct.isFaborite,
                            id: _editedProduct.id,
                            title: newValue,
                            desctiption: _editedProduct.desctiption,
                            price: _editedProduct.price,
                            imgeUrl: _editedProduct.imgeUrl);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please provide avalue ,";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _initValuse['price'],
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Price',
                      ),
                      onSaved: (newValue) {
                        _editedProduct = Product(
                            isFaborite: _editedProduct.isFaborite,
                            id: _editedProduct.id,
                            title: _editedProduct.title,
                            desctiption: _editedProduct.desctiption,
                            price: double.parse(newValue),
                            imgeUrl: _editedProduct.imgeUrl);
                      },
                      focusNode: _priceFocusNode,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please provide aValue ,";
                        }
                        if (double.tryParse(value) == null) {
                          return "Please enter a valid number ,";
                        }
                        if (double.parse(value) <= 0) {
                          return "Please enter a  number  greater than zero,";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _initValuse['descrition'],
                      decoration: InputDecoration(
                        labelText: 'Desciption',
                      ),
                      focusNode: _decFocusNode,
                      maxLines: 3,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.multiline,
                      onSaved: (newValue) {
                        _editedProduct = Product(
                            isFaborite: _editedProduct.isFaborite,
                            id: _editedProduct.id,
                            title: _editedProduct.title,
                            desctiption: newValue,
                            price: _editedProduct.price,
                            imgeUrl: _editedProduct.imgeUrl);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please enter a  descrapton,";
                        }
                        if (value.length < 10) {
                          return "Should be at least 10 characters long.,";
                        }
                        return null;
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(top: 8, right: 10),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey),
                          ),
                          child: _imagUrlController.text.isEmpty
                              ? Text(
                                  "ENter URL",
                                )
                              : FittedBox(
                                  child: Image.network(
                                    _imagUrlController.text,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'Image URL'),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imagUrlController,
                            focusNode: _imagUrlFocusNode,
                            onFieldSubmitted: (_) => _saveForm(),
                            onSaved: (newValue) {
                              _editedProduct = Product(
                                  isFaborite: _editedProduct.isFaborite,
                                  id: _editedProduct.id,
                                  title: _editedProduct.title,
                                  desctiption: _editedProduct.desctiption,
                                  price: _editedProduct.price,
                                  imgeUrl: newValue);
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Please enter a   URL,";
                              }
                              if (!value.startsWith('http') ||
                                  !value.startsWith('https')) {
                                return "Please enter a valid 1 URL,";
                              }

                              if (!value.endsWith('.png') &&
                                  !value.endsWith('.jpg') &&
                                  !value.endsWith('.pneg')) {
                                return "Please enter a valid 2 URL,";
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
