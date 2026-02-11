class PetInfo {
  const PetInfo({
    this.id,
    required this.name,
    required this.species,
    required this.breed,
    required this.age,
    this.gender,
    this.colour,
    this.weight,
    this.dateOfBirth,
    this.photoUrl,
    this.galleryImages = const [],
  });

  final String? id;
  final String name;
  final String species;
  final String breed;
  final String age;
  final String? gender;
  final String? colour;
  final String? weight;
  final String? dateOfBirth;
  final String? photoUrl;
  final List<String> galleryImages;
}
