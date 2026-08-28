# GRIND — find your coach

A mobile app where anyone can create, share and follow workouts, and talk to a coach directly.

**Author:** Einer-Alexander Igumnov
**Supervisor:** Maria Petranevskaya
**Contact:** [@einer_igumnov](https://t.me/einer_igumnov)

## Problem

Fitness bloggers spend time and money building their own websites and apps just to publish their training programs. Every coach ends up with a separate, isolated product.

At the same time, there's no single place where thousands of workouts created by different people are collected together. If you want to follow a specific coach — Noel Deyzel, Spartak, or a local trainer — you have to hunt down whatever platform they happened to build.

GRIND is that shared place: one app for publishing workouts and one app for finding them.

## Goals

- Build a mobile app for creating and sharing workouts
- Add authentication
- Let users message coaches inside the app

## Tech stack

| Technology | What it is |
|---|---|
| **Dart** | Programming language created by Google |
| **Flutter** | Google's framework for building Android, iOS and web apps from one codebase |
| **Firebase** | Google's set of cloud backend services |
| **Android Studio** | Google's IDE for Android development |

## Architecture

### Data storage — Cloud Firestore

Firestore is a NoSQL document database built for automatic scaling, high performance and fast app development.

Every object in the app — a workout, an exercise, a training plan, a user — gets a randomly generated `id`. All of the object's fields are stored exactly once, and everything that references it stores only the `id` and resolves the object through it. This keeps data non-duplicated and consistent: editing a workout updates it everywhere it appears.

### Files — File Picker + Cloud Storage

Users pick images from their device with the **File Picker** package. The file is uploaded to **Cloud Storage**, a powerful, simple and cost-effective file storage service.

Once uploaded, the file is available over a plain `GET` request by URL — and that URL is what gets written into the relevant database fields. The database stores links, not blobs.

### Authentication — Firebase Authentication + Google Sign In

Firebase Authentication makes it straightforward to build a secure auth system while keeping sign-up and sign-in easy for the end user. **Google Sign In** is used as the provider: simple, secure and familiar to almost everyone.

Why not a custom auth system? All user data used by the app lives in the database anyway — Google Sign In only handles the security and convenience of logging in, so there's nothing to gain from rolling my own.

## Features

- **Sign in with Google** — one-tap entry, no password to manage
- **Explore** — search across training plans and people
- **Training plans** — a plan holds an ordered list of workouts, with an author, a cover image and a description
- **Workouts** — each has a name, cover image, calorie and duration estimate, and a list of exercises
- **Workout builder** — create a workout, pick a wallpaper, set Kcal and minutes, add exercises
- **Training mode** — step through a workout exercise by exercise with a progress bar, per-exercise sets, reps and weight
- **Chat** — message a coach and share a training plan straight into the conversation
- **Profile** — your training plans, workouts and exercises in one place, with likes and view counts

## Screens

Sign in · Explore · Chat · Create Training Plan · Training plan view · Create Training · Training mode · Profile
