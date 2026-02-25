import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex/core/utils/result.dart';

void main() {
  group('Result', () {
    group('Success', () {
      test('should hold data correctly', () {
        const result = Success<String>('test data');

        expect(result.data, equals('test data'));
      });

      test('when() should call success callback', () {
        const result = Success<int>(42);

        final value = result.when(
          success: (data) => 'success: $data',
          failure: (error) => 'failure: ${error.message}',
        );

        expect(value, equals('success: 42'));
      });

      test('isSuccess should return true', () {
        const result = Success<int>(42);
        expect(result.isSuccess, isTrue);
        expect(result.isFailure, isFalse);
      });

      test('dataOrNull should return data', () {
        const result = Success<int>(42);
        expect(result.dataOrNull, equals(42));
      });

      test('map should transform data', () {
        const result = Success<int>(42);
        final mapped = result.map((data) => data.toString());
        expect(mapped.dataOrNull, equals('42'));
      });
    });

    group('Failure', () {
      test('should hold error correctly', () {
        const error = NetworkException('Network error');
        const result = Failure<String>(error);

        expect(result.error, equals(error));
        expect(result.error.message, equals('Network error'));
      });

      test('when() should call failure callback', () {
        const result =
            Failure<int>(ServerException('Server error', statusCode: 500));

        final value = result.when(
          success: (data) => 'success: $data',
          failure: (error) => 'failure: ${error.message}',
        );

        expect(value, equals('failure: Server error'));
      });

      test('isFailure should return true', () {
        const result = Failure<int>(NetworkException('Error'));
        expect(result.isFailure, isTrue);
        expect(result.isSuccess, isFalse);
      });

      test('dataOrNull should return null', () {
        const result = Failure<int>(NetworkException('Error'));
        expect(result.dataOrNull, isNull);
      });

      test('errorOrNull should return error', () {
        const error = NetworkException('Error');
        const result = Failure<int>(error);
        expect(result.errorOrNull, equals(error));
      });
    });
  });

  group('AppException', () {
    test('NetworkException should have correct message', () {
      const exception = NetworkException('No internet');
      expect(exception.message, equals('No internet'));
      expect(exception.toString(), contains('No internet'));
    });

    test('ServerException should have status code', () {
      const exception = ServerException('Not found', statusCode: 404);
      expect(exception.message, equals('Not found'));
      expect(exception.statusCode, equals(404));
    });

    test('CacheException should have correct message', () {
      const exception = CacheException('Cache miss');
      expect(exception.message, equals('Cache miss'));
    });

    test('UnknownException should have correct message', () {
      const exception = UnknownException('Something went wrong');
      expect(exception.message, equals('Something went wrong'));
    });

    test('NotFoundException should have correct message', () {
      const exception = NotFoundException('Resource not found');
      expect(exception.message, equals('Resource not found'));
    });

    test('ValidationException should have correct message', () {
      const exception = ValidationException('Invalid input');
      expect(exception.message, equals('Invalid input'));
    });
  });
}
