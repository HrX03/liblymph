import 'dart:convert';
import 'dart:io';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:glob/glob.dart';
import 'package:libleaf/src/app/preferences.dart';
import 'package:recase/recase.dart';
import 'package:source_gen/source_gen.dart' hide LibraryBuilder;

class LocalPreferencesGenerator
    extends GeneratorForAnnotation<BuildLocalPreferences> {
  const LocalPreferencesGenerator();

  static const String generatedMixinName = "_\$LocalPreferencesGenerated";

  static const TypeChecker _baseTypeChecker =
      TypeChecker.fromRuntime(LocalPreferences);

  /* @override
  Future<String> generate(LibraryReader reader, BuildStep buildStep) async {
    final Stream<AssetId> assetStream =
        buildStep.findAssets(Glob("data/preferences.json"));
    final List<AssetId> assets = await assetStream.toList();

    if (assets.length > 1) {
      log.severe("Only a single preferences.json file is allowed");
      return '';
    }

    final DartEmitter emitter = DartEmitter(useNullSafetySyntax: true);
    final List<Map<String, dynamic>> json;

    try {
      final dynamic parsedJson = jsonDecode(
        await buildStep.readAsString(assets.single),
      );
      json = (parsedJson as List<dynamic>).cast<Map<String, dynamic>>();
    } catch (e) {
      log.severe("The referenced file is not valid json");
      return '';
    }

    final LibraryBuilder generatedLibrary = LibraryBuilder();
    final MixinBuilder generatedMixin = MixinBuilder();
    generatedMixin.name = generatedMixinName;
    generatedMixin.on = refer('LocalPreferences');

    for (final Map<String, dynamic> pref in json) {
      final _JsonLocalPreference preference =
          _JsonLocalPreference.fromJson(pref);

      final Reference getterType;
      final Reference setterType;
      final String getterCode;
      final String setterCode;

      final String isNullable = preference.defaultValue == null ? "?" : "";

      if (preference.type == _JsonLocalPreferenceType.enumerated) {
        final String enumName = preference.name.pascalCase;
        final EnumBuilder generatedEnum = EnumBuilder();
        generatedEnum.name = enumName;
        generatedEnum.values.addAll(
          preference.enumValues!.values.map(
            (e) => EnumValue((v) => v..name = e),
          ),
        );

        generatedLibrary.body.add(generatedEnum.build());

        getterType = refer(enumName + isNullable);
        setterType = refer('$enumName?');
        getterCode = _buildEnumGetter(enumName, preference);
        setterCode = _buildEnumSetter(enumName, preference);
      } else {
        getterType = refer(preference.type.nativeType + isNullable);
        setterType = refer('${preference.type.nativeType}?');
        getterCode = _buildSimpleGetter(preference);
        setterCode = _buildSimpleSetter(preference);
      }

      final MethodBuilder getter = MethodBuilder();
      getter.type = MethodType.getter;
      getter.name = preference.name.camelCase;
      getter.returns = getterType;
      getter.body = Code(getterCode);

      final MethodBuilder setter = MethodBuilder();
      setter.type = MethodType.setter;
      setter.name = preference.name.camelCase;
      setter.requiredParameters.add(
        Parameter(
          (p) => p
            ..type = setterType
            ..name = 'value',
        ),
      );
      setter.body = Code(setterCode);

      generatedMixin.methods.add(getter.build());
      generatedMixin.methods.add(setter.build());
    }

    generatedLibrary.body.add(generatedMixin.build());

    return generatedLibrary.build().accept(emitter).toString();
  } */

  @override
  Future<String> generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) async {
    buildStep.findAssets(Glob("data/preferences.json"));
    if (element.kind != ElementKind.CLASS) {
      log.severe(
        "The annotation 'BuildLocalPreferences' can only be applied to classes",
      );
      return '';
    }

    final ClassElement classElement = element as ClassElement;

    if (!classElement.allSupertypes.any(_baseTypeChecker.isExactlyType)) {
      log.severe(
        "The annotated class must extend or implement 'LocalPreferences'",
      );
      return '';
    }

    final DartEmitter emitter = DartEmitter(useNullSafetySyntax: true);
    final String jsonPath = annotation.read('preferenceJsonPath').stringValue;
    final File jsonFile = File(jsonPath);

    if (!await jsonFile.exists()) {
      log.severe("The reference file ${jsonFile.absolute} does not exist");
      return '';
    }

    final List<Map<String, dynamic>> json;

    try {
      final dynamic parsedJson = jsonDecode(await jsonFile.readAsString());
      json = (parsedJson as List<dynamic>).cast<Map<String, dynamic>>();
    } catch (e) {
      log.severe("The referenced file is not valid json");
      return '';
    }

    final LibraryBuilder generatedLibrary = LibraryBuilder();
    final MixinBuilder generatedMixin = MixinBuilder();
    generatedMixin.name = generatedMixinName;
    generatedMixin.on = refer('LocalPreferences');

    for (final Map<String, dynamic> pref in json) {
      final _JsonLocalPreference preference =
          _JsonLocalPreference.fromJson(pref);

      final Reference getterType;
      final Reference setterType;
      final String getterCode;
      final String setterCode;

      final String isNullable = preference.defaultValue == null ? "?" : "";

      if (preference.type == _JsonLocalPreferenceType.enumerated) {
        final String enumName = preference.name.pascalCase;
        final EnumBuilder generatedEnum = EnumBuilder();
        generatedEnum.name = enumName;
        generatedEnum.values.addAll(
          preference.enumValues!.values.map(
            (e) => EnumValue((v) => v..name = e),
          ),
        );

        generatedLibrary.body.add(generatedEnum.build());

        getterType = refer(enumName + isNullable);
        setterType = refer('$enumName?');
        getterCode = _buildEnumGetter(enumName, preference);
        setterCode = _buildEnumSetter(enumName, preference);
      } else {
        getterType = refer(preference.type.nativeType + isNullable);
        setterType = refer('${preference.type.nativeType}?');
        getterCode = _buildSimpleGetter(preference);
        setterCode = _buildSimpleSetter(preference);
      }

      final MethodBuilder getter = MethodBuilder();
      getter.type = MethodType.getter;
      getter.name = preference.name.camelCase;
      getter.returns = getterType;
      getter.body = Code(getterCode);

      final MethodBuilder setter = MethodBuilder();
      setter.type = MethodType.setter;
      setter.name = preference.name.camelCase;
      setter.requiredParameters.add(
        Parameter(
          (p) => p
            ..type = setterType
            ..name = 'value',
        ),
      );
      setter.body = Code(setterCode);

      generatedMixin.methods.add(getter.build());
      generatedMixin.methods.add(setter.build());
    }

    generatedLibrary.body.add(generatedMixin.build());

    return generatedLibrary.build().accept(emitter).toString();
  }
}

