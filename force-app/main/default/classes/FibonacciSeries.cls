public class FibonacciSeries {
    
    public static void printFibonacci(Integer n) {
        
        if (n == null || n <= 0) {
            System.debug('No terms to print.');
            return;
        }
        if (n >= 1) System.debug(0 + ' ');
        if (n >= 2) System.debug(1 + ' ');

        Integer a = 0, b = 1, c;
        for (Integer i = 2; i < n; i++) {
            c = a + b;
            System.debug(c + ' ');
            a = b;
            b = c;
        }
    }
}
