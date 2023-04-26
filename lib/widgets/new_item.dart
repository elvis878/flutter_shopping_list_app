import 'package:flutter/material.dart';
import 'package:flutter_shopping_list_app/data/categories.dart';
import 'package:flutter_shopping_list_app/models/grocery_item.dart';

import '../models/category.dart';

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<NewItem> createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  final _formKey = GlobalKey<FormState>();
  var _itemName = '';
  var _itemQuantity = 1;
  var _itemCategory = categories.entries.first.value;

  void _saveItem() {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    Navigator.of(context).pop(
      GroceryItem(
        id: DateTime.now().toString(),
        name: _itemName,
        quantity: _itemQuantity,
        category: _itemCategory,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                initialValue: _itemName,
                maxLength: 50,
                decoration: const InputDecoration(
                  labelText: 'Item name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  } else if (value.trim().length < 3 ||
                      value.trim().length > 50) {
                    return 'Name must be between 3 and 50 characters';
                  }
                  return null;
                },
                onSaved: (value) {
                  _itemName = value!;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Quantity',
                      ),
                      initialValue: _itemQuantity.toString(),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            int.tryParse(value) == null ||
                            int.parse(value) <= 0) {
                          return 'Please enter a valid, positive quantity';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _itemQuantity = int.parse(value!);
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField(
                      value: _itemCategory,
                      items: <DropdownMenuItem>[
                        for (final category in categories.entries)
                          DropdownMenuItem(
                            value: category.value,
                            child: Row(
                              children: <Widget>[
                                Container(
                                  width: 16,
                                  height: 16,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: category.value.color,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Text(category.value.title),
                              ],
                            ),
                          ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _itemCategory = value as Category;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  TextButton(
                    onPressed: () {
                      _formKey.currentState!.reset();
                    },
                    child: const Text('Reset'),
                  ),
                  ElevatedButton.icon(
                    onPressed: _saveItem,
                    icon: const Icon(Icons.check_rounded),
                    label: const Text('Add item'),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
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
