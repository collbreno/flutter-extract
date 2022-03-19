# extract
This is a flutter mobile app to help in personal financial control.

## Clean Architecture
The project was divided in three layers, trying to follow the Clean Architecture purposed by Uncle Bob.

### Business Layer
This is the core of the application. It contains the business objects and the business logics. It should not depend on other layers and should not know about their inner implementation.
It's mainly divided in two things:
- Use cases: All the actions that can be done in the app. It accesses the repository in the infrastructure layer by dependency inversion.
- Entities: The representation of an object.
The business layer also contains the repository interface.

### Insfrastructure Layer
This layer is responsible only for having the implementation of the repository defined in the business layer. In this project, this layer uses [Drift database](https://drift.simonbinder.eu/) to locally store all the data used in the application.

### UI Layer
This is the layer responsible for presenting the application to the user. To encapsulate the presentation logic, this layers uses [BLoC](https://bloclibrary.dev/#/). 

## Running the app
### Step 1: Setup the business layer
On the business folder, run:
```
flutter pub get
flutter pub run build_runner build
```

### Step 2: Setup the infrastructure layer
On the infrastructure folder, run:
```
flutter pub get
flutter pub run build_runner build
```

### Step 3: Run application
On the ui folder, run:
```
flutter pub get
flutter run
```

