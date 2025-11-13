import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:kidney_admin/core/extension/json_extension.dart';

class Journal extends Equatable {
  final String title;
  final String? thumbnailImage;
  final HealingPowerWords healingPowerWords;
  final JournalHelps journalHelps;
  final JournalPrompts journalPrompts;
  final JournalExercises journalExercises;

  const Journal({
    required this.title,
    this.thumbnailImage,
    required this.healingPowerWords,
    required this.journalExercises,
    required this.journalPrompts,
    required this.journalHelps,
  });

  @override
  List<Object?> get props => [
    title,
    thumbnailImage,
    healingPowerWords,
    journalHelps,
    journalPrompts,
    journalExercises,
  ];

  Journal copyWith({
    String? title,
    String? thumbnailImage,
    HealingPowerWords? healingPowerWords,
    JournalHelps? journalHelps,
    JournalPrompts? journalPrompts,
    JournalExercises? journalExercises,
  }) {
    return Journal(
      title: title ?? this.title,
      thumbnailImage: thumbnailImage ?? this.thumbnailImage,
      healingPowerWords: healingPowerWords ?? this.healingPowerWords,
      journalHelps: journalHelps ?? this.journalHelps,
      journalPrompts: journalPrompts ?? this.journalPrompts,
      journalExercises: journalExercises ?? this.journalExercises,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'thumbnailImage': thumbnailImage,
      'healingPowerWords': healingPowerWords.toMap(),
      'journalHelps': journalHelps.toMap(),
      'journalPrompts': journalPrompts.toMap(),
      'journalExercises': journalExercises.toMap(),
    };
  }

  factory Journal.fromMap(Map<String, dynamic> map) {
    return Journal(
      title: map.getStringFromJson('title'),
      thumbnailImage: map.getStringOrNullFromJson('thumbnailImage'),
      healingPowerWords: HealingPowerWords.fromMap(
        map.getMapFromJson('healingPowerWords'),
      ),
      journalHelps: JournalHelps.fromMap(map.getMapFromJson('journalHelps')),
      journalPrompts: JournalPrompts.fromMap(
        map.getMapFromJson('journalPrompts'),
      ),
      journalExercises: JournalExercises.fromMap(
        map.getMapFromJson('journalExercises'),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory Journal.fromJson(String source) =>
      Journal.fromMap(json.decode(source) as Map<String, dynamic>);
}

class HealingPowerWords {
  final String title;
  final List<String> paragraphs;

  HealingPowerWords({required this.title, this.paragraphs = const []});

  HealingPowerWords copyWith({String? title, List<String>? paragraphs}) {
    return HealingPowerWords(
      title: title ?? this.title,
      paragraphs: paragraphs ?? this.paragraphs,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'title': title, 'paragraphs': paragraphs};
  }

  factory HealingPowerWords.fromMap(Map<String, dynamic> map) {
    return HealingPowerWords(
      title: map.getStringFromJson('title'),
      paragraphs: map.getStringListFromJson('paragraphs'),
    );
  }
}

class JournalHelps {
  final String title;
  final List<Benefit> benefits;

  JournalHelps({required this.title, this.benefits = const []});

  JournalHelps copyWith({String? title, List<Benefit>? benefits}) {
    return JournalHelps(
      title: title ?? this.title,
      benefits: benefits ?? this.benefits,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'benefits': benefits.map((x) => x.toMap()).toList(),
    };
  }

  factory JournalHelps.fromMap(Map<String, dynamic> map) {
    return JournalHelps(
      title: map.getStringFromJson('title'),
      benefits: List<Benefit>.from(
        map.getMapListFromJson('benefits').map((e) => Benefit.fromMap(e)),
      ),
    );
  }

  @override
  String toString() => "Title: $title, Benefits: $benefits";
}

class JournalPrompts {
  final String title;
  final List<String> prompts;

  JournalPrompts({required this.title, this.prompts = const []});

  JournalPrompts copyWith({String? title, List<String>? prompts}) {
    return JournalPrompts(
      title: title ?? this.title,
      prompts: prompts ?? this.prompts,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'title': title, 'prompts': prompts};
  }

  factory JournalPrompts.fromMap(Map<String, dynamic> map) {
    return JournalPrompts(
      title: map.getStringFromJson('title'),
      prompts: map.getStringListFromJson('prompts').toList(),
    );
  }

  @override
  String toString() => "Title: $title, prompts: $prompts";
}

class JournalExercises {
  final String title;
  final List<JournalExercise> exercises;

  JournalExercises({required this.title, this.exercises = const []});

  JournalExercises copyWith({String? title, List<JournalExercise>? exercises}) {
    return JournalExercises(
      title: title ?? this.title,
      exercises: exercises ?? this.exercises,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'exercises': exercises.map((x) => x.toMap()).toList(),
    };
  }

  factory JournalExercises.fromMap(Map<String, dynamic> map) {
    return JournalExercises(
      title: map.getStringFromJson('title'),
      exercises: List<JournalExercise>.from(
        map
            .getMapListFromJson('exercises')
            .map((e) => JournalExercise.fromMap(e)),
      ),
    );
  }
}

class Benefit {
  final String benefit;
  final String description;

  Benefit({required this.description, required this.benefit});

  Benefit copyWith({String? benefit, String? description}) {
    return Benefit(
      benefit: benefit ?? this.benefit,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'benefit': benefit, 'description': description};
  }

  factory Benefit.fromMap(Map<String, dynamic> map) {
    return Benefit(
      benefit: map.getStringFromJson('benefit'),
      description: map.getStringFromJson('description'),
    );
  }

  @override
  String toString() => "Benefit: $benefit, Desc: $description";
}

class JournalExercise {
  final String title;
  final String description;

  JournalExercise({required this.title, required this.description});

  JournalExercise copyWith({String? title, String? description}) {
    return JournalExercise(
      title: title ?? this.title,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'title': title, 'description': description};
  }

  factory JournalExercise.fromMap(Map<String, dynamic> map) {
    return JournalExercise(
      title: map.getStringFromJson('title'),
      description: map.getStringFromJson('description'),
    );
  }
}
