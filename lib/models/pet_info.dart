class PetInfo {
  const PetInfo({
    this.id,
    required this.name,
    required this.species,
    required this.breed,
    required this.age,
    this.galleryImages = const [],
  });

  final String? id;
  final String name;
  final String species;
  final String breed;
  final String age;
  final List<String> galleryImages;
}
