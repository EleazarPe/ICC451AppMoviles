class Pokemon {
  int id;


  Pokemon({
    required this.id,
  });


  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Pokemon {id: $id}';
  }

}