/// Dummy data for development. Remove or replace when connecting to real API.
class DummyData {
  DummyData._();

  static const String loginEmail = 't@gmail.com';
  static const String loginPassword = 'test1234';

  static const Map<String, dynamic> dummyUserMap = <String, dynamic>{
    'id': '1',
    'email': loginEmail,
    'name': 'Mody',
    'username': 'mody',
    'birthDate': '1995-12-20',
    'gender': 'Male',
    'status': 'Active',
    'role': 'Google Driver',
    'token': 'dummy_token_xyz',
  };
}
