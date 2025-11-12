public class PallindromeRegexCheck{
    public static void CheckPallindrome(String str){
        
        if(String.IsBlank(str)){
            System.debug('Enter a valid string');
            return;
        }
        
        str = str.tolowercase();
        str = str.replaceAll('[^a-z0-9]', '');
        
        integer first = 0;
        integer last = str.length() - 1;
        boolean ispalindrome = true;
        

        while(first < last) {
        if(str.substring(first,first+1) != str.substring(last,last+1)){
            ispalindrome = false;
            break;
        }
        first++;
        last--;
    }
    if(ispalindrome){
        System.debug('Text "'+ str + '" is a palindrome');
    }
    else{
        System.debug('Text "'+ str + '" is not a palindrome');
    }
    }
}