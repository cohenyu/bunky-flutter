class Categories{
  Map categoryToValueMap(){
    return {
      'Supermarket' : 1,
      'Water Bill' : 2,
      'Electric Bill': 3,
      'Rates': 4,
      'Building Committee' : 5,
      'Internet' : 6,
      'Other': 7
    };
  }

  Map valueToCategoryMap(){
    return {
      1: 'Supermarket',
      2: 'Water Bill',
      3: 'Electric Bill',
      4: 'Rates',
      5: 'Building Committee',
      6: 'Internet',
      7: 'Other'
    };
  }
}