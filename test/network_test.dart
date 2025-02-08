import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network/interceptor/request_response_interceptor.dart';
import 'package:network/network.dart';
import 'package:network/helper/network_helper.dart';

class MockDio extends Mock implements Dio {}
class MockNetworkHelper extends Mock implements NetworkHelper {}
class MockResponse extends Mock implements Response {}
class MockRequestOptions extends Mock implements RequestOptions {}

void main() {
  late Network network;
  late MockDio mockDio;
  late MockNetworkHelper mockNetworkHelper;

  setUp(() {
    mockDio = MockDio();
    mockNetworkHelper = MockNetworkHelper();
    
    network = Network.createNetwork(
      baseUrl: 'https://api.example.com',
    );
    // Substituir o Dio real pelo mock
    network.client = mockDio;
    network.networkHelper = mockNetworkHelper;
  });

  group('Network Requests', () {
    test('GET request deve ser executado com sucesso', () async {
      // Arrange
      final mockResponse = MockResponse();
      when(() => mockResponse.statusCode).thenReturn(200);
      when(() => mockResponse.data).thenReturn({'message': 'success'});
      
      when(() => mockDio.get(
        any(),
        options: any(named: 'options'),
        queryParameters: any(named: 'queryParameters'),
      )).thenAnswer((_) async => mockResponse);

      // Act
      final response = await network.client.get(
        '/users',
        queryParameters: {'page': 1},
      );

      // Assert
      verify(() => mockDio.get(
        '/users',
        queryParameters: {'page': 1},
      )).called(1);
      
      expect(response.statusCode, equals(200));
      expect(response.data, equals({'message': 'success'}));
    });

    test('POST request deve ser executado com sucesso', () async {
      // Arrange
      final mockResponse = MockResponse();
      final requestData = {'name': 'Test User', 'email': 'test@example.com'};
      
      when(() => mockResponse.statusCode).thenReturn(201);
      when(() => mockResponse.data).thenReturn({'id': 1, ...requestData});
      
      when(() => mockDio.post(
        any(),
        data: any(named: 'data'),
        options: any(named: 'options'),
      )).thenAnswer((_) async => mockResponse);

      // Act
      final response = await network.client.post(
        '/users',
        data: requestData,
      );

      // Assert
      verify(() => mockDio.post(
        '/users',
        data: requestData,
      )).called(1);
      
      expect(response.statusCode, equals(201));
      expect(response.data['name'], equals('Test User'));
      expect(response.data['email'], equals('test@example.com'));
    });

    test('GET request deve lidar com erro de conexão', () async {
      // Arrange
      when(() => mockDio.get(
        any(),
        options: any(named: 'options'),
      )).thenThrow(DioException(
        requestOptions: MockRequestOptions(),
        error: 'Connection failed',
        type: DioExceptionType.connectionTimeout,
      ));

      // Act & Assert
      expect(
        () => network.client.get('/users'),
        throwsA(isA<DioException>()),
      );
    });

    test('POST request deve lidar com erro de servidor', () async {
      // Arrange
      final requestData = {'name': 'Test User'};
      
      when(() => mockDio.post(
        any(),
        data: any(named: 'data'),
        options: any(named: 'options'),
      )).thenThrow(DioException(
        requestOptions: MockRequestOptions(),
        response: Response(
          statusCode: 500,
          requestOptions: RequestOptions(),
          data: {'error': 'Internal Server Error'},
        ),
        type: DioExceptionType.badResponse,
      ));

      // Act & Assert
      expect(
        () => network.client.post('/users', data: requestData),
        throwsA(isA<DioException>()),
      );
    });
  });

  group('Network Configuration', () {
    test('deve configurar interceptadores corretamente', () {
      // Arrange & Act
      final network = Network.createNetwork(
        baseUrl: 'https://api.example.com',
      );

      // Assert
      expect(network.client.interceptors, isNotEmpty);
      expect(
        network.client.interceptors.any((i) => i is RequestResponseInterceptor),
        isTrue,
      );
    });

    test('deve usar as configurações de timeout corretas', () {
      // Arrange & Act
      final network = Network.createNetwork(
        baseUrl: 'https://api.example.com',
        connectTimeoutInMilliseconds: 5000,
        receiveTimeoutInMilliseconds: 3000,
      );

      // Assert
      expect(network.options.connectTimeout?.inMilliseconds, equals(5000));
      expect(network.options.receiveTimeout?.inMilliseconds, equals(3000));
    });
  });
} 