module Language.Drasil.Expr.Math where

import Prelude hiding (id, sqrt)
import Language.Drasil.Symbol
import Language.Drasil.Expr

-- | Smart constructor to take the log of an expression
log :: Expr -> Expr
log = UnaryOp . Log

-- | Smart constructor to take the square root of an expression
sqrt :: Expr -> Expr
sqrt = UnaryOp . Sqrt

-- | Smart constructor to apply sin to an expression
sin :: Expr -> Expr
sin = UnaryOp . Sin

-- | Smart constructor to apply cos to an expression
cos :: Expr -> Expr 
cos = UnaryOp . Cos

-- | Smart constructor to apply tan to an expression
tan :: Expr -> Expr
tan = UnaryOp . Tan

-- | Smart constructor to apply sec to an expression
sec :: Expr -> Expr 
sec = UnaryOp . Sec

-- | Smart constructor to apply csc to an expression
csc :: Expr -> Expr
csc = UnaryOp . Csc

-- | Smart constructor to apply cot to an expression
cot :: Expr -> Expr 
cot = UnaryOp . Cot

-- | Smart constructor for the exponential (base e) function
exp :: Expr -> Expr
exp = UnaryOp . Exp

-- | Smart constructor for the summation, product, and integrals

defint, defsum, defprod :: Symbol -> Expr -> Expr -> Expr -> Expr
int_all, sum_all, prod_all :: Symbol -> Expr -> Expr

defint v low high e = EOp $ Integral (RealDD v (BoundedR low high)) e
int_all v e = EOp $ Integral (All v) e

defsum v low high e = EOp $ Summation (IntegerDD v (BoundedR low high)) e
sum_all v e = EOp $ Summation (All v) e

defprod v low high e = EOp $ Product (IntegerDD v (BoundedR low high)) e
prod_all v e = EOp $ Product (All v) e

-- | Euclidean function : takes a vector and returns the sqrt of the sum-of-squares
euclidean :: [Expr] -> Expr
euclidean = sqrt . sum' . map square

-- | Used by 'euclidean' function (in place of 'sum') to fix representation of computation
sum' :: (Num a, Foldable t) => t a -> a
sum' x = foldr1 (+) x
  
-- | Smart constructor to cross product two expressions
cross :: Expr -> Expr -> Expr
cross e1 e2 = BinaryOp (Cross e1 e2)

square :: Expr -> Expr
square x = x $^ 2

-- some matrix helper functions
m2x2 :: Expr -> Expr -> Expr -> Expr -> Expr
m2x2 a b c d = Matrix [[a,b],[c,d]]

vec2D :: Expr -> Expr -> Expr
vec2D a b    = Matrix [[a],[b]]

dgnl2x2 :: Expr -> Expr -> Expr
dgnl2x2 a d  = m2x2 a (Int 0) (Int 0) d
