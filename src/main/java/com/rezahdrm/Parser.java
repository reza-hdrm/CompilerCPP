package CompilerDesign;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

public class Parser {

    private int token;
    private char tokenChar;
    private String tokenText;
    private Scanner scanner;

    public Parser(String srcFile) throws IOException {
        scanner = new Scanner(new BufferedReader(new FileReader(srcFile)));
        setTokenOptions();
        program();
    }

    private void program() throws IOException {
        if (token == Scanner.CLASS)
            classDec();
        if (token == Scanner.ID) {
            assignment();
            match(Scanner.SEMICOLON);
            /*if (token == Scanner.ID) program();*/
        }
        varDec();
        //methodDec();
        if (token != Scanner.ERROR)
            program();
    }

    private void classDec() throws IOException {
        match(Scanner.CLASS);
        id();
        if (token == Scanner.COLON)
            extend();
        classBlock();
    }

    private void classBlock() throws IOException {
        match(Scanner.LBRACE);
        if (token == Scanner.DATATYPE) {
            varDec();
        } else if (token == Scanner.ID) {
            assignment();
            match(Scanner.SEMICOLON);
        } else if (token == Scanner.ACCEMOD) {
            match(Scanner.ACCEMOD);
            match(Scanner.COLON);
        }
        //else if()

        match(Scanner.RBRACE);
    }

    private void extend() throws IOException {
        match(Scanner.COLON);
        match(Scanner.ACCEMOD);
        id();
    }

    private void methodDec() throws IOException {
        if (token != Scanner.LPAREN) {
            Type();
            id();
        }
        match(Scanner.LPAREN);
        if (token == Scanner.DATATYPE)
            method_list();
        match(Scanner.RPAREN);
        block();
    }

    private void block() throws IOException {
        match(Scanner.LBRACE);
        while (true) {
            String firstStatement = "if|do|while|for|return|break|continue";
            if (token == Scanner.DATATYPE) {
                varDec();
            } else if (tokenChar == '{') {
                block();
            } else if (tokenText.matches(firstStatement) || token == Scanner.ID) {
                statement();
            } else
                break;
        }
        match(Scanner.RBRACE);
    }

    private void statement() throws IOException {
        switch (token) {
            case Scanner.ID:
                assignment();
                match(Scanner.SEMICOLON);
                break;
            case Scanner.IF:
                match(Scanner.IF);
                match(Scanner.LPAREN);
                expr();
                match(Scanner.RPAREN);
                block();
                if (token == Scanner.ELSE) {
                    block();
                    block();
                }
                break;
            case Scanner.DO:
                match(Scanner.DO);
                block();
                match(Scanner.WHILE);
                match(Scanner.LPAREN);
                expr();
                match(Scanner.RPAREN);
                match(Scanner.SEMICOLON);
                break;
            case Scanner.FOR:
                match(Scanner.FOR);
                match(Scanner.LPAREN);
                if (token == Scanner.ID)
                    assignment();
                match(Scanner.SEMICOLON);
                if (token == Scanner.ID)
                    expr();
                match(Scanner.SEMICOLON);
                if (token == Scanner.ID)
                    assignment();
                match(Scanner.RPAREN);
                if (token == Scanner.LBRACE) block();
                break;
            case Scanner.RETURN:
                match(Scanner.RETURN);
                expr();
                match(Scanner.SEMICOLON);
                break;
            case Scanner.CIN:
                match(Scanner.CIN);
                match(Scanner.RSHIFT);
                id();
                match(Scanner.SEMICOLON);
                break;
            case Scanner.COUT:
                match(Scanner.COUT);
                match(Scanner.LSHIFT);
                if (token == Scanner.ID) id();
                else if (token == Scanner.LITERAL) num();
                match(Scanner.SEMICOLON);
                break;
        }
    }

    private void assignment() throws IOException {
        id();
        if (tokenText.matches("[+*/%-]?[=]")) {
            match(Scanner.OPERATION);
            expr();
        } else if (tokenText.matches("[+]{2}|[-]{2}"))
            match(Scanner.OPERATION);
        else syntaxError();
    }

