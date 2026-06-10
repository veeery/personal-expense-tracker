# Personal Expense Tracker

A Flutter-based personal expense tracking application built as a take-home assignment for Neurogine Sdn Bhd. The app allows users to record, view, and manage their daily expenses with full offline support via local persistence.

---

## How to Run

### Prerequisites
- Flutter SDK `3.44.1` (via FVM recommended)
- Dart SDK `3.12.1`
- Android Studio / VS Code with Flutter plugin

### Steps

```bash
# Clone the repository
git clone https://github.com/veeery/personal-expense-tracker.git
cd personal-expense-tracker

# Install dependencies
flutter pub get

# Generate Drift database code
dart run build_runner build --delete-conflicting-outputs

# Run the app
flutter run
```

---

## Tech Stack

| Concern | Package | Reason |
|---|---|---|
| Language | Dart 3.12 | Sealed classes, pattern matching, exhaustive switch |
| UI | Flutter 3.44 | Cross-platform, native performance |
| State management | `flutter_bloc` (Cubit) | Predictable state, lightweight vs full Bloc |
| Local database | `drift` | Type-safe SQL, code generation, reactive streams |
| Dependency injection | `get_it` | Lightweight service locator, no code generation needed |
| Navigation | `go_router` | Declarative routing, ShellRoute for bottom nav |
| Persistence (settings) | `shared_preferences` | Key-value storage for theme preference |
| Equality | `equatable` | Value equality for entities and states without boilerplate |
| UUID | `uuid` | Generate unique expense IDs client-side |

---

## Why Flutter

The assignment lists Flutter as an accepted cross-platform option. Beyond that, Flutter was the right choice for three concrete reasons.

First, single codebase with native performance. For a local-first app with no backend, Flutter's rendering pipeline adds no meaningful overhead and the developer experience is significantly faster than maintaining separate codebases.

Second, Drift has first-class Flutter support with reactive streams that integrate naturally with Cubit. The combination of `Stream<List<Expense>>` from Drift and `emit()` in Cubit results in a clean, reactive data flow with minimal glue code.

Third, my existing expertise is in Flutter with a fintech background. The goal was to produce production-quality code that I can defend in a technical interview, not to learn a new framework under time pressure.

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
├── app.dart                           # MaterialApp — ThemeCubit wrapped here
│
├── core/                              # Cross-cutting infrastructure
│   ├── database/
│   │   └── app_database.dart          # Drift database + ExpenseTable
│   ├── di/
│   │   └── injection_container.dart   # GetIt registrations
│   ├── enums/
│   │   └── expense_category.dart      # ExpenseCategory with color/emoji/label
│   ├── router/
│   │   ├── app_router.dart
│   │   ├── app_routes.dart            # Route definitions
│   │   ├── app_navigator.dart         # Navigation helpers
│   │   └── main_shell.dart            # Bottom nav shell
│   ├── error/
│   │   ├── failures.dart
│   │   └── exceptions.dart
│   ├── utils/
│   │   ├── currency_formatter.dart    # Rupiah formatting
│   │   └── date_formatter.dart        # Locale-aware date formatting
│   └── theme/
│       ├── app_theme.dart             # Light + dark ThemeData
│       ├── app_colors.dart
│       └── app_typography.dart        # Plus Jakarta Sans typography
│
├── pages/                             # Navigation layer — thin scaffolds
│   ├── not_found_page.dart
│   └── shell/                         # Pages inside ShellRoute (have bottom nav)
│       ├── home/
│       │   ├── home_page.dart         # Summary card + transaction list
│       │   ├── expense/               # Detached — pushed on top of shell
│       │   │   ├── add_expense_page.dart
│       │   │   └── edit_expense_page.dart
│       │   └── transaction/           # Detached — pushed on top of shell
│       │       └── transaction_detail_page.dart
│       └── settings/
│           └── settings_page.dart     # Dark mode toggle
│
└── features/
    ├── expense/                       # Expense CRUD feature
    │   ├── expense.dart               # Public barrel export
    │   ├── domain/
    │   │   ├── entities/
    │   │   │   └── expense_entity.dart
    │   │   ├── repositories/
    │   │   │   └── expense_repository.dart
    │   │   └── usecases/
    │   │       ├── watch_expenses_usecase.dart
    │   │       ├── add_expense_usecase.dart
    │   │       ├── update_expense_usecase.dart
    │   │       └── delete_expense_usecase.dart
    │   ├── data/
    │   │   ├── models/
    │   │   │   └── expense_model.dart        # Drift extension mapper
    │   │   ├── datasources/
    │   │   │   └── expense_local_datasource.dart
    │   │   └── repositories/
    │   │       └── expense_repository_impl.dart
    │   └── presentation/
    │       ├── cubit/
    │       │   ├── expense_cubit.dart
    │       │   └── expense_state.dart
    │       └── widgets/
    │           ├── expense_list_tile.dart
    │           ├── total_summary_card.dart
    │           └── empty_expense_widget.dart
    │
    └── theme/                         # Theme persistence feature
        ├── theme.dart                 # Public barrel export
        ├── data/
        │   └── theme_local_datasource.dart   # SharedPreferences read/write
        └── presentation/
            └── cubit/
                ├── theme_cubit.dart
                └── theme_state.dart
