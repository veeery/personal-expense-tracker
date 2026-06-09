# Personal Expense Tracker

A Flutter-based personal expense tracking application built as a take-home assignment for Neurogine Sdn Bhd. The app allows users to record, view, and manage their daily expenses with full offline support via local persistence.

---

## How to Run

### Prerequisites
- Flutter SDK `>=3.x`
- Dart SDK `>=3.x`
- Android Studio / VS Code with Flutter plugin

### Steps

```bash
# Clone the repository
git clone https://github.com/YOUR_USERNAME/personal-expense-tracker.git
cd personal-expense-tracker

# Install dependencies
flutter pub get

# Generate Drift database code
dart run build_runner build --delete-conflicting-outputs

# Run the app
flutter run
```

### Run Tests

```bash
flutter test
```

---

## Tech Stack

| Concern | Package | Reason |
|---|---|---|
| Language | Dart 3 | Sealed classes, pattern matching |
| UI | Flutter | Cross-platform, stated in assignment |
| State management | `flutter_bloc` (Cubit) | Predictable state, lightweight vs full Bloc |
| Local database | `drift` | Type-safe SQL, code generation, reactive streams |
| Dependency injection | `get_it` | Lightweight service locator, no code generation needed |
| Navigation | `go_router` | Declarative, deep-link ready, named routes |
| Equality | `equatable` | Value equality for entities and states without boilerplate |
| UUID | `uuid` | Generate unique expense IDs client-side |

---

## Why Flutter

The assignment lists Flutter as an accepted platform. Beyond that, Flutter was the right choice here for three concrete reasons.

First, single codebase with native performance. For a local-first app with no backend, Flutter's rendering pipeline adds no meaningful overhead and the developer experience is significantly faster than maintaining separate codebases.

Second, Drift — the local database chosen for this project — has first-class Flutter support with reactive streams that integrate naturally with Cubit. The combination of `Stream<List<Expense>>` from Drift and `emit()` in Cubit results in a clean, reactive data flow with minimal glue code.

Third, my existing expertise is in Flutter with a fintech background. The goal was to produce production-quality code that I can defend in an interview, not to learn a new framework under time pressure.

---

## Architecture

The project follows **Clean Architecture** with a **feature-first folder structure**.

### Why Clean Architecture

Clean Architecture enforces a single rule: dependencies point inward. Domain knows nothing about Flutter, Drift, or any infrastructure. Data layer knows about Drift but not about widgets. Presentation knows about Flutter but not about Drift.

The practical benefit is not abstract — it means the domain layer can be unit tested without spinning up a database or a widget tree. It also means swapping Drift for another storage solution only requires touching the data layer.

### Why Feature-First

Layer-first structure (`lib/domain/`, `lib/data/`, `lib/presentation/`) works for small apps but becomes difficult to navigate as features grow. Feature-first (`lib/features/expense/`) keeps everything related to a business capability in one place. Adding a new feature means adding a new folder without touching existing code.

### Folder Structure

