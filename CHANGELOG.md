# Changelog

## [Unreleased]

## 1.0.0+1 (10 Jun 2026)

### feat
- Add dark mode
- Add core project structure — core/, features/, pages/ layers
- Add AppDatabase with ExpenseTable (Drift) — id, title, amount, date, category, createdAt
- Add ExpenseCategory enum with label and emoji
- Add expense feature boilerplate via generate_feature.sh
- Add Expense entity with full fields
- Add expense_model.dart — Drift extension pattern (toEntity, toCompanion)
- Add ExpenseCubit + ExpenseState — sealed class, 4 states
- Add GetExpenseUseCase
- Add ExpenseRepository interface + ExpenseRepositoryImpl
- Add ExpenseLocalDataSource — Drift queries
- Add GoRouter setup — AppRouter, AppRoutes, AppNavigator, MainShell
- Add bottom navigation — Home, Transactions tabs
- Add app theme — light + dark mode, Material 3
- Add AppTypography — Plus Jakarta Sans
- Add AppColors — brand, semantic, category colors
- Add core error handling — Failure sealed class, Exception classes
- Add CurrencyFormatter — Rupiah format
- Add DateFormatter — Indonesian locale, relative date
- Add DI setup via GetIt — injection_container.dart
- Add FVM config — Flutter 3.44.1

### chore
- Add core package dependencies — drift, flutter_bloc, go_router, get_it, dio, uuid, intl, google_fonts
- Add dev dependencies — drift_dev, build_runner
- Add CHANGELOG.md
- Add .fvmrc
- Update .gitignore

### fix

- Fix Fonts color due light and dark theme
- Fix redundant category widget
- Fix relocate page settings due clean architecture