# MVVM Migration Plan

The auth flow (`LoginView`, `RegisterView`) and home experience (`HomeView`, `HomeDashboardView`) now demonstrate the target MVVM pattern. Apply the same structure to the remaining screens using the checklist below.

## General Checklist

1. **Move UI widgets** into `lib/View/<feature>_view.dart`. Keep Widgets stateless when possible and delegate all state/async work to the ViewModel.
2. **Create a matching ViewModel** under `lib/ViewModel/<feature>_view_model.dart` that extends `BaseViewModel`. Expose controllers, derived state, and async operations via methods/getters.
3. **Wire the view** with `ChangeNotifierProvider` (or `MultiProvider` if a screen needs more than one ViewModel). Use `context.watch<T>()` for reactive values and `context.read<T>()` for event handlers.
4. **Handle navigation + messaging** inside ViewModels. Views should only call ViewModel methods.
5. **Dispose controllers** (text fields, focus nodes, animations) in the ViewModel’s `dispose()` override.
6. **Update routes/imports** so the app references the new files. For backward compatibility you can leave the old `*_page.dart` files as thin wrappers that export/extend the new views.

## Screen-by-Screen Notes

| Screen | View file | ViewModel focus |
| --- | --- | --- |
| Account / Profile related (`account_details_page.dart`, `profile_page.dart`, `privacy_security_page.dart`, `notification_settings_page.dart`) | `View/account_details_view.dart`, etc. | Form controllers, validation, toggles, API hooks for saving preferences. Extract SnackBar/toast logic.
| Pets (`pet_profile_page.dart`, `pet_detail_page.dart`, `add_pet_page.dart`) | `View/pet_profile_view.dart`, ... | Loading pet data, handling add/edit workflows, media pickers, navigation to detail/edit. Keep gallery grids purely UI.
| Scheduling (`calendar_page.dart`, `schedule_detail_page.dart`, `add_schedule_page.dart`) | `View/calendar_view.dart`, ... | Move calendar data sources, filtering, and reminder creation logic to ViewModels. Let View trigger provider methods for month changes.
| Scanning (`scan_page.dart`, `scan_history_page.dart`, `custom_camera_page.dart`) | `View/scan_view.dart`, ... | Manage camera state, permissions, ML results, history filtering. ViewModels should expose status enums and event handlers for capture/upload.
| Misc screens (`help_faq_page.dart`, `feedback_page.dart`, `scan_history_page.dart`) | `View/<name>_view.dart` | Handle list/data fetching, submission logic, and user feedback via ViewModels.

## Implementation Order

1. **High-traffic flows**: scan experience + pet profile pages (they contain logic that benefits most from MVVM separation).
2. **Settings/preferences** screens – quick wins to build momentum.
3. **Remaining informational pages** – mostly wiring controllers + placeholder async calls.

Following this roadmap will keep the codebase consistent and make unit-testing business logic straightforward.