```
lib/
├── main.dart
├── app.dart
│
├── core/                          # Cross-cutting infrastructure
│   ├── database/
│   │   └── app_database.dart      # Drift database setup
│   ├── di/
│   │   └── injection_container.dart
│   ├── router/
│   │   └── app_router.dart
│   ├── error/
│   │   ├── failures.dart          # Sealed class failures
│   │   └── exceptions.dart
│   ├── utils/
│   │   ├── currency_formatter.dart
│   │   └── date_formatter.dart
│   └── theme/
│       ├── app_theme.dart
│       ├── app_colors.dart
│       └── app_typography.dart
│
├── pages/                         # Navigation layer — composes feature widgets
│   ├── shell/                     # Pages wrapped in bottom nav shell
│   │   ├── home/
│   │   │   └── home_page.dart
│   │   ├── transactions/
│   │   │   ├── transaction_list_page.dart
│   │   │   └── transaction_detail_page.dart
│   │   └── add/
│   │       └── add_expense_page.dart
│   └── not_found_page.dart        # Detached — accessible from anywhere
│
└── features/
    └── expense/
        ├── index.dart             # Public API — barrel export
        ├── domain/
        │   ├── entities/
        │   │   ├── expense.dart
        │   │   └── category.dart
        │   ├── repositories/
        │   │   └── expense_repository.dart   # Abstract interface
        │   └── usecases/
        │       ├── add_expense.dart
        │       ├── update_expense.dart
        │       ├── delete_expense.dart
        │       ├── get_expenses.dart
        │       └── get_expense_summary.dart
        ├── data/
        │   ├── models/
        │   │   └── expense_model.dart        # Drift table + toEntity()
        │   ├── datasources/
        │   │   └── expense_local_datasource.dart
        │   └── repositories/
        │       └── expense_repository_impl.dart
        └── presentation/
            ├── cubit/
            │   ├── expense_list_cubit.dart
            │   ├── expense_list_state.dart
            │   ├── expense_form_cubit.dart
            │   └── expense_form_state.dart
            └── widgets/
                ├── expense_list_item.dart
                ├── expense_summary_card.dart
                ├── empty_state_widget.dart
                └── amount_input_field.dart
```

### Layer Responsibilities

**Domain** — pure Dart, zero Flutter imports, zero infrastructure imports. Contains entities (business objects), repository interfaces (contracts), and use cases (one business action per class). This layer can be unit tested with no dependencies beyond `dart:core`.

**Data** — implements domain contracts. Contains Drift table definitions, models with `toEntity()` mapping, datasources that execute raw queries, and repository implementations. Models never leave this layer — only entities are returned upward.

**Presentation** — Flutter and Cubit. Cubits consume use cases and emit typed states. Widgets are stateless where possible and consume Cubit state via `BlocBuilder`. This layer contains only widgets and cubits — no pages, no navigation logic.

**Pages** — navigation concern, completely separate from features. A page is a thin scaffold that composes widgets from one or more features and provides Cubit via `BlocProvider`. Pages have no business logic and no direct dependency on the data layer.

Pages are split into two groups. Shell pages live under `pages/shell/` and are wrapped in the bottom navigation scaffold via GoRouter `ShellRoute`. Detached pages live at the root of `pages/` and are registered outside the `ShellRoute` — they have no bottom nav and are accessible from any navigation context via named routes. This structure mirrors the GoRouter configuration exactly, so the folder tree and the route tree are always in sync.

**Core** — shared infrastructure that belongs to no single feature. Database setup lives here because it is an infrastructure concern. Router lives here because route definitions are shared across all pages. Utils and theme live here because they are consumed by every layer.

### Dependency Rule

```
pages → features/presentation → domain ← data
```

Domain is the center. Data and presentation both depend on domain. Pages depend on presentation. Nothing depends on pages.

### Barrel Exports

Each feature exposes a public API via `index.dart` barrel exports. Domain and presentation layers are exported. The data layer is intentionally not exported — models and datasource implementations are internal details that no outside layer should depend on.

```dart
// pages/shell/transactions/transaction_list_page.dart
import 'package:app/features/expense/index.dart';
// Gets: entities, cubits, widgets
// Does not get: ExpenseModel, ExpenseLocalDatasource
```

### State Management

Cubit is used instead of full Bloc. Cubit is part of the `flutter_bloc` package — it still has typed states, it simply replaces event classes with direct method calls. Each Cubit has a corresponding sealed state class using Dart 3 sealed classes, which gives exhaustive pattern matching at compile time.

```dart
// UI — compiler enforces all states are handled
switch (state) {
  ExpenseListInitial()  => ...,
  ExpenseListLoading()  => ...,
  ExpenseListLoaded()   => ...,
  ExpenseListError()    => ...,
}
```

If a new state is added but not handled in the UI, the code will not compile.

---

## Key Decisions and Trade-offs

### Cubit over full Bloc

