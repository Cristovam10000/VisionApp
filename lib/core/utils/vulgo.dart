String obterVulgo(Map<dynamic, dynamic>? ficha) {
  return ficha?['vulgo'] ??
      (ficha?['ficha_criminal'] is Map
          ? (ficha!['ficha_criminal'] as Map)['vulgo'] ??
              ((ficha['ficha_criminal'] as Map)['ficha_criminal'] is Map
                  ? ((ficha['ficha_criminal'] as Map)['ficha_criminal']
                      as Map)['vulgo']
                  : null)
          : null) ??
      'Sem Vulgo';
}
