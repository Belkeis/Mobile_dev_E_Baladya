# DocumentCubit - Complete Implementation Guide

## Overview

This document provides comprehensive documentation for the `DocumentCubit` implementation, which handles all document-related operations and state management following clean architecture principles.

## Architecture

### Clean Architecture Layers

```
┌─────────────────────────────────────────┐
│         Presentation Layer (UI)          │
│  - Widgets, Screens                      │
│  - BlocBuilder, BlocListener             │
└─────────────────┬───────────────────────┘
                  │
┌─────────────────▼───────────────────────┐
│      Business Logic Layer (Cubit)        │
│  - DocumentCubit                         │
│  - State Management                      │
│  - Business Rules                        │
└─────────────────┬───────────────────────┘
                  │
┌─────────────────▼───────────────────────┐
│         Data Layer (Repository)          │
│  - DocumentRepository                    │
│  - Data Operations                       │
└─────────────────┬───────────────────────┘
                  │
┌─────────────────▼───────────────────────┐
│         Data Source (Database)           │
│  - DatabaseHelper                        │
│  - SQLite Operations                     │
└─────────────────────────────────────────┘
```

## File Structure

```
lib/
├── data/
│   ├── models/
│   │   └── digital_document_model.dart
│   ├── database/
│   │   └── database_helper.dart
│   └── repo/
│       └── document_repository.dart
├── logic/
│   └── cubit/
│       ├── document_cubit.dart
│       └── document_state.dart
└── views/
    └── screens/
        └── digital_versions_page.dart (example usage)

test/
└── logic/
    └── cubit/
        └── document_cubit_test.dart
```

## State Classes

### State Hierarchy

```dart
DocumentState (abstract)
├── DocumentInitial                 // Initial idle state
├── Loading States
│   ├── DocumentLoading             // Generic loading
│   ├── DocumentsFetching           // Fetching documents
│   ├── DocumentCreating            // Creating document
│   ├── DocumentUpdating            // Updating document
│   ├── DocumentDeleting            // Deleting document
│   └── DocumentSearching           // Searching documents
├── Success States
│   ├── DocumentsLoaded             // Documents loaded with service info
│   ├── DocumentCreated             // Document created successfully
│   ├── DocumentUpdated             // Document updated successfully
│   ├── DocumentDeleted             // Document deleted successfully
│   ├── DocumentSearchResults       // Search/filter results
│   └── DocumentSelected            // Document selected
└── Error States
    ├── DocumentError               // Base error state
    ├── DocumentFetchError          // Error fetching documents
    ├── DocumentCreateError         // Error creating document
    ├── DocumentUpdateError         // Error updating document
    ├── DocumentDeleteError         // Error deleting document
    └── DocumentSearchError         // Error searching documents
```

### State Properties

#### DocumentsLoaded
```dart
- documentsWithService: List<Map<String, dynamic>>
- selectedDocument: DigitalDocumentModel? (optional)
```

#### DocumentCreated, DocumentUpdated, DocumentDeleted
```dart
- documentId: int
- message: String
```

#### DocumentSearchResults
```dart
- documents: List<DigitalDocumentModel>
- searchQuery: String? (optional)
```

#### Error States
```dart
- message: String
- errorCode: String? (optional)
- exception: dynamic (optional)
```

## Core Features

### 1. CRUD Operations

#### Load Documents
```dart
Future<void> loadDocuments(int userId)
```
- **Purpose**: Fetch all documents for a user with service information
- **State Flow**: `DocumentsFetching` → `DocumentsLoaded` | `DocumentFetchError`
- **Cache**: Stores `userId` for refresh operations

**Example Usage:**
```dart
context.read<DocumentCubit>().loadDocuments(userId);

// In UI
BlocBuilder<DocumentCubit, DocumentState>(
  builder: (context, state) {
    if (state is DocumentsFetching) {
      return CircularProgressIndicator();
    }
    if (state is DocumentsLoaded) {
      return DocumentList(documents: state.documentsWithService);
    }
    if (state is DocumentFetchError) {
      return ErrorWidget(message: state.message);
    }
    return Container();
  },
)
```