    private void method_list() throws IOException {
        Type();
        id();
        if (tokenChar == '=') {
            match(Scanner.OPERATION);
            expr();
        }
        if (token == Scanner.COMMA) {
            match(Scanner.COMMA);
            method_list();
        }
    }

    private void varDec() throws IOException {
        Type();
        varList();
        if (token == Scanner.LPAREN)
            methodDec();
        else {
            if (token == Scanner.LBRACE1) {
                array();
            }
            match(Scanner.SEMICOLON);
        }
    }

    private void array() throws IOException {
        match(Scanner.LBRACE1);
        if (tokenText.matches("[1-9]*"))
            match(Scanner.LITERAL);
        match(Scanner.RBRACE1);
        if (token == Scanner.LBRACE1) array();
    }

    private void varList() throws IOException {
        id();
        if (tokenText.matches("[+/*%-]?[=]")) {
            match(Scanner.OPERATION);
            expr();
        }
        if (token == Scanner.COMMA) {
            match(Scanner.COMMA);
            varList();
        }
    }

    private void expr() throws IOException {
        if (tokenChar == '-' || tokenChar == '!') {
            match(Scanner.OPERATION);
            expr();
        } /*else if (token == Scanner.LITERAL || token == Scanner.ID || token == Scanner.LPAREN) {
            term();
            expr1();
        }*/ else if (token == Scanner.ID) {
            id();
            if (token == Scanner.LPAREN)
                methodCall();
            else if (token == Scanner.OPERATION) {
                match(Scanner.OPERATION);
                expr();
            }
        } else if (token == Scanner.LITERAL)
            num();
        else if (token == Scanner.LPAREN) {
            match(Scanner.LPAREN);
            expr();
            match(Scanner.RPAREN);
            if (token == Scanner.OPERATION) {
                match(Scanner.OPERATION);
                expr();
            }
        } else
            syntaxError();
    }

    private void expr1() throws IOException {
        if (tokenText.matches("[-+]")) {
            match(Scanner.OPERATION);
            term();
            expr1();
        } else if (tokenText.matches("[+><!]|>=|<=|==|!=|&&|'/|/|'")) {
            match(Scanner.OPERATION);
            term();
            expr1();
        } else return;
    }

    private void term() throws IOException {
        num();
        term1();
    }

    private void term1() throws IOException {
        if (tokenText.matches("[*/%]")) {
            match(Scanner.OPERATION);
            num();
            term1();
        } else return;
    }

    private void num() throws IOException {
        if (token == Scanner.LITERAL)
            match(Scanner.LITERAL);
        else if (token == Scanner.ID) {
            match(Scanner.ID);
            if (token == Scanner.LPAREN) methodCall();
        } else if (token == Scanner.LPAREN) {
            match(Scanner.LPAREN);
            expr();
            match(Scanner.RPAREN);
        }
    }

    private void methodCall() throws IOException {
        //id();
        match(Scanner.LPAREN);
        if (token != Scanner.RPAREN)
            parameterList();
        match(Scanner.RPAREN);
    }

    private void parameterList() throws IOException {
        expr();
        if (token == Scanner.COMMA) {
            match(Scanner.COMMA);
            parameterList();
        }
    }

    private void id() throws IOException {
        if (tokenText.matches("[*&]?[_a-zA-Z][\\w]*"))
            match(Scanner.ID);
        else syntaxError();
    }

    private void Type() throws IOException {
        if (tokenText.matches("int|long|float|double|string|char|bool"))
            match(Scanner.DATATYPE);
        else syntaxError();
    }

    private void match(int t) throws IOException {
        if (token == t)
            setTokenOptions();
        else
            syntaxError();
    }

    private void setTokenOptions() throws IOException {
        token = scanner.yylex();
        tokenChar = scanner.yycharat(0);
        tokenText = scanner.yytext();
        log();
    }

    private void syntaxError() {
        throw new Error("[line:" + (scanner.getYyline() + 1) + ",column:" + (scanner.getYycolumn() + 1) + "] character:" + "\'" + tokenChar + "\'" + " : " + "Syntax Error");
    }

    private void log() {
        System.out.println(token + " " + tokenText);
    }
}