String _buildSimpleGetter(_JsonLocalPreference preference) {
  final StringBuffer buffer = StringBuffer('return ');
  buffer.write(
    'backend.${preference.type.backendGetMethod}("${preference.name}")',
  );

  if (preference.defaultValue != null) {
    buffer.write(" ?? ${preference.defaultValue}");
  }

  buffer.write(";");

  return buffer.toString();
}

String _buildSimpleSetter(_JsonLocalPreference preference) {
  return 'backend.${preference.type.backendSetMethod}("${preference.name}", value);';
}

String _buildEnumGetter(String enumName, _JsonLocalPreference preference) {
  final StringBuffer buffer = StringBuffer();
  buffer.writeln(
    'int? value = backend.${preference.type.backendGetMethod}("${preference.name}");',
  );

  buffer.writeln('switch(value) {');
  preference.enumValues!.forEach((key, value) {
    buffer.writeln('case $key:');
    buffer.writeln('return $enumName.$value;');
  });
  buffer.writeln('}');
  buffer.writeln();

  if (preference.defaultValue != null) {
    buffer.writeln('return $enumName.${preference.defaultValue};');
  } else {
    buffer.writeln('return null;');
  }

  return buffer.toString();
}

String _buildEnumSetter(String enumName, _JsonLocalPreference preference) {
  final StringBuffer buffer = StringBuffer();
  buffer.writeln('if(value == null) {');
  buffer.writeln(
    'backend.${preference.type.backendSetMethod}("${preference.name}", null);',
  );
  buffer.writeln("return;");
  buffer.writeln("}");
  buffer.writeln();
  buffer.writeln('final int resolvedValue;');

  buffer.writeln();
  buffer.writeln('switch(value) {');
  preference.enumValues!.forEach((key, value) {
    buffer.writeln('case $enumName.$value:');
    buffer.writeln('resolvedValue = $key;');
    buffer.writeln('break;');
  });
  buffer.writeln('}');
  buffer.writeln();

  buffer.writeln(
    'backend.${preference.type.backendSetMethod}("${preference.name}", resolvedValue);',
  );

  return buffer.toString();
}

class _JsonLocalPreference<T> {
  final String name;
  final T? defaultValue;
  final _JsonLocalPreferenceType type;
  final Map<String, String>? enumValues;

  const _JsonLocalPreference({
    required this.name,
    required this.defaultValue,
    required this.type,
    this.enumValues,
  }) : assert(
          enumValues == null || type == _JsonLocalPreferenceType.enumerated,
        );

