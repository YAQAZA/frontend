# Cubit Rules

Cubits represent the ViewModel layer.

Location:
features/feature_name/view_model/bloc/

Rules:

- All Cubits must extend Cubit<State>
- States must extend Equatable
- Cubits must only call repositories
- Cubits must not call services or API layers

State examples:

Initial
Loading
Success
Error

Example flow:

UI → Cubit → Repository → Service