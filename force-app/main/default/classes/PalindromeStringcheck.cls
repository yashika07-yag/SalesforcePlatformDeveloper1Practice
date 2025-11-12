public class PalindromeStringcheck{

    public static void CheckPalindrome(String str){
        if(String.isBlank(str)){
            System.debug('Please enter a valid string to check');
            
        }
        str = str.tolowercase();
        integer left = 0;
        integer right = str.length() - 1;
        boolean ispalindrome = true;

        while(left < right){
            if(str.substring(left,left+1) != str.substring(right,right+1)){
                ispalindrome = false;
                break;
            }
            left++;
            right--;

        }
        if(ispalindrome){
            System.debug('The string " '+ str +' " is a palindrome');
        }
        else{
            System.debug('The string " '+ str +' " is NOT a palindrome');
        }

    }
}