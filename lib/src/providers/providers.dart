import 'package:libleaf/database.dart';
import 'package:libleaf/providers.dart';

abstract class Providers {
  //final Map<String, dynamic> _providers = {};

  static Providers? _instance;
  static Providers get instance {
    return _instance!;
  }

  static bool get isInstanced => _instance != null;

  static void provideInstance(Providers instance) {
    if (_instance != null) {
      throw const ProvidersAlreadyInstancedException();
    }

    //instance._locked = true;
    _instance = instance;
  }

  late final Directories directories;
  late final LocalPreferences localPreferences;
  late final AppDatabase database;

  /* bool _locked = false;

  void setProvider<T>(String name, T provider) {
    if (_locked) {
      throw const ProvidersInstanceLockedException();
    }

    _providers[name] = provider;
  }

  void removeProvider(String name) {
    if (_locked) {
      throw const ProvidersInstanceLockedException();
    }

    _providers.remove(name);
  }

  T getProvider<T>(String name) {
    final Object? provider = _providers[name];

    if (provider == null) {
      throw MissingProviderException(name);
    }

    if (provider is! T) {
      throw WrongProviderTypeException<T>(name, provider.runtimeType);
    }

    return provider as T;
  }

  bool hasProvider(String name) => _providers[name] != null;
  bool isProviderOfType<T>(String name) => _providers[name] is T; */
}

/* class MissingProviderException implements Exception {
  final String name;

  const MissingProviderException(this.name);

  @override
  String toString() {
    return "The requested provider '$name' was not found";
  }
}

class WrongProviderTypeException<T> implements Exception {
  final String name;
  final Type actualType;

  const WrongProviderTypeException(this.name, this.actualType);

  @override
  String toString() {
    return "The provider '$name' has type $actualType while type $T was expected";
  }
} */

class ProvidersInstanceLockedException implements Exception {
  const ProvidersInstanceLockedException();

  @override
  String toString() {
    return "The current instance of Providers has been locked and can't be modified. This usually happens when the instance is passed to 'provideInstance'";
  }
}

class ProvidersNotInstancedException implements Exception {
  const ProvidersNotInstancedException();

  @override
  String toString() {
    return "The instance for Providers hasn't been provided yet, call 'provideInstance' before trying to obtain it";
  }
}

class ProvidersAlreadyInstancedException implements Exception {
  const ProvidersAlreadyInstancedException();

  @override
  String toString() {
    return 'The instance for Providers has already been provided and reassigning it is not allowed';
  }
}