Bloc requires mapping events to states via `on<Event>()` handlers. For this app, the added indirection provides no meaningful benefit. Cubit exposes methods directly (`loadExpenses()`, `addExpense()`) which are easier to read, test, and explain. If the state logic grew complex enough to benefit from event sourcing or logging individual events, migrating from Cubit to Bloc is mechanical — the state classes do not change.

### GetIt over Riverpod for DI

Riverpod is a powerful state management and DI solution but conflates two concerns. GetIt is a pure service locator — it registers and resolves dependencies without touching the widget tree. For an app that already has Cubit for state management, adding Riverpod purely for DI introduces unnecessary surface area. GetIt is also straightforward to explain and reason about in a technical interview.

### Drift over Hive or sqflite

sqflite is eliminated because raw string queries are not type-safe — typos surface at runtime, not compile time. Hive is fast but NoSQL — filtering by date range or summing by category requires pulling all records into memory and aggregating in Dart, which is not scalable. Drift generates type-safe query code from table definitions, supports full SQL aggregation natively, and returns reactive `Stream<List<T>>` that integrates directly with Cubit without any polling or manual refresh.

### Anemic Domain Model

Validation lives in use cases, not in entity constructors. For a CRUD-centric app like an expense tracker, rich domain models add overhead without proportional benefit. There is no complex business logic where multiple rules interact across fields. If the domain grew — for example, budget enforcement rules that cross-reference expense history — moving to a richer model would be justified.

### Pages as a Separate Layer from Features

A feature is a unit of business capability. A page is a unit of navigation. The distinction matters when one page needs to compose from multiple features — for example, a dashboard showing both expense and income summaries — or when the same feature widgets appear in multiple pages. Keeping them separate means neither layer needs to know about the other's internals. Features expose widgets and cubits. Pages consume them.

### Shell and Detached Page Structure

Pages are split based on their navigation context. Shell pages are part of the bottom navigation flow and share a common scaffold. Detached pages are accessible from any route without a shell — they are registered at the top level of GoRouter outside the `ShellRoute`. This maps the folder structure directly to the router configuration, making navigation hierarchy readable from the file tree alone.

### Barrel Exports as Feature Public API

Each feature explicitly defines what it exposes via `index.dart`. This enforces layer boundaries without relying on developer discipline. The data layer is never barrel-exported, which makes it structurally impossible for a page to accidentally import an `ExpenseModel` directly.

---

## Screens

### Transaction List (Home)
- Displays all expenses sorted by date descending
- Summary card showing total amount
- Empty state when no expenses exist
- Tap item to navigate to detail

### Add Expense
- Form with title, amount, date, and category fields
- Input validation with inline error messages
- Loading state during save operation

### Expense Detail / Edit
- Displays full expense information
- Inline editing with the same validation as add form
- Delete with confirmation dialog

---

## What I Would Add With More Time

**Income support** — the domain is already structured around a transaction concept. Adding income would mean extending `Category` and `Expense` to a `Transaction` entity with a `TransactionType` field. The architecture does not need to change.

**Filtering and search** — date range filter and category filter on the list screen. Drift already supports parameterized queries; this is primarily a presentation concern.

**Export to CSV** — the domain already has all the data; export is a new use case that writes to a file.

**Widget tests** — the current test suite covers domain use cases and the repository implementation. Widget tests for the list screen and form screen would complete the coverage.

**Pagination** — for large expense histories, loading all records at once is not scalable. Drift supports `LIMIT` and `OFFSET`; the repository interface would need a paginated variant.

**Richer error handling** — current error handling surfaces a generic message. Distinguishing between database corruption, disk full, and query errors would allow more actionable user feedback.

---

## Background

Built by a Flutter specialist with 4.5+ years of experience in fintech and capital markets, including building 5 modular Flutter packages from scratch in a production trading application. This project applies the same architectural principles used in production — Clean Architecture, feature isolation, and explicit layer boundaries — scaled appropriately for a take-home assignment scope.