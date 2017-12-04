import java.io.*;

/**
 * 基数変換クラス(演習問題1.70)
 *
 * Integerクラスの、
 * parseInt(String s, int radix), 
 * valueOf(String s, int radix), 
 * toString(int i, int radix)
 * を使うのは問題の趣旨に合わないので使わない。
 *
 * ただし、Integer#parseInt(String s)で、基数の値を解釈するのは、問題ないとする。
 */
public class BaseConverter {
    BufferedReader in = new BufferedReader(new InputStreamReader(System.in));

    public static void main(String[] args) {
	try {
	    BaseConverter converter = new BaseConverter();
	    
	    while (true) {
		converter.convert();
	    }
	} catch (Exception e) {
	    e.printStackTrace();
	}
    }

    public void convert() throws IOException {
	/*
	 * ユーザーに入力を求める。
	 */
	String sourceBaseStr = getSourceBase();
	String destBaseStr = getDestBase();
	String numStr = getNumber();

	if (sourceBaseStr == null || destBaseStr == null || numStr == null) {
	    // 入力が尽きたら終了する。
	    System.exit(0);
	}

	convertBase(sourceBaseStr, destBaseStr, numStr);
    }

    public void convertBase(String sourceBaseStr, String destBaseStr, String numStr) throws IOException {
	// 入力値の基数を文字列から、int型に変換。
	int sourceBase = strToBaseInt(sourceBaseStr);
	int destBase = strToBaseInt(destBaseStr);

	StringReader numReader = new StringReader(numStr);

	int num = parseNumber(numStr, sourceBase);
	printNumber(num, destBase);
    }

    /**
     * 指定された基数で、文字列を数値に変換します。
     *
     * @param numStr 変換したい文字列。[0-9A-Fa-f]の文字が許可されます。
     * @param base   変換するときの基数。
     */
    public int parseNumber(String numStr, int base) throws IOException {
	Reader numReader = new StringReader(numStr);
	
	int num = 0;
	int c;
	while ((c = numReader.read()) != -1) {
	    int oneDigit;
	    if ('0' <= c && c <= '9') {
		oneDigit = c - '0';
	    } else if ('A' <= c && c <= 'F') {
		oneDigit = c - 'A' + 10;
	    } else if ('a' <= c && c <= 'f') {
		oneDigit = c - 'a' + 10;
	    } else {
		throw new IllegalArgumentException(
		    "Invalid source digit: " + (char)c + ". Input 0-9, A-F, a-f.");
	    }

	    if (oneDigit >= base) {
		throw new IllegalArgumentException(
		   "Digit is out of source base: " + oneDigit + ".");
	    }
		
	    num = num * base + oneDigit;
	}

	return num;
    }

    /**
     * 指定された基数で数値を表示します。
     *
     * @param num 表示する数値
     * @param base 基数
     */
    public void printNumber(int num, int base) {
	/*
	 * 基数変換のやり方通りに、逆順で数字を文字列化。
	 */
	StringBuilder str = new StringBuilder();
	while (num > 0) {
	    int oneDigit = num % base;
	    if (oneDigit <= 9) {
		str.append((char)(oneDigit + '0'));
	    } else if (oneDigit <= 15) {
		str.append((char)((oneDigit - 10) + 'A'));
	    } else {
		throw new IllegalArgumentException(
			"Invalid base for output: " + base + ".");
	    }

	    num /= base;
	}

	if (str.length() == 0) {
	    // 0の時は、空文字列になってしまうので、0を出力
	    System.out.println("0");
	} else {
	    System.out.println(str.reverse());
	}
    }

    /** 
     * 変換元の基数の入力させます。
     */
    public String getSourceBase() throws IOException {
	prompt("source base ?");
	return in.readLine();
    }

    /**
     * 変換先の基数の入力をさせます。
     */
    public String getDestBase() throws IOException {
	prompt("destination base ?");
	return in.readLine();
    }

    /**
     * 変換元の数値を入力させます。
     */
    public String getNumber() throws IOException {
	prompt("number ?");
	return in.readLine();
    }

    /**
     * 基数の文字列を数値型に変換します。
     */
    public int strToBaseInt(String str) {
	int base = Integer.parseInt(str);
	if (base < 2 || 16 < base) {
	    throw new IllegalArgumentException("Invalic base: " + str + ". base is 2 - 16.");
	}

	return base;
    }

    /**
     * プロンプトを表示します。
     */
    public void prompt(String msg) {
	System.out.print(msg + " : ");
    }
}
