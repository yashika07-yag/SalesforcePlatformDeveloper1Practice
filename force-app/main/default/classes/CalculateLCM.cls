public class CalculateLCM {
    public static Integer findHCF(Integer a, Integer b){

        integer x = Math.abs(a);
        integer y = Math.abs(b);

        while(y != 0){
            integer temp = y;
            y = Math.mod(x,y);
            x = temp;
        }

        return x;

    }

    public static void findLCM(Integer a, Integer b){

        Integer hcf = findHCF(a,b);
        integer lcm = Math.abs(a*b) / hcf;

        System.debug('HCF of ' + a + ' and ' + b + ' is: '+hcf);
        System.debug('LCM of ' + a + ' and ' + b + ' is: '+lcm);



    }
}