#### Create Document
```dart
Future<void> createDocument(DigitalDocumentModel document)
```
- **Purpose**: Create a new document
- **State Flow**: `DocumentCreating` → `DocumentCreated` → `DocumentsFetching` → `DocumentsLoaded` | `DocumentCreateError`
- **Auto-reload**: Automatically reloads documents after successful creation

**Example Usage:**
```dart
final newDocument = DigitalDocumentModel(
  userId: userId,
  serviceId: serviceId,
  filePath: filePath,
  issuedDate: DateTime.now().toIso8601String(),
  isValid: 1,
);

context.read<DocumentCubit>().createDocument(newDocument);

// Listen to creation success
BlocListener<DocumentCubit, DocumentState>(
  listener: (context, state) {
    if (state is DocumentCreated) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message)),
      );
    }
  },
  child: YourWidget(),
)
```

#### Update Document
```dart
Future<void> updateDocument(DigitalDocumentModel document)
```
- **Purpose**: Update an existing document
- **State Flow**: `DocumentUpdating` → `DocumentUpdated` → `DocumentsFetching` → `DocumentsLoaded` | `DocumentUpdateError`
- **Validation**: Checks for valid document ID
- **Auto-reload**: Automatically reloads documents after successful update

**Example Usage:**
```dart
final updatedDocument = existingDocument.copyWith(
  isValid: 0,
  expiresOn: DateTime.now().toIso8601String(),
);

context.read<DocumentCubit>().updateDocument(updatedDocument);
```

#### Delete Document
```dart
Future<void> deleteDocument(int documentId, int userId)
```
- **Purpose**: Delete a document by ID
- **State Flow**: `DocumentDeleting` → `DocumentDeleted` → `DocumentsFetching` → `DocumentsLoaded` | `DocumentDeleteError`
- **Auto-reload**: Automatically reloads documents after successful deletion

**Example Usage:**
```dart
context.read<DocumentCubit>().deleteDocument(documentId, userId);

// With confirmation dialog
showDialog(
  context: context,
  builder: (context) => AlertDialog(
    title: Text('Delete Document'),
    content: Text('Are you sure?'),
    actions: [
      TextButton(
        onPressed: () {
          Navigator.pop(context);
          context.read<DocumentCubit>().deleteDocument(docId, userId);
        },
        child: Text('Delete'),
      ),
    ],
  ),
);
```

### 2. Search & Filter Operations

#### Search by Service
```dart
Future<void> searchByService(int userId, int serviceId)
```
- **Purpose**: Find documents for a specific service
- **State Flow**: `DocumentSearching` → `DocumentSearchResults` | `DocumentSearchError`

**Example Usage:**
```dart
context.read<DocumentCubit>().searchByService(userId, serviceId);
```

#### Filter Valid Documents
```dart
Future<void> filterValidDocuments(int userId)
```
- **Purpose**: Show only valid documents
- **State Flow**: `DocumentSearching` → `DocumentSearchResults` | `DocumentSearchError`

**Example Usage:**
```dart
context.read<DocumentCubit>().filterValidDocuments(userId);
```

#### Client-Side Filter
```dart
void filterByValidity(bool isValid)
```
- **Purpose**: Filter current loaded documents without API call
- **State Flow**: `DocumentsLoaded` → `DocumentsLoaded` (filtered)

**Example Usage:**
```dart
// Show only valid documents
context.read<DocumentCubit>().filterByValidity(true);

// Show only invalid documents
context.read<DocumentCubit>().filterByValidity(false);
```

#### Clear Search
```dart
Future<void> clearSearch()
```
- **Purpose**: Remove filters and reload all documents

### 3. Selection Operations

#### Select Document
```dart
void selectDocument(DigitalDocumentModel document)
```
- **Purpose**: Select a document for viewing details
- **State Flow**: Current → `DocumentSelected`

