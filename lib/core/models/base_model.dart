import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';
import '../enums/viewstate.dart';

class BaseModel extends Model{
  ViewState _state;

  ViewState get state => _state;

  setState(ViewState state){
    _state = state;
    notifyListeners();
  }

}