import 'package:habo/repositories/habo_local_repo.dart';
import 'package:habo/repositories/habo_remote_repo.dart';
import 'package:habo/repositories/habo_repository.dart';
import 'package:habo/repositories/user_repository.dart';

class DependencyInjector {
  static HaboLocalRepository? _haboLocalRepository;
  static HaboRemoteRepository? _haboRemoteRepository;
  static HaboRepository? _haboRepository;
  static UserRepository? _userReposirory;

  static Future<HaboLocalRepository> getHaboLocalRepository() async {
    _haboLocalRepository ??= await HaboLocalRepository.create();
    return _haboLocalRepository!;
  }

  static Future<HaboRemoteRepository> getHaboRemoteRepository() async {
    _haboRemoteRepository ??=
        HaboRemoteRepository(userRepository: await getUserRepository());
    return _haboRemoteRepository!;
  }

  static Future<HaboRepository> getHaboRepository() async {
    _haboRepository ??= HaboRepository(
        localRepo: await getHaboLocalRepository(),
        remoteRepo: await getHaboRemoteRepository());

    return _haboRepository!;
  }

  static Future<UserRepository> getUserRepository() async {
    _userReposirory ??= UserRepository();
    return _userReposirory!;
  }
}
