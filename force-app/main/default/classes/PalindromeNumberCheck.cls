public class PalindromeNumberCheck{
    
    public static void checknumber(Integer num){
            if (num == null){
                system.debug('Please enter a valid number.');
                return;
            }

            integer OriginalNum = num;
            integer reversednum = 0;

            while(num > 0)
            {
                integer remainder =  Math.mod(num,10); //get the last digit of the number
                reversednum = (reversednum * 10) + remainder;
                num = num/10;

            }

            if(OriginalNum == reversednum){
                System.debug('The number '+ OriginalNum +' is a palindrome.');
            }
            else{
                System.debug('The number '+ OriginalNum +' is not a palindrome.');
            }
    }
}