**Example Usage:**
```dart
// On list item tap
onTap: () => context.read<DocumentCubit>().selectDocument(document);

// Navigate to details
BlocListener<DocumentCubit, DocumentState>(
  listener: (context, state) {
    if (state is DocumentSelected) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DocumentDetailsScreen(document: state.document),
        ),
      );
    }
  },
)
```

#### Update Selection
```dart
void updateSelection(DigitalDocumentModel? document)
```
- **Purpose**: Update selection in loaded state without navigation

#### Clear Selection
```dart
void clearSelection()
```
- **Purpose**: Remove current selection from loaded state

#### Get Document by ID
```dart
Future<void> getDocumentById(int documentId)
```
- **Purpose**: Fetch and select a specific document
- **State Flow**: `DocumentLoading` → `DocumentSelected` | `DocumentFetchError`

### 4. Utility Methods

#### Reset
```dart
void reset()
```
- **Purpose**: Reset cubit to initial state
- **Use Case**: Logout, clear all data

#### Refresh
```dart
Future<void> refresh()
```
- **Purpose**: Reload current documents
- **Use Case**: Pull-to-refresh functionality

**Example Usage:**
```dart
RefreshIndicator(
  onRefresh: () => context.read<DocumentCubit>().refresh(),
  child: DocumentList(),
)
```

## Repository Layer

### DocumentRepository

Enhanced with full CRUD operations:

```dart
// Read
Future<List<DigitalDocumentModel>> getDigitalDocumentsByUserId(int userId)
Future<DigitalDocumentModel?> getDocumentById(int documentId)
Future<List<Map<String, dynamic>>> getDigitalDocumentsWithService(int userId)

// Create
Future<int> createDigitalDocument(DigitalDocumentModel doc)

// Update
Future<int> updateDigitalDocument(DigitalDocumentModel doc)

// Delete
Future<int> deleteDigitalDocument(int documentId)

// Search & Filter
Future<List<DigitalDocumentModel>> searchByServiceId(int userId, int serviceId)
Future<List<DigitalDocumentModel>> getValidDocuments(int userId)
```

### Error Handling

Repository throws `RepositoryException` for all errors:
```dart
try {
  await repository.createDigitalDocument(doc);
} catch (e) {
  if (e is RepositoryException) {
    print('Repository error: ${e.message}');
  }
}
```

## Testing

### Test Coverage

Comprehensive unit tests included for:
- ✅ Initial state verification
- ✅ Load documents (success & error)
- ✅ Create document (success & error)
- ✅ Update document (success & error & validation)
- ✅ Delete document (success & error)
- ✅ Search operations
- ✅ Filter operations
- ✅ Selection operations
- ✅ Utility methods (reset, refresh)

### Running Tests

```bash
# Install dependencies
flutter pub get

# Run all tests
flutter test

# Run specific test file
flutter test test/logic/cubit/document_cubit_test.dart

# Run with coverage
flutter test --coverage
```

### Test Dependencies

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  bloc_test: ^9.1.5
  mocktail: ^1.0.1
```

## UI Integration Examples

### Complete Screen Example

```dart
class DocumentsScreen extends StatelessWidget {
  final int userId;
  
  const DocumentsScreen({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Documents')),
      body: BlocConsumer<DocumentCubit, DocumentState>(
        // Handle side effects
        listener: (context, state) {
          if (state is DocumentCreated || 
              state is DocumentUpdated || 
              state is DocumentDeleted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
          
          if (state is DocumentError) {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: Text('Error'),
                content: Text(state.message),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('OK'),
                  ),
                ],
              ),
            );
          }
        },
        // Build UI
        builder: (context, state) {
          if (state is DocumentsFetching) {
            return Center(child: CircularProgressIndicator());
          }
          
          if (state is DocumentsLoaded) {
            if (state.documentsWithService.isEmpty) {
              return Center(child: Text('No documents found'));
            }
            
            return RefreshIndicator(
              onRefresh: () => context.read<DocumentCubit>().refresh(),
              child: ListView.builder(
                itemCount: state.documentsWithService.length,
                itemBuilder: (context, index) {
                  final item = state.documentsWithService[index];
                  final doc = item['document'] as DigitalDocumentModel;
                  final service = item['service'];
                  
                  return ListTile(
                    title: Text(service?['name'] ?? 'Unknown'),
                    subtitle: Text(doc.issuedDate),
                    trailing: PopupMenuButton(
                      itemBuilder: (_) => [
                        PopupMenuItem(
                          child: Text('Edit'),
                          onTap: () => _editDocument(context, doc),
                        ),
                        PopupMenuItem(
                          child: Text('Delete'),
                          onTap: () => _deleteDocument(context, doc),
                        ),
                      ],
                    ),
                    onTap: () => context
                        .read<DocumentCubit>()
                        .selectDocument(doc),
                  );
                },
              ),
            );
          }
          
          return Center(child: Text('No documents loaded'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createDocument(context),
        child: Icon(Icons.add),
      ),
    );
  }
  
