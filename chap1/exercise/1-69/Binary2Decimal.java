/**
 * 2進数の入力から、10進数を表示する。(演習問題1.69)
 */
class Binary2Decimal {

    public static void main(String[] args) {
	try {
	    int c;

	    int num = 0;
	    prompt();
	    while ((c = System.in.read()) != -1) {
		if (c == '\n') {
		    /*
		     * これまでの入力の結果を表示して、再度入力を促す。
		     */
		    System.out.println(num);
		    
		    num = 0;
		    prompt();
		    continue;
		}

		if (c == '0' || c == '1') {
		    // これまでの入力値を1桁増やして、入力値を足す。
		    num = num * 2 + (c - '0');
		} else {
		    // 2進数の数値以外は入力を受け付けない。エラーからの回復処理が面倒なので、終了する。
		    throw new IllegalArgumentException("Invalid Value: " + (char)c + ". Input 0 or 1.");
		}
	    };
	} catch (Exception e) {
	    e.printStackTrace();
	}
    }

    /**
     * プロンプトを表示します。
     */
    public static void prompt() {
	System.out.print("> ");
    }
}
