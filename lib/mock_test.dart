

void main(){
  int num = 12345678;
  int d = 0;
  String ds = "aboceddddeee";
  int length = num.toString().length;
  while(length>0){
    int digit = num % 10;
    d = d * 10 + digit;
    //print(d);
    num = (num / 10).toInt();
    print(num);
    length--;
  }
  print(d);
  var input = ds.split('').toSet().join();
  print(input);
}
