# API Consumer Layer

Location:
core/network/

Services must not communicate directly with HTTP libraries.

Instead they must depend on ApiConsumer abstraction.

Architecture:

Service → ApiConsumer → HTTP Client

ApiConsumer must define:

get()
post()
put()
delete()

Example implementations:

DioConsumer
MockApiConsumer
LocalApiConsumer