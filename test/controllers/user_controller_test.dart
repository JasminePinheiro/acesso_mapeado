import 'package:acesso_mapeado/models/user_model.dart';
import 'package:acesso_mapeado/shared/color_blindness_type.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:acesso_mapeado/controllers/user_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_mock.dart';

import 'user_controller_test.mocks.dart';

// Gerar mocks
@GenerateMocks([
  FirebaseAuth,
  FirebaseFirestore,
  User,
  DocumentReference,
  CollectionReference,
  DocumentSnapshot,
  UserCredential,
  UserModel,
  ProviderColorBlindnessType
])
void main() {
  late UserController userController;
  late MockFirebaseAuth mockAuth;
  late MockFirebaseFirestore mockFirestore;
  late MockUser mockUser;
  late MockProviderColorBlindnessType mockProviderColorBlindnessType;

  setUpAll(() async {
    // Inicializar mock do firebase
    setupFirebaseAuthMocks();
    await Firebase.initializeApp();
  });

  setUp(() {
    mockAuth = MockFirebaseAuth();
    mockFirestore = MockFirebaseFirestore();
    mockUser = MockUser();
    mockProviderColorBlindnessType = MockProviderColorBlindnessType();

    // Configurar comportamentos padrão dos mocks
    when(mockUser.uid).thenReturn('test-uid');
    when(mockAuth.currentUser).thenReturn(mockUser);
    when(mockAuth.authStateChanges())
        .thenAnswer((_) => Stream.fromIterable([mockUser]));

    userController = UserController(
        auth: mockAuth,
        firestore: mockFirestore,
        providerColorBlindnessType: mockProviderColorBlindnessType);
  });

  group('UserController Tests', () {
    test('initial state should be correct', () {
      expect(userController.user, mockUser);
      expect(userController.userModel, null);
      expect(userController.companyModel, null);
      expect(userController.userPosition, null);
    });

    test('setUserPosition updates position and notifies listeners', () {
      const testPosition = LatLng(0, 0);
      var listenerCalled = false;

      userController.addListener(() {
        listenerCalled = true;
      });

      userController.setUserPosition(testPosition);

      expect(userController.userPosition, testPosition);
      expect(listenerCalled, true);
    });

    test('signIn success', () async {
      final mockUserCredential = MockUserCredential();
      when(mockUserCredential.user).thenReturn(mockUser);

      when(mockAuth.signInWithEmailAndPassword(
        email: 'test@test.com',
        password: 'password',
      )).thenAnswer((_) async => mockUserCredential);

      final result = await userController.signIn('test@test.com', 'password');

      expect(result, mockUser);
    });

    test('signIn failure throws exception', () async {
      when(mockAuth.signInWithEmailAndPassword(
        email: 'test@test.com',
        password: 'wrong-password',
      )).thenThrow(FirebaseAuthException(code: 'wrong-password'));

      expect(
        () => userController.signIn('test@test.com', 'wrong-password'),
        throwsException,
      );
    });

    test('isValidEmail returns correct validation', () {
      expect(userController.isValidEmail('test@test.com'), true);
      expect(userController.isValidEmail('invalid-email'), false);
    });

    test('logout clears user data and notifies listeners', () {
      var listenerCalled = false;
      userController.addListener(() {
        listenerCalled = true;
      });

      userController.logout();

      expect(userController.user, null);
      expect(userController.userModel, null);
      expect(listenerCalled, true);
    });

    test('loadUserProfile updates userModel and notifies listeners', () async {
      // Criar referência da coleção mock
      final mockCollectionRef = MockCollectionReference<Map<String, dynamic>>();
      final mockDocRef = MockDocumentReference<Map<String, dynamic>>();
      final mockDocSnapshot = MockDocumentSnapshot<Map<String, dynamic>>();

      // Configurar a cadeia de mocks
      when(mockFirestore.collection('users')).thenReturn(mockCollectionRef);
      when(mockCollectionRef.doc('test-uid')).thenReturn(mockDocRef);
      when(mockDocRef.get()).thenAnswer((_) async => mockDocSnapshot);
      when(mockDocSnapshot.exists).thenReturn(true);
      when(mockDocSnapshot.data()).thenReturn({
        'name': 'Test User',
        'email': 'test@test.com',
        'isCompany': false,
        'cpf': '123.456.789-00',
        'profilePictureUrl': 'test-profile-picture',
        'accessibilityData': null,
        'commentsData': null,
        'dateOfBirth': '2000-01-01T00:00:00.000Z',
        'registrationDate': '2024-01-01T00:00:00.000Z'
      });

      var listenerCalled = false;
      userController.addListener(() {
        listenerCalled = true;
      });

      await userController.loadUserProfile();

      expect(userController.userModel, isNotNull);
      expect(userController.userModel?.name, 'Test User');
      expect(listenerCalled, true);
    });
  });
}
