class StringModificationHelper{


  static String addLeadingZero (String number){
    if(number.trim().length == 1){
      return '0$number';
    }else{
      return number;
    }
  }

}