  void _createDocument(BuildContext context) {
    // Navigate to create screen or show dialog
  }
  
  void _editDocument(BuildContext context, DigitalDocumentModel doc) {
    // Navigate to edit screen or show dialog
  }
  
  void _deleteDocument(BuildContext context, DigitalDocumentModel doc) {
    context.read<DocumentCubit>().deleteDocument(doc.id!, userId);
  }
}
```

## Best Practices

### 1. State Management
- ✅ Always handle all possible states in UI
- ✅ Use BlocListener for side effects (navigation, snackbars, dialogs)
- ✅ Use BlocBuilder for UI rendering
- ✅ Use BlocConsumer when you need both

### 2. Error Handling
- ✅ Catch and display user-friendly error messages
- ✅ Log exceptions for debugging
- ✅ Provide retry mechanisms for failed operations

### 3. Loading States
- ✅ Show loading indicators during async operations
- ✅ Disable inputs during loading to prevent duplicate requests
- ✅ Provide cancel mechanisms for long operations

### 4. Performance
- ✅ Use const constructors for states when possible
- ✅ Leverage Equatable for efficient state comparison
- ✅ Cache user ID to reduce parameter passing
- ✅ Use client-side filtering when appropriate

### 5. Testing
- ✅ Write tests for all cubit methods
- ✅ Test both success and error scenarios
- ✅ Mock repository dependencies
- ✅ Verify state emissions and method calls

## Migration from Legacy Code

### Backward Compatibility

Legacy methods are preserved with deprecation warnings:

```dart
// ❌ Old (deprecated)
await cubit.loadDigitalDocuments(userId);
await cubit.createDigitalDocument(document);

// ✅ New (recommended)
await cubit.loadDocuments(userId);
await cubit.createDocument(document);
```

### Updating Existing Code

1. **Replace method calls:**
   - `loadDigitalDocuments()` → `loadDocuments()`
   - `createDigitalDocument()` → `createDocument()`

2. **Handle new states:**
   - `DocumentLoading` is still supported
   - New specific states provide better UX

3. **No breaking changes** to existing UI code

## Troubleshooting

### Common Issues

**Issue**: States not updating
**Solution**: Ensure you're using `context.read<DocumentCubit>()` to call methods

**Issue**: Multiple simultaneous operations
**Solution**: Disable UI actions during loading states

**Issue**: Documents not refreshing
**Solution**: Call `refresh()` or use `RefreshIndicator`

**Issue**: Selection not persisting
**Solution**: Use `updateSelection()` instead of `selectDocument()`

## Future Enhancements

Potential additions:
- Batch operations (multi-select, bulk delete)
- Document categories/tagging
- Advanced search with multiple criteria
- Document versioning
- Document sharing
- Offline support with sync
- Real-time updates via streams

## Summary

The DocumentCubit provides a complete, production-ready solution for document management with:
- ✅ Full CRUD operations
- ✅ Search and filter capabilities
- ✅ Document selection
- ✅ Clean architecture
- ✅ Comprehensive error handling
- ✅ Unit tests
- ✅ Backward compatibility
- ✅ Immutable states
- ✅ Performance optimizations

All requirements have been met and exceeded with a robust, scalable implementation.
