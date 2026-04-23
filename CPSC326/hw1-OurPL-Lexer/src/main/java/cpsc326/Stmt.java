package cpsc326;

import java.util.List;

abstract class Stmt {
    interface Visitor<R> {
        R visitPrintStatement(Stmt.Print stmt);  //review dis!!
        R visitExpressionStatement(Stmt.Expression stmt);
        R visitBlockStatement(Stmt.Block stmt);
        R visitVarStatement(Stmt.Var stmt);
        R visitIfStatement(Stmt.If stmt);
        R visitWhileStatement(Stmt.While stmt);
    }

    static class Function extends Stmt{
        Token name;
        List<Token> params;
        List<Stmt> body;

        Function(Token name, List<Token> params, List<Stmt> body){
            this.name = name;
            this.params = params;
            this.body = body;
        }
    }

    static class Block extends Stmt {
        final List<Stmt> statements;

        Block(List<Stmt> statements){
            this.statements = statements;
        }

        @Override
        <R> R accept(Visitor<R> visitor){
            return visitor.visitBlockStatement(this);
        }

    }
    
    static class Expression extends Stmt {
        final Expr expression;

        Expression(Expr expr) {
            expression = expr;
        }

        @Override
        <R> R accept(Visitor<R> visitor){
            return visitor.visitExpressionStatement(this);
        }
    }

    static class If extends Stmt {
        If(Expr condition, Stmt thenBranch, Stmt elseBranch){
            this.condition = condition;
            this.thenBranch = thenBranch;
            this.elseBranch = elseBranch;
        }

        @Override
        <R> R accept(Visitor<R> visitor) {
            return visitor.visitIfStatement(this);
        }

        final Expr condition;
        final Stmt thenBranch;
        final Stmt elseBranch;
    }

    static class Print extends Stmt {
        final Expr expression;
        Print(Expr expr) {
            expression = expr;
        }

        @Override
        <R> R accept(Visitor<R> visitor)
        {
            return visitor.visitPrintStatement(this);
        }
    }

    static class Var extends Stmt {
        Var(Token name, Expr initializer){
            this.name = name;
            this.initializer = initializer;
        }

        @Override
        <R> R accept(Visitor<R> visitor) {
            return visitor.visitVarStatement(this);
        }
        
        final Token name;
        final Expr initializer;
    }

    static class While extends Stmt {
        While(Expr condition, Stmt body){
            this.condition = condition;
            this.body = body;
        }

        @Override
        <R> R accept(Visitor<R> visitor) {
            return visitor.visitWhileStatement(this);
        }

        final Expr condition;
        final Stmt body;

    }



    abstract <R> R accept(Visitor <R> visitor);
}
