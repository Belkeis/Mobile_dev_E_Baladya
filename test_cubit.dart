import 'package:e_baladya/logic/cubit/document_cubit.dart';
import 'package:e_baladya/data/repo/document_repository.dart';

void main() async {
  print('🚀 Testing Document Cubit\n');
  print('=' * 60);
  
  // Create repository and cubit
  final repository = DocumentRepository();
  final cubit = DocumentCubit(repository);
  
  // Test user ID (change this to match a real user in your database)
  const testUserId = 1;
  
  // Listen to all state changes
  int stateChangeCount = 0;
  cubit.stream.listen((state) {
    stateChangeCount++;
    print('\n📊 State Change #$stateChangeCount: ${state.runtimeType}');
    print('   Details: $state');
    
    // Show specific information based on state type
    if (state is DocumentsLoaded) {
      print('   ✅ Loaded ${state.documentsWithService.length} documents');
      for (var item in state.documentsWithService) {
        final doc = item['document'];
        final service = item['service'];
        print('      - Document ID: ${doc.id}, Service: ${service?.serviceName ?? "Unknown"}');
      }
    } else if (state is DocumentFetchError) {
      print('   ❌ Error: ${state.message}');
      if (state.exception != null) {
        print('   Exception: ${state.exception}');
      }
    } else if (state is DocumentCreated) {
      print('   ✅ Created document with ID: ${state.documentId}');
      print('   Message: ${state.message}');
    } else if (state is DocumentUpdated) {
      print('   ✅ Updated document ID: ${state.documentId}');
      print('   Message: ${state.message}');
    } else if (state is DocumentDeleted) {
      print('   ✅ Deleted document ID: ${state.documentId}');
      print('   Message: ${state.message}');
    } else if (state is DocumentSelected) {
      print('   ✅ Selected document: ${state.document.id}');
    } else if (state is DocumentSearchResults) {
      print('   🔍 Search results: ${state.documents.length} documents');
      print('   Query: ${state.searchQuery}');
    }
    print('-' * 60);
  });
  
  // Test 1: Load documents
  print('\n🧪 TEST 1: Loading documents for user $testUserId');
  print('=' * 60);
  await cubit.loadDocuments(testUserId);
  await Future.delayed(Duration(seconds: 2));
  
  // Test 2: Search by service (if you know a service ID)
  // Uncomment and modify if needed:
  // print('\n🧪 TEST 2: Searching documents by service ID');
  // print('=' * 60);
  // await cubit.searchByService(testUserId, 1);
  // await Future.delayed(Duration(seconds: 2));
  
  // Test 3: Filter valid documents
  print('\n🧪 TEST 3: Filtering valid documents');
  print('=' * 60);
  await cubit.filterValidDocuments(testUserId);
  await Future.delayed(Duration(seconds: 2));
  
  // Test 4: Refresh
  print('\n🧪 TEST 4: Refreshing documents');
  print('=' * 60);
  await cubit.refresh();
  await Future.delayed(Duration(seconds: 2));
  
  // Clean up
  await cubit.close();
  
  print('\n✨ All tests completed!');
  print('=' * 60);
  print('Total state changes: $stateChangeCount');
}