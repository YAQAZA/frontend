# UI Rules

Location:
features/feature_name/view/

Screens go inside:

view/screen/

Reusable components go inside:

view/screen/widgets/

Rules:

- UI must not contain business logic
- UI must interact only with Cubits
- Extract reusable widgets
- Avoid large build() methods
- Prefer const constructors
- Use ThemeData instead of hardcoded styles