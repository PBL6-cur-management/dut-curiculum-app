# General Architecture

Flutter client for the existing curriculum-management API. Each feature separates domain, data, and presentation. Domain is pure Dart; data maps remote DTOs; presentation uses Cubit and Equatable state. get_it and injectable construct collaborators at the composition root.

The core owns a persisted cookie jar, Dio, CSRF headers, session-expiry events, typed failures and an injectable native-file viewer. Auth owns session restoration and password workflows. The shell owns home/profile tabs and non-curriculum placeholders. The curriculum shell owns one semester/program context and route-scoped portal Cubits. Detail providers are keyed by context so a new selection cannot retain stale detail data.

Portal data uses the same cookie-bearing Dio client. Checked JSON DTOs map to immutable domain models; decimals remain strings and dates become epoch-millisecond integers at common edge helpers. Graduation schema gating occurs before current-schema decoding. Display-only credit ratios are validated and clamped without changing source decimals. Downloads use sanitized temporary paths and delete partial files on transport failure.
