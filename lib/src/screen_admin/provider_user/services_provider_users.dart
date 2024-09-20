import 'package:flutter/material.dart';
import 'package:tejidos/src/datebase/methond.dart';
import 'package:tejidos/src/datebase/url.dart';
import 'package:tejidos/src/model/users.dart';

class ServicesProviderUsers with ChangeNotifier {
  List<Users> _userList = [];
  List<Users> _userListFilter = [];

  List<Users> get userList => _userList;

  List<Users> get userListFilter => _userListFilter;

  Future getUserAdmin() async {
    final res = await httpRequestDatabase(selectUsersAdmin, {'view': 'view'});
    _userList = usersFromJson(res.body);
    _userListFilter = [..._userList];
    // print(res.body);
    notifyListeners();
  }

  Future searchingFilter(String val) async {
    // print(val);
    if (val.isNotEmpty) {
      _userListFilter = List.from(_userList
          .where((x) =>
              x.fullName!.toUpperCase().contains(val.toUpperCase()) ||
              x.occupation!.toUpperCase().contains(val.toUpperCase()) ||
              x.code!.toUpperCase().contains(val.toUpperCase()))
          .toList());
      notifyListeners();
    } else {
      _userListFilter = [..._userList];
      notifyListeners();
    }
  }

  Future updateFrom(Users localUser) async {
    //full_name= '$full_name', occupation= '$occupation',turn='$turn', code= '$code'

    var data = {
      'id': localUser.id,
      'full_name': localUser.fullName,
      'occupation': localUser.occupation,
      'turn': localUser.turn,
      'code': localUser.code,
      'type': localUser.type,
    };
    // print(data);
    final res = await httpRequestDatabase(updateUsers, data);
    print(res.body);
    getUserAdmin();
  }

  Future deleteFrom(Users localUser) async {
    await httpRequestDatabase(deleteUsers, {'id': localUser.id});
    getUserAdmin();
  }

  Future addUser(data) async {
    await httpRequestDatabase(insertAddUsersNuevo, data);
    getUserAdmin();
  }
}
