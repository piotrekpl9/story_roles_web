import 'package:flutter_test/flutter_test.dart';
import 'package:story_roles_web/data/models/json_api_parser.dart';

void main() {
  group('JsonApiParser.extractAttributes', () {
    test('standard JSON API: data.attributes', () {
      final json = {
        'data': {
          'attributes': {'id': 1, 'name': 'Alice'},
        },
      };
      final result = JsonApiParser.extractAttributes(json);
      expect(result, {'id': 1, 'name': 'Alice'});
    });

    test('nested entity key: data.user.attributes', () {
      final json = {
        'data': {
          'user': {
            'attributes': {'id': 42, 'email': 'a@b.com'},
          },
        },
      };
      final result = JsonApiParser.extractAttributes(json, entityKey: 'user');
      expect(result, {'id': 42, 'email': 'a@b.com'});
    });

    test('flat attributes wrapper: top-level attributes key', () {
      final json = {
        'attributes': {'id': 7, 'name': 'Flat'},
      };
      final result = JsonApiParser.extractAttributes(json);
      expect(result, {'id': 7, 'name': 'Flat'});
    });

    test('plain flat JSON fallback: no data, no attributes', () {
      final json = {'id': 3, 'email': 'x@y.com'};
      final result = JsonApiParser.extractAttributes(json);
      expect(result, {'id': 3, 'email': 'x@y.com'});
    });

    test('null data value falls through to flat JSON', () {
      final json = <String, dynamic>{'data': null, 'id': 5};
      final result = JsonApiParser.extractAttributes(json);
      expect(result, <String, dynamic>{'data': null, 'id': 5});
    });

    test('data present but null attributes falls back to data node', () {
      final json = {
        'data': {'id': 9, 'name': 'NoAttrs'},
      };
      final result = JsonApiParser.extractAttributes(json);
      expect(result, {'id': 9, 'name': 'NoAttrs'});
    });

    test('entityKey provided but missing in data node falls back to data node', () {
      final json = {
        'data': {'id': 11, 'email': 'z@z.com'},
      };
      final result = JsonApiParser.extractAttributes(json, entityKey: 'user');
      // entityKey 'user' not found → falls back to data node attributes
      // data node has no 'attributes' key → returns data node itself
      expect(result, {'id': 11, 'email': 'z@z.com'});
    });

    test('entityKey provided but missing, data has attributes, uses data.attributes', () {
      final json = {
        'data': {
          'attributes': {'id': 20, 'name': 'Fallthrough'},
        },
      };
      final result = JsonApiParser.extractAttributes(json, entityKey: 'missingKey');
      expect(result, {'id': 20, 'name': 'Fallthrough'});
    });
  });
}
