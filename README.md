# Gym Capo

An AI personal gym advisor. It logs your workouts, food, weight, and steps, and coaches you from that data.

**Status:** early development. See [docs/PLAN.md](docs/PLAN.md) for the roadmap.

| Part | Stack |
|---|---|
| `backend/` | Laravel · PHP · MySQL · Redis (queues, cache) · Sanctum |
| `mobile/` | Flutter · Dart · BLoC/Cubit · go_router |
| `evals/` | Automated checks on every AI feature: grounding, safety, structured output |
