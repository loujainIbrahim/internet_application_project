

import 'package:internet_application/SingUp/data/register_model.dart';

abstract class SignInScreenStatesTeacher{}

class SignInInitialStateTeacher extends SignInScreenStatesTeacher{}
class SignInLoadingStateTeacher extends SignInScreenStatesTeacher{}
class SignInSuccessStateTeacher extends SignInScreenStatesTeacher
{
  registerModel RegisterModel;
  SignInSuccessStateTeacher(this.RegisterModel);

}
class SignInErrorStateTeacher extends SignInScreenStatesTeacher{
  String error;
  SignInErrorStateTeacher(this.error);
}
class SignInChangePasswordVisibilityStateTeacher extends SignInScreenStatesTeacher{}