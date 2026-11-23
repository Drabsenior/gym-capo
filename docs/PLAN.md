# Gym Capo — Plan

An AI personal gym advisor that knows the user's training, food, weight, steps, and supplements, and coaches from that data instead of generic advice.

## Decisions
- **Platforms:** Android and iOS. Apple Health on iOS, Health Connect on Android, and sample data so the app runs anywhere.
- **Coaching:** AI coach. Human-trainer chat is optional (Phase 8).
- **AI provider:** chosen in Phase 4, behind one interface so a second provider is a small addition.

## Principles
1. **Code computes the numbers; the AI explains them.** Calorie targets, trends, and progression are calculated in code. The model never does the arithmetic.
2. **The AI proposes; the user confirms.** Plans, food estimates, and imported workouts are drafts until saved.
3. **Private by default.** Health data is encrypted at rest. Body photos are private and never sent to the AI. Users can export or delete everything.
4. **Safety is enforced in code.** Calorie targets have a safe floor. Medical red flags or medications get "talk to a doctor". Signs of disordered eating get a supportive response, not coaching.
5. **Everything works without the AI.** Logging and tracking never depend on a model call.

## Features

**Training**
- Exercise library seeded from [wger](https://wger.de) (open data, attribution required).
- Live workout logging: weight × reps per set, the machine, and the variation. Rest timer with a notification when rest ends. Time spent on each machine is recorded.
- Difficulty rating per exercise (Easy → Very hard), which drives next-session weight suggestions.
- Calendar (exportable to the phone calendar) and milestones with progress and notifications.

**Tracking**
- Weight and steps (Apple Health / Health Connect), charted against the goal.
- Food log by text or photo. The AI estimates calories and macros, shown as estimates the user can edit.
- Private body-progress photo timeline with side-by-side comparison.
- Supplement and diet changes, with start and stop dates.

**AI**
- Coach chat. The model reads the user's data through tools (workout history, weight trend, food log, …) and streams its replies.
- Equipment scanner: a photo gives the machine name, muscles, how to use it, mistakes, variations, and video links (cached YouTube results plus a TikTok search deep link).
- Video import: share a TikTok link (official embed plus caption → AI draft workout), or pick a video saved with TikTok's own "Save video" button → frame analysis.
- Form check: film your own set and get feedback.
- Weekly review: volume per muscle, personal records, consistency, weight vs goal, food, and changes that happened alongside supplement or diet changes (correlation, not cause).

## Architecture
```
gym-capo/
  backend/   Laravel API — MySQL, Redis, Horizon, Sanctum
  mobile/    Flutter app — BLoC/Cubit, go_router, dio
  evals/     AI test cases and reports
  docs/      plan, API collection
```

## Phases
Each phase ends with something that runs.

| # | Phase | Done when |
|---|---|---|
| 0 | Setup: Laravel on Sail, Flutter app, CI | The app shows a response from `GET /api/health` |
| 1 | Accounts and profile | Signing up on the phone saves a profile; tests pass |
| 2 | Workouts: library, live session, sets, rest timer, difficulty | A full gym session can be logged with rest notifications |
| 3 | Trackers, calendar, milestones | Weight and steps charts track the goal; a milestone fires |
| 4 | AI coach: tool-using chat, daily plan, push notifications, first evals | "How's my bench progressing?" is answered from real data; evals report |
| 5 | Camera: equipment scanner, food photos, food log | A machine photo returns a how-to; a meal photo returns an editable estimate |
| 6 | Video import and form check | A shared TikTok becomes a startable workout |
| 7 | Body photos, supplements, weekly review | The weekly review reflects real changes; safety evals pass |
| 8 | Human trainer chat (optional) | A trainer and a user can message live |
| 9 | Polish: CI, API docs, README, demo | A new developer can run it in minutes |

## Evals
They grow every phase:
- **Grounding:** every number the AI states must exist in the user's data.
- **Safety:** medical red flags, supplements taken with medication, extreme dieting.
- **Tool use:** the AI calls the right tools.
- **Valid structured output.**
- **Equipment recognition:** accuracy on a labelled photo set.
