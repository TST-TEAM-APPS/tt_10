import 'dart:convert';

import 'package:flagsmith/flagsmith.dart';

class Config {
  static const _apikey = 'dGjoUoJzrJBpYh9Kz7RMj4';

  static final instance = Config._();

  Config._();

  late final FlagsmithClient _flagsmithClient;

  late final String _link;
  late final bool _useMock;

  late final String _privacyLink;
  late final String _termsLink;

  Future<Config> init() async {
    _flagsmithClient = await FlagsmithClient.init(
      apiKey: _apikey,
      config: const FlagsmithConfig(
        caches: true,
      ),
    );
    await _flagsmithClient.getFeatureFlags(reload: true);

    final config = jsonDecode(
        await _flagsmithClient.getFeatureFlagValue(ConfigKey.config.name) ??
            '') as Map<String, dynamic>;

    _link = config[ConfigKey.link.name] as String;
    _useMock = config[ConfigKey.useMock.name] as bool;
    _privacyLink = config[ConfigKey.privacyLink.name] as String;
    _termsLink = config[ConfigKey.termsLink.name] as String;
    return this;
  }

  void closeClient() => _flagsmithClient.close();

  bool get usePrivacy => _useMock;

  String get link => _link;

  String get privacyLink => _privacyLink;
  String get termsLink => _termsLink;
}

enum ConfigKey { config, link, useMock, privacyLink, termsLink }
