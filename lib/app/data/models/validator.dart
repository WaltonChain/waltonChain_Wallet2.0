import 'package:flutter/material.dart';
import 'package:wtc_wallet_app/app/data/models/utils.dart';

class Validator {
  static String? name(String? value) {
    if (value == null || value.isEmpty) {
      return 'name is empty';
    } else if (value.length < 2) {
      return 'name is too short';
    } else if (value.length > 12) {
      return 'name is too long';
    } else {
      return null;
    }
  }

  static String? pass(String? value) {
    if (value == null || value.isEmpty) {
      return 'password is empty';
    } else if (value.length < 6) {
      return 'password is too short';
    } else if (value.length > 32) {
      return 'password is too long';
    } else {
      return null;
    }
  }

  static String? passConfirm(String? value, TextEditingController pass) {
    if (value == null || value.isEmpty) {
      return 'password is empty';
    } else if (value.length < 6) {
      return 'password is too short';
    } else if (value.length > 32) {
      return 'password is too long';
    } else if (value != pass.text) {
      return 'password is not same';
    } else {
      return null;
    }
  }

  static String? wordsOrPrivateKey(String? value) {
    if (value == null || value.isEmpty) {
      return 'words or private key is empty';
    } else if (value.contains(' ') && !Utils.validateWords(value)) {
      return 'words is not valid';
    } else if (value.length > 1024) {
      return 'words or private key is too long';
    } else {
      return null;
    }
  }

  static String? address(String? value) {
    if (value == null || value.isEmpty) {
      return 'address is empty';
    } else if (!value.startsWith('0x')) {
      return 'address should be start with 0x';
    } else if (value.length != 42) {
      return 'address should be 42 length';
    } else {
      return null;
    }
  }

  static String? amount(String? value, double max) {
    if (value == null || value.isEmpty) {
      return 'amount is empty';
    } else if (double.tryParse(value).runtimeType != double) {
      return 'amount should be number';
    } else if (double.parse(value) <= 0) {
      return 'amount should be greater than 0';
    } else if (double.parse(value) > max) {
      return 'amount should be less than $max';
    } else {
      return null;
    }
  }

  static String? toAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'amount is empty';
    } else if (double.tryParse(value).runtimeType != double) {
      return 'amount should be number';
    } else if (double.parse(value) <= 0) {
      return 'amount should be greater than 0';
    } else {
      return null;
    }
  }

  static String? stakeFactor(String? value) {
    if (value == null || value.isEmpty) {
      return 'factor is empty';
    } else if (double.tryParse(value).runtimeType != double) {
      return 'factor should be number';
    } else if (double.parse(value) <= 0) {
      return 'factor should be greater than 0';
    } else {
      return null;
    }
  }
}