```

### Layer Responsibilities

**Domain** — pure Dart, zero Flutter imports, zero infrastructure imports. Contains entities, repository interfaces, and use cases (one business action per class).

**Data** — implements domain contracts. Contains Drift table definitions, extension-based mappers, datasources, and repository implementations. Models never leave this layer — only entities are returned upward.

**Presentation** — Flutter and Cubit. Cubits consume use cases and emit typed states. Widgets are stateless and consume Cubit state via `BlocBuilder`.

**Pages** — navigation concern, completely separate from features. A page is a thin scaffold that provides `BlocProvider` and composes widgets from features. Pages have no business logic.

Pages under `shell/` mirror the ShellRoute structure. `home/` and `settings/` are the two shell tabs. Pages under `home/expense/` and `home/transaction/` are detached — registered outside `ShellRoute` in the router, pushed on top of the shell via `context.push()`.

### Routing Structure

Routes are split into two groups:

**Shell routes** — wrapped in `MainShell` via GoRouter `ShellRoute`, share the bottom navigation bar: `/home` and `/settings`.

**Detached routes** — registered outside `ShellRoute`, no bottom nav, pushed on top of the shell: `/add`, `/transactions/:id`, `/transactions/:id/edit`.

Using `context.push()` for detached routes preserves the shell state underneath, so returning from detail always brings the user back to the correct tab.

### Dependency Rule

```
pages → features/presentation → domain ← data
```

Domain is the center. Data and presentation both depend on domain. Pages depend on presentation. Nothing depends on pages.

### State Management

Cubit is used instead of full Bloc. Each Cubit exposes direct methods (`load()`, `add()`, `update()`, `delete()`) and emits sealed states:

```dart
sealed class ExpenseState extends Equatable {}
class ExpenseInitial extends ExpenseState {}
class ExpenseLoading extends ExpenseState {}
class ExpenseLoaded extends ExpenseState { final List<Expense> items; }
class ExpenseError extends ExpenseState { final String message; }
```

Dart 3 sealed classes give exhaustive pattern matching at compile time. If a new state is added but not handled in the UI, the code will not compile.

The `ExpenseCubit` uses `watchAll()` which returns a `Stream<List<Expense>>` from Drift. The stream subscription is held in the Cubit and cancelled in `close()`. The list updates reactively — add, edit, or delete an expense and the list reflects the change immediately without manual refresh.

---

## Key Decisions and Trade-offs

### Cubit over full Bloc

Bloc requires mapping events to states via `on<Event>()` handlers. For this app, the added indirection provides no meaningful benefit. Cubit exposes methods directly which are easier to read, test, and explain. Migrating from Cubit to Bloc is mechanical if needed — the state classes do not change.

### GetIt over Riverpod for DI

Riverpod conflates state management and DI into one solution. GetIt is a pure service locator that resolves dependencies without touching the widget tree. For an app that already has Cubit for state management, adding Riverpod purely for DI introduces unnecessary surface area.

### Drift over Hive or sqflite

sqflite is eliminated because raw string queries are not type-safe — typos surface at runtime. Hive is fast but NoSQL — filtering by date range or aggregating by category requires pulling all records into memory. Drift generates type-safe query code, supports full SQL natively, and returns reactive streams that integrate directly with Cubit.

### Extension Pattern for Drift Models

Instead of a manual model class that duplicates fields from the Drift-generated `ExpenseTableData`, the project uses Dart extensions:

```dart
extension ExpenseDataMapper on ExpenseTableData {
  Expense toEntity() => Expense(id: id, title: title, ...);
}

extension ExpenseEntityMapper on Expense {
  ExpenseTableCompanion toCompanion() => ExpenseTableCompanion.insert(...);
}
```

This eliminates the model class entirely. The generated Drift class is the model — the extension adds the mapping behaviour without a wrapper.

### One ExpenseCubit, Not Two

An earlier design considered splitting into `ExpenseListCubit` and `ExpenseFormCubit`. The single-Cubit approach was chosen because the Cubit does not hold complex form state — it is a pure executor. Add, update, and delete methods call their respective use cases and return. The stream listener handles list updates reactively. Splitting would add boilerplate without adding clarity.

### Theme as a Feature

Dark mode preference is implemented as a proper feature (`features/theme/`) with its own datasource (`SharedPreferences`) and Cubit (`ThemeCubit`). The `ThemeCubit` is a `lazySingleton` in GetIt — a single instance shared app-wide, provided above `MaterialApp` so `themeMode` responds to state changes immediately.

### Detached Pages for Detail, Edit, and Add

Transaction detail, edit, and add pages are registered outside `ShellRoute`. The bottom navigation bar should not appear on these screens — they are focused sub-flows, not app sections. Detached registration with `context.push()` preserves the shell underneath so the back button always returns correctly.

---

## Screens

### Home
- Summary card showing total expenses
- Full transaction list sorted by date descending
- Empty state when no expenses exist
- Tap any item to navigate to transaction detail

### Add Expense
- Full-screen form: title, amount, date picker, category dropdown
- Input validation with inline error messages
- On save: generates UUID client-side, persists via Drift, pops back to Home

### Transaction Detail
- Displays full expense information: title, category, amount, date
- Edit button navigates to Edit Expense
- Delete button with confirmation dialog

### Edit Expense
- Same form as Add, pre-filled with existing data
- Fetches data by ID from the reactive stream — always shows latest state
- Preserves original `id` and `createdAt` on update

### Settings
- Dark mode toggle — persists choice via SharedPreferences
- Applies immediately via `ThemeCubit` without app restart

---

## Background

Flutter specialist with experience in fintech and capital markets, including production trading applications and modular package development. Day-to-day work is primarily API-driven — this assignment was a deliberate exploration of local persistence patterns using Drift and Clean Architecture.