  static _JsonLocalPreference fromJson(Map<String, dynamic> json) {
    final String name = json.getRequired<String>('name');
    final String stringType = json.getRequired<String>('type');
    final _JsonLocalPreferenceType type;

    switch (stringType) {
      case 'int':
        type = _JsonLocalPreferenceType.int;
        final int? defaultValue = json.getOptional<int>(
          'defaultValue',
          onTypeMismatch: _typeMismatchHandler<int>,
        );
        return _JsonLocalPreference<int>(
          name: name,
          defaultValue: defaultValue,
          type: type,
        );
      case 'double':
        type = _JsonLocalPreferenceType.double;
        final double? defaultValue = json.getOptional<double>(
          'defaultValue',
          onTypeMismatch: _typeMismatchHandler<double>,
        );
        return _JsonLocalPreference<double>(
          name: name,
          defaultValue: defaultValue,
          type: type,
        );
      case 'bool':
        type = _JsonLocalPreferenceType.bool;
        final bool? defaultValue = json.getOptional<bool>(
          'defaultValue',
          onTypeMismatch: _typeMismatchHandler<bool>,
        );
        return _JsonLocalPreference<bool>(
          name: name,
          defaultValue: defaultValue,
          type: type,
        );
      case 'string':
        type = _JsonLocalPreferenceType.string;
        final String? defaultValue = json.getOptional<String>(
          'defaultValue',
          onTypeMismatch: _typeMismatchHandler<String>,
        );
        return _JsonLocalPreference<String>(
          name: name,
          defaultValue: defaultValue,
          type: type,
        );
      case 'stringList':
        type = _JsonLocalPreferenceType.stringList;
        final List<String>? defaultValue = json.getOptionalList<String>(
          'defaultValue',
          onTypeMismatch: _typeMismatchHandler<List<String>>,
        );
        return _JsonLocalPreference<List<String>>(
          name: name,
          defaultValue: defaultValue,
          type: type,
        );
      case 'enumerated':
        type = _JsonLocalPreferenceType.enumerated;
        final Map<String, String> values = json.getRequiredMap<String, String>(
          'values',
          onTypeMismatch: _typeMismatchHandler<Map<String, String>>,
        );
        final String? defaultValue = json.getOptional<String>(
          'defaultValue',
          onTypeMismatch: _typeMismatchHandler<String>,
        );

        return _JsonLocalPreference<String>(
          name: name,
          defaultValue: defaultValue,
          type: type,
          enumValues: values,
        );
      default:
        throw BadValueException(
          'type',
          stringType,
          _JsonLocalPreferenceType.values.map((e) => e.name).toList(),
        );
    }
  }

  static Never _typeMismatchHandler<T>(dynamic value) {
    throw BadTypeException<T>('defaultValue', value);
  }
}

enum _JsonLocalPreferenceType {
  int('int', 'getInt', 'setInt'),
  double('double', 'getDouble', 'setDouble'),
  bool('bool', 'getBool', 'setBool'),
  string('String', 'getString', 'setString'),
  stringList('List<String>', 'getStringList', 'setStringList'),
  enumerated('Enum', 'getInt', 'setInt');

  final String nativeType;
  final String backendGetMethod;
  final String backendSetMethod;

  const _JsonLocalPreferenceType(
    this.nativeType,
    this.backendGetMethod,
    this.backendSetMethod,
  );
}

class MissingRequiredEntryException implements Exception {
  final String entryName;

  const MissingRequiredEntryException(this.entryName);

  @override
  String toString() {
    return 'The source data is missing the required parameter $entryName.';
  }
}

class BadValueException<T> implements Exception {
  final String parameterName;
  final T receivedValue;
  final List<T> validValues;

  const BadValueException(
    this.parameterName,
    this.receivedValue,
    this.validValues,
  );

  @override
  String toString() {
    return 'The value "$receivedValue" for $parameterName is not contained in the range of accepted values: ${validValues.join(", ")}.';
  }
}

class BadTypeException<T> implements Exception {
  final String parameterName;
  final dynamic receivedValue;

  const BadTypeException(
    this.parameterName,
    this.receivedValue,
  );

  @override
  String toString() {
    return 'The value "$receivedValue" for $parameterName is not of the expected type $T.';
  }
}

typedef _OnTypeMismatch = Never Function(dynamic value)?;

extension on Map<String, dynamic> {
  static Never _defaultTypeMismatch(dynamic value) {
    throw TypeError();
  }

  T getRequired<T>(
    String key, {
    _OnTypeMismatch? onTypeMismatch,
  }) {
    onTypeMismatch ??= _defaultTypeMismatch;

    final dynamic value = this[key];

    if (value != null) {
      if (value is! T) onTypeMismatch(value);

      return value;
    }

    throw MissingRequiredEntryException(key);
  }

  Map<K, V> getRequiredMap<K, V>(
    String key, {
    _OnTypeMismatch? onTypeMismatch,
  }) {
    return getRequired<Map<String, dynamic>>(
      key,
      onTypeMismatch: onTypeMismatch,
    ).cast<K, V>();
  }

  T? getOptional<T>(String key, {_OnTypeMismatch? onTypeMismatch}) {
    onTypeMismatch ??= _defaultTypeMismatch;

    final dynamic value = this[key];

    if (value == null) return null;
    if (value is! T) onTypeMismatch(value);

    return value;
  }

  List<T>? getOptionalList<T>(
    String key, {
    _OnTypeMismatch? onTypeMismatch,
  }) {
    return getOptional<List<dynamic>>(
      key,
      onTypeMismatch: onTypeMismatch,
    )?.cast<T>();
  }
}

class BuildLocalPreferences {
  final String preferenceJsonPath;

  const BuildLocalPreferences(this.preferenceJsonPath);
}
