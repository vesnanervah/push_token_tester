import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'push_message.dart';
import 'push_transport.dart';

/// A separate desktop workflow; the original FCM wizard remains available.
class PushWorkbenchPage extends StatefulWidget {
  final PushTransport transport;
  const PushWorkbenchPage({super.key, required this.transport});

  @override
  State<PushWorkbenchPage> createState() => _PushWorkbenchPageState();
}

class _PushWorkbenchPageState extends State<PushWorkbenchPage> {
  final _project = TextEditingController();
  final _credential = TextEditingController();
  final _device = TextEditingController();
  final _title = TextEditingController();
  final _body = TextEditingController();
  final _data = TextEditingController(text: '{}');
  final _ttl = TextEditingController(text: '3600');
  final _idKey = TextEditingController(text: 'message_id');
  final _expiryKey = TextEditingController(text: 'expires_at');
  final _credentialUndo = UndoHistoryController();
  final _deviceUndo = UndoHistoryController();
  PushProvider _provider = PushProvider.rustore;
  bool _dataOnly = true;
  bool _useId = false;
  bool _useExpiry = false;
  int _secretGeneration = 0;
  bool _busy = false;
  bool _attempted = false;
  String? _status;

  Iterable<TextEditingController> get _controllers => [
    _project,
    _credential,
    _device,
    _title,
    _body,
    _data,
    _ttl,
    _idKey,
    _expiryKey,
  ];

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.clear();
      controller.dispose();
    }
    _credentialUndo.dispose();
    _deviceUndo.dispose();
    super.dispose();
  }

  void _clear() {
    FocusScope.of(context).unfocus();
    for (final controller in _controllers) {
      controller.clear();
    }
    // Recreate secret fields to discard Flutter's internal undo history.
    _secretGeneration++;
    _data.text = '{}';
    _ttl.text = '3600';
    _idKey.text = 'message_id';
    _expiryKey.text = 'expires_at';
    setState(() {
      _attempted = false;
      _useId = false;
      _useExpiry = false;
      _status = null;
    });
  }

  int _ttlValue() {
    final ttl = int.tryParse(_ttl.text);
    if (ttl == null || ttl < 1 || ttl > PushMessage.maxTtlSeconds) {
      throw const PushValidationException(
        'TTL должен быть от 1 до 2419200 секунд.',
      );
    }
    return ttl;
  }

  void _prepareData({required bool newTest}) {
    final data = parsePushData(_data.text);
    final ttl = _ttlValue();
    final idKey = _idKey.text.trim();
    final expiryKey = _expiryKey.text.trim();
    if ((_useId && idKey.isEmpty) ||
        (_useExpiry && expiryKey.isEmpty) ||
        (_useId && _useExpiry && idKey == expiryKey)) {
      throw const PushValidationException(
        'Имена полей ID и срока должны быть непустыми и разными.',
      );
    }
    if (_useId && (newTest || !data.containsKey(idKey))) {
      data[idKey] = newMessageId();
    }
    if (_useExpiry && (newTest || !data.containsKey(expiryKey))) {
      data[expiryKey] =
          '${DateTime.now().millisecondsSinceEpoch ~/ 1000 + ttl}';
    }
    parsePushData(jsonEncode(data));
    _data.text = const JsonEncoder.withIndent('  ').convert(data);
  }

  void _newTest() {
    try {
      _prepareData(newTest: true);
      setState(() {
        _attempted = false;
        _status = 'Новый тест подготовлен. Запрос ещё не отправлен.';
      });
    } on PushValidationException catch (error) {
      setState(() => _status = error.message);
    }
  }

  Future<void> _send() async {
    if (_busy || kIsWeb) return;
    try {
      final configuration = _provider == PushProvider.rustore
          ? RuStoreConfiguration(_project.text.trim(), _credential.text.trim())
          : FcmConfiguration(_project.text.trim(), _credential.text.trim());
      configuration.validate();
      _prepareData(newTest: false);
      final message = PushMessage(
        deviceToken: _device.text.trim(),
        dataOnly: _dataOnly,
        title: _title.text,
        body: _body.text,
        data: parsePushData(_data.text),
        ttlSeconds: _ttlValue(),
        expiryKey: _useExpiry ? _expiryKey.text.trim() : null,
      );
      message.payload(DateTime.now());
      setState(() {
        _busy = true;
        _attempted = true;
        _status = 'Отправляем один запрос одному устройству…';
      });
      final result = await widget.transport.send(configuration, message);
      if (mounted) setState(() => _status = result.description);
    } on PushValidationException catch (error) {
      if (mounted) setState(() => _status = error.message);
    } catch (_) {
      if (mounted) {
        setState(
          () => _status =
              'Результат неизвестен. Повтор только вручную с тем же ID.',
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Widget _field(
    String key,
    String label,
    TextEditingController controller, {
    bool secret = false,
    bool payload = false,
    int lines = 1,
    UndoHistoryController? undoController,
  }) => Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: KeyedSubtree(
      key: ValueKey(secret ? _secretGeneration : 0),
      child: TextField(
        key: ValueKey(key),
        controller: controller,
        undoController: undoController,
        enabled: !_busy && !(payload && _attempted),
        obscureText: secret,
        autocorrect: false,
        enableSuggestions: false,
        enableIMEPersonalizedLearning: false,
        maxLines: lines,
        decoration: InputDecoration(labelText: label),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    // No credential fields are created in a browser build.
    if (kIsWeb) {
      return Scaffold(
        appBar: AppBar(title: const Text('Push workbench')),
        body: const Center(
          child: Text('Запустите desktop-версию: macOS или Linux.'),
        ),
      );
    }
    return PopScope(
      canPop: !_busy,
      child: Theme(
        data: ThemeData.light(useMaterial3: true),
        child: Scaffold(
          appBar: AppBar(title: const Text('Push workbench · FCM / RuStore')),
          body: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 850),
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  const Text(
                    'Ручная отправка одному устройству. Ключи хранятся только в памяти; '
                    '«Очистить всё» или закрытие экрана удаляет их из формы.',
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<PushProvider>(
                    key: const ValueKey('provider'),
                    initialValue: _provider,
                    decoration: const InputDecoration(labelText: 'Провайдер'),
                    items: const [
                      DropdownMenuItem(
                        value: PushProvider.rustore,
                        child: Text('RuStore'),
                      ),
                      DropdownMenuItem(
                        value: PushProvider.fcm,
                        child: Text('FCM'),
                      ),
                    ],
                    onChanged: _busy
                        ? null
                        : (value) {
                            if (value == null || value == _provider) return;
                            _clear();
                            setState(() => _provider = value);
                          },
                  ),
                  const SizedBox(height: 16),
                  _field('project', 'Project ID', _project),
                  _field(
                    'credential',
                    _provider == PushProvider.rustore
                        ? 'Сервисный Bearer-токен (без префикса Bearer)'
                        : 'Google service-account JSON',
                    _credential,
                    secret: true,
                    undoController: _credentialUndo,
                  ),
                  _field(
                    'device',
                    'Push-токен одного устройства',
                    _device,
                    secret: true,
                    undoController: _deviceUndo,
                  ),
                  SwitchListTile(
                    key: const ValueKey('data_only'),
                    title: const Text('Data-only (без notification)'),
                    value: _dataOnly,
                    onChanged: _busy || _attempted
                        ? null
                        : (v) => setState(() => _dataOnly = v),
                  ),
                  if (!_dataOnly) ...[
                    _field('title', 'Заголовок', _title, payload: true),
                    _field('body', 'Текст уведомления', _body, payload: true),
                  ],
                  _field(
                    'data',
                    'Data JSON — только строковые значения',
                    _data,
                    lines: 7,
                    payload: true,
                  ),
                  _field(
                    'ttl',
                    'Android TTL, секунды (1–2419200)',
                    _ttl,
                    payload: true,
                  ),
                  CheckboxListTile(
                    key: const ValueKey('use_id'),
                    title: const Text('UUID в data для проверки дедупликации'),
                    subtitle: const Text(
                      'Дедупликацию выполняет приложение, если поддерживает это поле.',
                    ),
                    value: _useId,
                    onChanged: _busy || _attempted
                        ? null
                        : (v) => setState(() => _useId = v!),
                  ),
                  if (_useId)
                    _field(
                      'id_key',
                      'Имя поля UUID в data',
                      _idKey,
                      payload: true,
                    ),
                  CheckboxListTile(
                    key: const ValueKey('use_expiry'),
                    title: const Text('Согласовать TTL с Unix seconds в data'),
                    subtitle: const Text(
                      'Отсутствующее поле заполняется текущим временем + TTL. '
                      'При повторе срок сохраняется, TTL уменьшается.',
                    ),
                    value: _useExpiry,
                    onChanged: _busy || _attempted
                        ? null
                        : (v) => setState(() => _useExpiry = v!),
                  ),
                  if (_useExpiry)
                    _field(
                      'expiry_key',
                      'Имя поля срока действия в data',
                      _expiryKey,
                      payload: true,
                    ),
                  const SizedBox(height: 12),
                  const Text(
                    'Ответ API не подтверждает доставку. Показ зависит от разрешений, '
                    'состояния приложения и его обработки payload. Автоповторов нет.',
                  ),
                  if (_attempted)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        'Payload зафиксирован для ручного повтора. «Новый тест» разрешает '
                        'редактирование и обновляет UUID/срок только для включённых выше полей.',
                      ),
                    ),
                  if (_status != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Text(_status!, key: const ValueKey('send_status')),
                    ),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      FilledButton(
                        key: const ValueKey('send'),
                        onPressed: _busy ? null : _send,
                        child: Text(
                          _busy
                              ? 'Отправляем…'
                              : _attempted
                              ? 'Повторить тот же payload'
                              : 'Отправить',
                        ),
                      ),
                      OutlinedButton(
                        key: const ValueKey('new_test'),
                        onPressed: _busy ? null : _newTest,
                        child: const Text('Новый тест'),
                      ),
                      OutlinedButton(
                        key: const ValueKey('clear'),
                        onPressed: _busy ? null : _clear,
                        child: const Text('Очистить всё'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
