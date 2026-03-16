# Data Layer

The data layer is inside:

features/feature_name/model/

It contains:

models/
repositories/
services/

Models

- Represent structured data
- Implement fromJson() and toJson()

Repositories

- Bridge between Cubit and services
- Transform raw responses into models

Flow:

Cubit → Repository → Service

Services

- Communicate with APIs or local sources
- Must not contain business logic