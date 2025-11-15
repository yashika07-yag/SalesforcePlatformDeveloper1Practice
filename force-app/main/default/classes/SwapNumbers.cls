public class SwapNumbers{

    public static void swap(Integer a, Integer b ){

        System.debug('original a = ' + a + 'original b = ' + b);
        a=a+b;
        b=a-b;
        a=a-b;

        System.debug('a = ' + a + 'b = ' + b);

    }
}