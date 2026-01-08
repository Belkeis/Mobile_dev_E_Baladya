# DocumentCubit Quick Reference

## 🎯 State Classes Overview

| State | Purpose | Properties |
|-------|---------|------------|
| `DocumentInitial` | Starting state | None |
| `DocumentsFetching` | Loading documents | None |
| `DocumentsLoaded` | Documents loaded | `documentsWithService`, `selectedDocument?` |
| `DocumentCreating` | Creating document | None |
| `DocumentCreated` | Creation success | `documentId`, `message` |
| `DocumentUpdating` | Updating document | `documentId` |
| `DocumentUpdated` | Update success | `documentId`, `message` |
| `DocumentDeleting` | Deleting document | `documentId` |
| `DocumentDeleted` | Deletion success | `documentId`, `message` |
| `DocumentSearching` | Searching/filtering | None |
| `DocumentSearchResults` | Search results | `documents`, `searchQuery?` |
| `DocumentSelected` | Document selected | `document` |
| `DocumentError` | Base error | `message`, `errorCode?`, `exception?` |

##  Core Methods

### CRUD Operations

```dart
// Load all documents
await cubit.loadDocuments(userId);

// Create new document
await cubit.createDocument(document);

// Update existing document
await cubit.updateDocument(document);

// Delete document
await cubit.deleteDocument(documentId, userId);
```

### Search & Filter

```dart
// Search by service
await cubit.searchByService(userId, serviceId);

// Filter valid documents
await cubit.filterValidDocuments(userId);

// Client-side filter
cubit.filterByValidity(true);  // valid only
cubit.filterByValidity(false); // invalid only

// Clear search
await cubit.clearSearch();
```

### Selection

```dart
// Select document
cubit.selectDocument(document);

// Get document by ID
await cubit.getDocumentById(documentId);

// Update selection
cubit.updateSelection(document);

// Clear selection
cubit.clearSelection();
```

### Utilities

```dart
// Reset to initial state
cubit.reset();

// Refresh current documents
await cubit.refresh();
```

##  UI Patterns

### Basic BlocBuilder

```dart
BlocBuilder<DocumentCubit, DocumentState>(
  builder: (context, state) {
    if (state is DocumentsFetching) {
      return CircularProgressIndicator();
    }
    if (state is DocumentsLoaded) {
      return DocumentList(docs: state.documentsWithService);
    }
    if (state is DocumentError) {
      return ErrorWidget(state.message);
    }
    return EmptyState();
  },
)
```

### BlocListener for Side Effects

```dart
BlocListener<DocumentCubit, DocumentState>(
  listener: (context, state) {
    if (state is DocumentCreated) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message)),
      );
    }
    if (state is DocumentError) {
      showDialog(...);
    }
  },
  child: YourWidget(),
)
```

### BlocConsumer (Both)

```dart
BlocConsumer<DocumentCubit, DocumentState>(
  listener: (context, state) {
    // Handle side effects
  },
  builder: (context, state) {
    // Build UI
  },
)
```

### Pull to Refresh

```dart
RefreshIndicator(
  onRefresh: () => context.read<DocumentCubit>().refresh(),
  child: ListView(...),
)
```

### Disable During Loading

```dart
ElevatedButton(
  onPressed: state is DocumentCreating 
    ? null 
    : () => cubit.createDocument(doc),
  child: state is DocumentCreating
    ? CircularProgressIndicator()
    : Text('Create'),
)
```

##  Repository Methods

```dart
// Read
getDigitalDocumentsByUserId(userId)
getDocumentById(documentId)
getDigitalDocumentsWithService(userId)

// Create
createDigitalDocument(document)

// Update
updateDigitalDocument(document)

// Delete
deleteDigitalDocument(documentId)

// Search/Filter
searchByServiceId(userId, serviceId)
getValidDocuments(userId)
```

## State Flows

