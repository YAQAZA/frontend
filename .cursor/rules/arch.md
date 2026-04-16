# Architecture Overview

This project follows MVVM architecture with Cubit state management in Flutter.

Dependency flow:

View (UI)
↓
Cubit (ViewModel)
↓
Repository
↓
Service
↓
ApiConsumer
↓
HTTP Client / Local Data Source

Rules:

- UI must not contain business logic
- Cubits must not call services directly
- Services must not call HTTP libraries directly
- Each layer only communicates with the layer directly below it