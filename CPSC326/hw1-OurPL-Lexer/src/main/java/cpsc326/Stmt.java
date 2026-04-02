package cpsc326;

abstract class Stmt {
    interface Visitor<R> {
        R visitPrintStatement(Stmt.Print stmt);  //review dis!!
        R visitExpressionStatement(Stmt.Expression stmt);
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

    abstract <R> R accept(Visitor <R> visitor);
}
