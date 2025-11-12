public class ReverseString {
    public static void ReverseString(String str) {

        if(String.isBlank(str)){
            System.debug('Please enter the correct string');
            return;
        }
        String reversedstr = '';
        for(Integer i = str.length()-1;i>=0;i--) {
            reversedstr += str.substring(i,i+1);

        }
        System.debug('Input String: ' + str);
        System.debug('Reversed String: ' + reversedstr);

    }
}