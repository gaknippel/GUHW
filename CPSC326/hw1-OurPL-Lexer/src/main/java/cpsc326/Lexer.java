package cpsc326;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static cpsc326.TokenType.AND;
import static cpsc326.TokenType.ELSE;
import static cpsc326.TokenType.EOF;
import static cpsc326.TokenType.FALSE;
import static cpsc326.TokenType.FOR;
import static cpsc326.TokenType.FUN;
import static cpsc326.TokenType.IF;
import static cpsc326.TokenType.NIL;
import static cpsc326.TokenType.OR;
import static cpsc326.TokenType.PRINT;
import static cpsc326.TokenType.RETURN;
import static cpsc326.TokenType.STRUCT;
import static cpsc326.TokenType.THIS;
import static cpsc326.TokenType.TRUE;
import static cpsc326.TokenType.VAR;
import static cpsc326.TokenType.WHILE;

class Lexer {
    private final String source;
    private final List<Token> tokens = new ArrayList<>();
    private int start = 0;
    private int current = 0;
    private int line = 1;
    private static final Map<String, TokenType> keywords;

    Lexer(String source) {
        this.source = source;
    }

    static {
        keywords = new HashMap<>();
        keywords.put("and", AND);
        keywords.put("or", OR);
        keywords.put("struct", STRUCT);
        keywords.put("else", ELSE);
        keywords.put("false", FALSE);
        keywords.put("true", TRUE);
        keywords.put("for", FOR);
        keywords.put("fun", FUN);
        keywords.put("if", IF);
        keywords.put("nil", NIL);
        keywords.put("print", PRINT);
        keywords.put("return", RETURN);
        keywords.put("this", THIS);
        keywords.put("while", WHILE);
        keywords.put("var", VAR);

        // TODO: add keywrods 
        
    }

    List<Token> scanTokens() {
        while (!isAtEnd()) {
            start = current;
            scanToken();
        }

        tokens.add(new Token(EOF, "", null, line));
        return tokens;
    }

    private boolean isAtEnd() {
        return current >= source.length();
    }

    private char advance() {
        return source.charAt(current++);
    }

    private boolean match(char expected) {
        if (isAtEnd()) return false;
        if (source.charAt(current) != expected) return false;
        current++;
        return true;
    }

    private char peek() {
        if (isAtEnd()) return '\0';
        return source.charAt(current);
    }

    private char peekNext() {
        if (current + 1 >= source.length()) return '\0';
        return source.charAt(current + 1);
    }

     private boolean isDigit(char c) {
        return c >= '0' && c <= '9';
    }

    private boolean isAlpha(char c) {
        return (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z');
    }

    private boolean isAlphaNumeric(char c) {
        return c == '_' || isAlpha(c) || isDigit(c);
    }

    private void addToken(TokenType type) {
        addToken(type,null);
    }

    private void addToken(TokenType type, Object literal) {
        String text = source.substring(start, current);
        tokens.add(new Token(type, text, literal, line));
    }

    private void string() {
        // TODO: implement string()
    }

    private void number() {
        // TODO: implement number()
    }

    private void identifier() {
        // TODO: implement identifier()
    }

    private void scanToken() {
        



        // TODO: implement scanToken()
    }
}
