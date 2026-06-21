enum CycleSymptom {
  crampi,
  stanchezza,
  umoreGiu,
  umoreAlto,
  malDiTesta,
  gonfiore,
  spotting,
  libido,
  irritabilita,
  acne,
}

extension CycleSymptomData on CycleSymptom {
  String get label {
    switch (this) {
      case CycleSymptom.crampi:       return 'Crampi';
      case CycleSymptom.stanchezza:   return 'Stanchezza';
      case CycleSymptom.umoreGiu:     return 'Umore basso';
      case CycleSymptom.umoreAlto:    return 'Umore alto';
      case CycleSymptom.malDiTesta:   return 'Mal di testa';
      case CycleSymptom.gonfiore:     return 'Gonfiore';
      case CycleSymptom.spotting:     return 'Spotting';
      case CycleSymptom.libido:       return 'Libido alta';
      case CycleSymptom.irritabilita: return 'Irritabilità';
      case CycleSymptom.acne:         return 'Acne';
    }
  }

  String get emoji {
    switch (this) {
      case CycleSymptom.crampi:       return '😣';
      case CycleSymptom.stanchezza:   return '😴';
      case CycleSymptom.umoreGiu:     return '😔';
      case CycleSymptom.umoreAlto:    return '😊';
      case CycleSymptom.malDiTesta:   return '🤕';
      case CycleSymptom.gonfiore:     return '🫃';
      case CycleSymptom.spotting:     return '🩸';
      case CycleSymptom.libido:       return '🔥';
      case CycleSymptom.irritabilita: return '😤';
      case CycleSymptom.acne:         return '🫧';
    }
  }
}
