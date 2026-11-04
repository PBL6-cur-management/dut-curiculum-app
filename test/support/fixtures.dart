import 'dart:convert';
import 'dart:io';

Object? fixture(String name) =>
    jsonDecode(File('test/fixtures/$name.json').readAsStringSync());

Map<String, dynamic> objectFixture(String name) =>
    fixture(name) as Map<String, dynamic>;
