# Task Manager
# 📋 Task Manager App - Full-Stack CRUD Module in Flutter

## Overview
This project is a Task Manager app built in Flutter, showcasing full CRUD functionality with offline-first support, using SQLite for local persistence and RESTful APIs  for remote sync. The app follows clean architecture with the BLoC pattern for state management and ensures responsive UI, robust error handling, and a modern Flutter development approach.

## Features

- Add, view, update, and delete tasks 
- Remote API integration 
- Offline support via SQLite
- Real-time UI updates
- Optimistic updates with fallback
- Responsive design
- Clean Architecture (Data, Domain, Presentation)
- State management using flutter_bloc
- Error and network failure handling

 ## Libraries Used

- **flutter_bloc**: Enables reactive data handling with Cubits or Blocs to respond to user events and API/database changes.
- **sqllite**: Enables offline-first capability by caching tasks locally when the app is offline or API fails.
- **http**: Handles RESTful API integration for syncing tasks with a remote server (e.g., Firebase or MockAPI).

## Clean Architecture

Clean Architecture is a software design philosophy that separates the concerns of an application into layers, each with a specific responsibility. The layers typically include:

1. **Presentation Layer**: Handles UI-related logic and interacts with the BLoC layer.
2. **Domain Layer**: Contains business logic, usecase,entities .
3. **Data Layer**: Manages data access, including interactions with local and remote data sources.

The separation of concerns makes the codebase modular, scalable, and easy to maintain. Clean Architecture promotes testability and allows for the flexibility to change one layer without affecting others.

## Code Pattern: BLoC

BLoC is a state management pattern widely used in Flutter applications. It stands for Business Logic Component and separates the presentation layer from the business logic. Key components of the BLoC pattern include:

- **BLoC**: Manages the state of the application and contains business logic.
- **States**: Represent the state of the UI at a specific point in time.

BLoC simplifies the UI by removing business logic, making the application more modular and testable. It also provides a clear separation between the UI and business logic.


## Getting Started

Follow these instructions to get a copy of the project up and running on your local machine.

### Prerequisites

- Flutter installed on your machine ([Installation Guide](https://flutter.dev/docs/get-started/install))
- Emulator or physical device for testing

### Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/zahra-choksi/Task_app.git
2. Change into the project directory:

   ```bash
    cd tasks
3. Install dependencies:

    ```bash
    flutter pub get
4. Run the app:

    ```bash
   flutter run

### 🔗 API Endpoints Documentation

Api i have used :- https://68243c0d65ba0580339963f8.mockapi.io/task_app

## 📄 Usage Instructions

- Launch the app to fetch tasks from the remote API.
- If offline, tasks are retrieved from local SQLite.
- Add/edit tasks through the form page.
- Swipe to delete tasks with confirmation.
- Tasks are automatically synced when online.

## 🔧 Technical Implementation Highlights

- Database: SQLite with sqflite, transactions, indexes
- API: MockAPI via http package
- Offline-first: Local DB used when API fails
- BLoC Pattern: Modular and scalable state handling

## 🔍 Bonus Features Implemented

- search functionality with Flutter's debounce for better performance

##  Developer Info

- Name: Zahra Choksi 
- Assignment: Flutter Full Stack CRUD Module
- Submitted:  14  May 2025



