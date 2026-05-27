class ScoreEntry {
  final int? value;
  final String? label;
  final bool marked;
  final bool isTachado;
  final String? mode; // 'mano', 'tres_tiros', 'normal'

  ScoreEntry({
    this.value,
    this.label,
    this.marked = false,
    this.isTachado = false,
    this.mode,
  });

  ScoreEntry copyWith({
    int? value,
    String? label,
    bool? marked,
    bool? isTachado,
    String? mode,
  }) {
    return ScoreEntry(
      value: value ?? this.value,
      label: label ?? this.label,
      marked: marked ?? this.marked,
      isTachado: isTachado ?? this.isTachado,
      mode: mode ?? this.mode,
    );
  }

  Map<String, dynamic> toJson() => {
        'value': value,
        'label': label,
        'marked': marked,
        'isTachado': isTachado,
        'mode': mode,
      };

  factory ScoreEntry.fromJson(Map<String, dynamic> json) => ScoreEntry(
        value: json['value'] as int?,
        label: json['label'] as String?,
        marked: json['marked'] as bool? ?? false,
        isTachado: json['isTachado'] as bool? ?? false,
        mode: json['mode'] as String?,
      );

  factory ScoreEntry.empty() => ScoreEntry();
}

class ScoreCard {
  final ScoreEntry balas;
  final ScoreEntry duques;
  final ScoreEntry trenes;
  final ScoreEntry cuadras;
  final ScoreEntry quinas;
  final ScoreEntry senas;
  final ScoreEntry escalera;
  final ScoreEntry full;
  final ScoreEntry poker;
  final ScoreEntry grande;
  final ScoreEntry dormida;

  ScoreCard({
    ScoreEntry? balas,
    ScoreEntry? duques,
    ScoreEntry? trenes,
    ScoreEntry? cuadras,
    ScoreEntry? quinas,
    ScoreEntry? senas,
    ScoreEntry? escalera,
    ScoreEntry? full,
    ScoreEntry? poker,
    ScoreEntry? grande,
    ScoreEntry? dormida,
  })  : balas = balas ?? ScoreEntry.empty(),
        duques = duques ?? ScoreEntry.empty(),
        trenes = trenes ?? ScoreEntry.empty(),
        cuadras = cuadras ?? ScoreEntry.empty(),
        quinas = quinas ?? ScoreEntry.empty(),
        senas = senas ?? ScoreEntry.empty(),
        escalera = escalera ?? ScoreEntry.empty(),
        full = full ?? ScoreEntry.empty(),
        poker = poker ?? ScoreEntry.empty(),
        grande = grande ?? ScoreEntry.empty(),
        dormida = dormida ?? ScoreEntry.empty();

  ScoreCard copyWith({
    ScoreEntry? balas,
    ScoreEntry? duques,
    ScoreEntry? trenes,
    ScoreEntry? cuadras,
    ScoreEntry? quinas,
    ScoreEntry? senas,
    ScoreEntry? escalera,
    ScoreEntry? full,
    ScoreEntry? poker,
    ScoreEntry? grande,
    ScoreEntry? dormida,
  }) {
    return ScoreCard(
      balas: balas ?? this.balas,
      duques: duques ?? this.duques,
      trenes: trenes ?? this.trenes,
      cuadras: cuadras ?? this.cuadras,
      quinas: quinas ?? this.quinas,
      senas: senas ?? this.senas,
      escalera: escalera ?? this.escalera,
      full: full ?? this.full,
      poker: poker ?? this.poker,
      grande: grande ?? this.grande,
      dormida: dormida ?? this.dormida,
    );
  }

  int get total {
    int sum = 0;
    sum += balas.value ?? 0;
    sum += duques.value ?? 0;
    sum += trenes.value ?? 0;
    sum += cuadras.value ?? 0;
    sum += quinas.value ?? 0;
    sum += senas.value ?? 0;
    sum += escalera.value ?? 0;
    sum += full.value ?? 0;
    sum += poker.value ?? 0;
    sum += grande.value ?? 0;
    // Dormida is a special win condition, it does not add points
    return sum;
  }

  int get completedCategoriesCount {
    int count = 0;
    if (balas.marked) count++;
    if (duques.marked) count++;
    if (trenes.marked) count++;
    if (cuadras.marked) count++;
    if (quinas.marked) count++;
    if (senas.marked) count++;
    if (escalera.marked) count++;
    if (full.marked) count++;
    if (poker.marked) count++;
    if (grande.marked) count++;
    if (dormida.marked) count++;
    return count;
  }

  ScoreEntry getEntry(String key) {
    switch (key) {
      case 'balas':
        return balas;
      case 'duques':
        return duques;
      case 'trenes':
        return trenes;
      case 'cuadras':
        return cuadras;
      case 'quinas':
        return quinas;
      case 'senas':
        return senas;
      case 'escalera':
        return escalera;
      case 'full':
        return full;
      case 'poker':
        return poker;
      case 'grande':
        return grande;
      case 'dormida':
        return dormida;
      default:
        throw ArgumentError('Invalid category key: $key');
    }
  }

  ScoreCard copyWithEntry(String key, ScoreEntry? entry) {
    final cleanEntry = entry ?? ScoreEntry.empty();
    switch (key) {
      case 'balas':
        return copyWith(balas: cleanEntry);
      case 'duques':
        return copyWith(duques: cleanEntry);
      case 'trenes':
        return copyWith(trenes: cleanEntry);
      case 'cuadras':
        return copyWith(cuadras: cleanEntry);
      case 'quinas':
        return copyWith(quinas: cleanEntry);
      case 'senas':
        return copyWith(senas: cleanEntry);
      case 'escalera':
        return copyWith(escalera: cleanEntry);
      case 'full':
        return copyWith(full: cleanEntry);
      case 'poker':
        return copyWith(poker: cleanEntry);
      case 'grande':
        return copyWith(grande: cleanEntry);
      case 'dormida':
        return copyWith(dormida: cleanEntry);
      default:
        throw ArgumentError('Invalid category key: $key');
    }
  }

  Map<String, dynamic> toJson() => {
        'balas': balas.toJson(),
        'duques': duques.toJson(),
        'trenes': trenes.toJson(),
        'cuadras': cuadras.toJson(),
        'quinas': quinas.toJson(),
        'senas': senas.toJson(),
        'escalera': escalera.toJson(),
        'full': full.toJson(),
        'poker': poker.toJson(),
        'grande': grande.toJson(),
        'dormida': dormida.toJson(),
      };

  factory ScoreCard.fromJson(Map<String, dynamic> json) => ScoreCard(
        balas: ScoreEntry.fromJson(json['balas'] as Map<String, dynamic>),
        duques: ScoreEntry.fromJson(json['duques'] as Map<String, dynamic>),
        trenes: ScoreEntry.fromJson(json['trenes'] as Map<String, dynamic>),
        cuadras: ScoreEntry.fromJson(json['cuadras'] as Map<String, dynamic>),
        quinas: ScoreEntry.fromJson(json['quinas'] as Map<String, dynamic>),
        senas: ScoreEntry.fromJson(json['senas'] as Map<String, dynamic>),
        escalera: ScoreEntry.fromJson(json['escalera'] as Map<String, dynamic>),
        full: ScoreEntry.fromJson(json['full'] as Map<String, dynamic>),
        poker: ScoreEntry.fromJson(json['poker'] as Map<String, dynamic>),
        grande: ScoreEntry.fromJson(json['grande'] as Map<String, dynamic>),
        dormida: ScoreEntry.fromJson(json['dormida'] as Map<String, dynamic>),
      );
}
