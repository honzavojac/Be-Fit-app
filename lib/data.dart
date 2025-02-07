import 'data_classes.dart';

late List<Muscle> sqfliteMuscleList;
late List<Exercise> sqfliteExerciseList;
late List<ExerciseData> sqfliteExerciseDataList;
late List<MySplit> sqfliteSplitList;
late List<SelectedMuscle> sqfliteSelectedMuscleList;
late List<SelectedExercise> sqfliteSelectedExerciseList;
late List<SplitStartedCompleted> sqfliteSplitStartedCompletedList;
late List<Measurements> sqfliteBodyMeasurementsList;
late List<IntakeCategories> sqfliteIntakeCategoriesList;
late List<NutriIntake> sqfliteNutriIntakeList;
late List<Food> sqfliteFoodList;

Map<int, Muscle> muscleMap = {};
Map<int, Exercise> exerciseMap = {};

Map<int, List<SelectedMuscle>> selectedMuscleMap = {};
Map<int, List<int>> selectedExerciseMap = {};
Map<int, List<ExerciseData>> exerciseData = {};

SplitStartedCompleted? splitStartedCompleted;

// late int idkIndex;

// int selectedSplit = 0;
