Date[] dates;

void loadDates() {
  File root_folder = new File(ROOT);
  ArrayList<Date> _dates = new ArrayList<Date>();
  for (File year_folder : root_folder.listFiles()) {
    if (!year_folder.isDirectory()) continue;
    int year = int(year_folder.getName());
    if (year == 0) continue; // "thumbnails" folder
    for (File month_folder : year_folder.listFiles()) {
      if (!month_folder.isDirectory()) continue;
      int month = int(month_folder.getName().substring(0, 2));
      _dates.add(new Date(year, month));
    }
  }
  dates = new Date[0];
  dates = _dates.toArray(dates);
}

class Date {
  int year; 
  int month; 
  Date(int _year, int _month) {
    if (_month <= 0 || _month > 12) throw new IllegalArgumentException("month not in range 1-12");
    this.year = _year; 
    this.month = _month;
  }

  final String[] MONTHS  = new String[] {"Janvier", "Février", "Mars", "Avril", "Mai", "Juin", "Juillet", "Août", "Septembre", "Octobre", "Novembre", "Décembre"};
  final String[] MONTHS_ = new String[] {"Janvier", "Fevrier", "Mars", "Avril", "Mai", "Juin", "Juillet", "Aout", "Septembre", "Octobre", "Novembre", "Decembre"};

  String toString() {
    return MONTHS[month - 1] + " " + str(year);
  }

  String folderLocation() {
    return str(year) + "/" + nf(month, 2) + "-" + MONTHS_[month - 1];
  }
}