### Load Documents
```
Initial → DocumentsFetching → DocumentsLoaded
                            ↘ DocumentFetchError
```

### Create Document
```
Loaded → DocumentCreating → DocumentCreated → DocumentsFetching → DocumentsLoaded
                         ↘ DocumentCreateError
```

### Update Document
```
Loaded → DocumentUpdating → DocumentUpdated → DocumentsFetching → DocumentsLoaded
                         ↘ DocumentUpdateError
```

### Delete Document
```
Loaded → DocumentDeleting → DocumentDeleted → DocumentsFetching → DocumentsLoaded
                         ↘ DocumentDeleteError
```

### Search
```
Loaded → DocumentSearching → DocumentSearchResults
                           ↘ DocumentSearchError
```

##  Testing

### Setup
```dart
late MockDocumentRepository mockRepository;
late DocumentCubit cubit;

setUp(() {
  mockRepository = MockDocumentRepository();
  cubit = DocumentCubit(mockRepository);
});
```

### Test Pattern
```dart
blocTest<DocumentCubit, DocumentState>(
  'description',
  build: () {
    when(() => mockRepository.method())
        .thenAnswer((_) async => result);
    return cubit;
  },
  act: (cubit) => cubit.method(),
  expect: () => [expectedState1, expectedState2],
);
```

##  Common Use Cases

### Display Document List
```dart
BlocBuilder<DocumentCubit, DocumentState>(
  builder: (context, state) {
    if (state is! DocumentsLoaded) return Container();
    
    return ListView.builder(
      itemCount: state.documentsWithService.length,
      itemBuilder: (context, index) {
        final item = state.documentsWithService[index];
        final doc = item['document'];
        final service = item['service'];
        return DocumentTile(doc: doc, service: service);
      },
    );
  },
)
```

### Create Document Form
```dart
onSubmit: () {
  final doc = DigitalDocumentModel(
    userId: userId,
    serviceId: serviceId,
    filePath: filePath,
    issuedDate: DateTime.now().toIso8601String(),
    isValid: 1,
  );
  context.read<DocumentCubit>().createDocument(doc);
}

// Listen for success
BlocListener<DocumentCubit, DocumentState>(
  listener: (context, state) {
    if (state is DocumentCreated) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message)),
      );
    }
  },
)
```

### Delete with Confirmation
```dart
onDelete: () {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Confirm Delete'),
      content: Text('Are you sure?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            context.read<DocumentCubit>()
                .deleteDocument(docId, userId);
          },
          child: Text('Delete'),
        ),
      ],
    ),
  );
}
```

### Search Implementation
```dart
// Search bar
TextField(
  onChanged: (query) {
    if (query.isEmpty) {
      cubit.clearSearch();
    } else {
      // Implement custom search logic
    }
  },
)

// Filter chips
Wrap(
  children: [
    FilterChip(
      label: Text('Valid Only'),
      onSelected: (selected) {
        if (selected) {
          cubit.filterValidDocuments(userId);
        } else {
          cubit.clearSearch();
        }
      },
    ),
  ],
)
```

##  Important Notes

- Always check for null document ID before update/delete
- Cache user ID for easier refresh operations
- Use const constructors for better performance
- Handle all states in UI for best UX
- Use BlocListener for navigation and dialogs
- Use BlocBuilder for rendering
- Test both success and error paths
- Provide user feedback for all operations

##  Dependencies

```yaml
dependencies:
  flutter_bloc: ^8.1.3
  equatable: ^2.0.5

dev_dependencies:
  bloc_test: ^9.1.5
  mocktail: ^1.0.1
```

##  Related Files

- `lib/logic/cubit/document_cubit.dart` - Main cubit
- `lib/logic/cubit/document_state.dart` - State definitions
- `lib/data/repo/document_repository.dart` - Repository
- `test/logic/cubit/document_cubit_test.dart` - Unit tests
- `DOCUMENT_CUBIT_IMPLEMENTATION.md` - Full documentation
