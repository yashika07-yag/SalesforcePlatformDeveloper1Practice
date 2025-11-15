public class CalculateHCF {
    public static void Calculation(Integer a, Integer b)
    {
        if(a==0 || b==0){
            System.debug('Enter a valid number.');
            return;
        }
        Integer x = Math.abs(a);
        Integer y = Math.abs(b);

        while(y != 0){
            integer temp = y;
            y = Math.mod(x,y);
            x = temp;
        }
        System.debug('HCF of ' + a + ' and ' + b + ' is: ' + x);
    }
}