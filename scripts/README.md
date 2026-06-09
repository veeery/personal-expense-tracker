# Scripts

Internal developer tooling. Not required for building or running the app.

---

## generate_feature.sh

Generates a complete feature boilerplate following the project's Clean Architecture structure.

### Usage

```bash
# Run from project root
bash scripts/generate_feature.sh <feature_name>
```

Feature name must be `snake_case`. PascalCase class names are derived automatically.

```bash
bash scripts/generate_feature.sh expense         # → Expense
bash scripts/generate_feature.sh monthly_budget  # → MonthlyBudget
bash scripts/generate_feature.sh income          # → Income
```

### What gets generated

```
lib/features/<name>/
├── index.dart                          # Public API — barrel export
│                                       # Data layer intentionally excluded
├── domain/
│   ├── entities/
│   │   ├── <name>.dart                 # Entity (Equatable)
│   │   ├── <name>_category.dart        # Category enum
│   │   └── index.dart
│   ├── repositories/
│   │   ├── <name>_repository.dart      # Abstract interface
│   │   └── index.dart
│   └── usecases/
│       ├── add_<name>.dart             # Style B — call()
│       ├── update_<name>.dart
│       ├── delete_<name>.dart
│       ├── get_<name>s.dart
│       ├── get_<name>_summary.dart
│       └── index.dart
├── data/
│   ├── models/
│   │   └── <name>_model.dart           # Drift model + toEntity()
│   ├── datasources/
│   │   ├── <name>_datasource.dart      # Abstract interface
│   │   ├── <name>_local_datasource.dart
│   │   └── <name>_remote_datasource.dart  # Stub — UnimplementedError
│   └── repositories/
│       └── <name>_repository_impl.dart
└── presentation/
    ├── cubit/
    │   ├── <name>_list_cubit.dart
    │   ├── <name>_list_state.dart      # Sealed class — 4 states
    │   ├── <name>_form_cubit.dart
    │   ├── <name>_form_state.dart      # Sealed class — 4 states
    │   └── index.dart
    └── widgets/
        ├── <name>_list_item_widget.dart
        ├── <name>_summary_card_widget.dart
        ├── <name>_empty_state_widget.dart
        ├── <name>_amount_input_field_widget.dart
        └── index.dart
```

### After running

Four manual steps are always required after generation:

**1. Add Drift table — `core/database/app_database.dart`**
```dart
@DataClassName('<Name>TableData')
class <Name>Table extends Table {
  TextColumn get id => text()();
  // add columns here
}

@DriftDatabase(tables: [<Name>Table]) // register table
class AppDatabase extends _$AppDatabase { ... }
```

**2. Register dependencies — `core/di/injection_container.dart`**
```dart
// Datasource
getIt.registerLazySingleton<${Class}LocalDataSource>(
  () => ${Class}LocalDataSource(getIt<AppDatabase>()),
);

// Repository
getIt.registerLazySingleton<${Class}Repository>(
  () => ${Class}RepositoryImpl(
    localDataSource: getIt<${Class}LocalDataSource>(),
  ),
);

// UseCases
getIt.registerLazySingleton(() => Get${Class}sUseCase(getIt<${Class}Repository>()));
getIt.registerLazySingleton(() => Add${Class}UseCase(getIt<${Class}Repository>()));
// ... other usecases

// Cubits — factory, not singleton
getIt.registerFactory(
  () => ${Class}ListCubit(
    get${Class}s: getIt<Get${Class}sUseCase>(),
    get${Class}Summary: getIt<Get${Class}SummaryUseCase>(),
  ),
);
```

**3. Add routes — `core/router/app_router.dart`**
```dart
GoRoute(
  name: '<name>-list',
  path: '/<name>s',
  builder: (_, __) => const <Name>ListPage(),
  routes: [
    GoRoute(
      name: '<name>-detail',
      path: ':id',
      builder: (_, state) => <Name>DetailPage(
        id: state.pathParameters['id']!,
      ),
    ),
  ],
),
```

**4. Fill TODO fields — `domain/entities/<name>.dart`**
```dart
// Replace the placeholder id-only entity with actual fields
class Expense extends Equatable {
  final String id;
  final String title;       // add
  final double amount;      // add
  final DateTime date;      // add
  final ExpenseCategory category;  // add

  @override
  List<Object?> get props => [id, title, amount, date, category];
}
```

Then regenerate Drift code:
```bash
dart run build_runner build --delete-conflicting-outputs
```

---

## Design decisions baked into the generator

**Cubit over Bloc** — methods instead of events. Simpler for CRUD features, easier to read and test.

**Sealed states** — `Initial`, `Loading`, `Loaded`, `Error`. Dart 3 sealed class gives exhaustive switch at compile time. Adding a state without handling it in the UI is a compile error.

**Style B usecases** — `call()` instead of `execute()`. Callable class pattern — usecases can be invoked like functions: `await addExpense(expense)` instead of `await addExpense.execute(expense)`.

**Equatable on entities and states** — value equality for correct BlocBuilder rebuild behavior and accurate list operations.

**Remote datasource as stub** — `UnimplementedError` by default. Structure is ready for API integration without polluting local-only features with dead code.

**Data layer not barrel-exported** — `features/<name>/index.dart` explicitly excludes the data layer. Models and datasource implementations are internal details. Pages and other features only see entities, cubits, and widgets.