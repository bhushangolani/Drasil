{-# LANGUAGE RankNTypes #-}
module Language.Drasil.Expr.Extract(dep, vars, codevars, codevars', toVC) where

import Data.List (nub)
import Control.Lens hiding ((:<),(:>))
import Prelude hiding (id)
import Language.Drasil.Expr (Expr(..), UFunc(..), BiFunc(..), Quantifier(..))
import Language.Drasil.Chunk (Chunk, id)
import Language.Drasil.Chunk.VarChunk (VarChunk(..), vc', makeVC)
import Language.Drasil.Space  -- need this for code generation
import Language.Drasil.ChunkDB
import Language.Drasil.Misc (symbol)

import Language.Drasil.NounPhrase -- temporary until Expr can constrain Quantity without circular import
import Language.Drasil.Chunk.Code

--FIXME: Missing Patterns
-- | Get dependencies from an equation  
dep :: Expr -> [String]
dep (a :/ b)      = nub (dep a ++ dep b)
dep (a :* b)      = nub (dep a ++ dep b)
dep (a :+ b)      = nub (dep a ++ dep b)
dep (a :^ b)      = nub (dep a ++ dep b)
dep (a :- b)      = nub (dep a ++ dep b)
dep (a :. b)      = nub (dep a ++ dep b)
dep (a :&& b)     = nub (dep a ++ dep b)
dep (a :|| b)     = nub (dep a ++ dep b)
dep (Deriv _ a b) = nub (dep a ++ dep b)
dep (Not e)       = dep e
dep (Neg e)       = dep e
dep (C c)         = [c ^. id]
dep (Int _)       = []
dep (Dbl _)       = []
dep (Bln _)       = []
dep (V _)         = []
dep (FCall f x)   = nub (dep f ++ (concat $ map dep x))
dep (Case ls)     = nub (concat $ map (dep . fst) ls ++ map (dep . snd) ls)
dep (a := b)      = nub (dep a ++ dep b)
dep (a :!= b)     = nub (dep a ++ dep b)
dep (a :< b)      = nub (dep a ++ dep b)
dep (a :> b)      = nub (dep a ++ dep b)
dep (a :>= b)     = nub (dep a ++ dep b)
dep (a :<= b)     = nub (dep a ++ dep b)
dep (UnaryOp u)   = dep (unpack u)
dep (Grouping e)  = dep e
dep (BinaryOp b)  = nub (concat $ map dep (binop b))
dep (a :=>  b)    = nub (dep a ++ dep b)
dep (a :<=> b)    = nub (dep a ++ dep b)
dep (IsIn  a _)   = nub (concat $ map dep a)
dep (NotIn a _)   = nub (concat $ map dep a)
dep (State a b)   = nub ((concat $ map (dep . quant) a) ++ dep b)
dep (Matrix a)    = nub (concat $ map (concat . map dep) a)
dep (Index a i)   = nub (dep a ++ dep i)

-- | Get a list of VarChunks from an equation in order to print
vars :: (HasSymbolTable s) => Expr -> s -> [VarChunk]
vars (a :/ b)     m = nub (vars a m ++ vars b m)
vars (a :* b)     m = nub (vars a m ++ vars b m)
vars (a :+ b)     m = nub (vars a m ++ vars b m)
vars (a :^ b)     m = nub (vars a m ++ vars b m)
vars (a :- b)     m = nub (vars a m ++ vars b m)
vars (a :. b)     m = nub (vars a m ++ vars b m)
vars (a :&& b)    m = nub (vars a m ++ vars b m)
vars (a :|| b)    m = nub (vars a m ++ vars b m)
vars (Deriv _ a b) m = nub (vars a m ++ vars b m)
vars (Not e)      m = vars e m
vars (Neg e)      m = vars e m
vars (C c)        m = [toVC c m]
vars (Int _)      _ = []
vars (Dbl _)      _ = []
vars (Bln _)      _ = []
vars (V _)        _ = []
vars (FCall f x)  m = nub (vars f m ++ (concat $ map (\y -> vars y m) x))
vars (Case ls)    m = nub (concat $ map (\x -> vars (fst x) m) ls ++ map (\x -> vars (snd x) m) ls)
vars (a := b)     m = nub (vars a m ++ vars b m)
vars (a :!= b)    m = nub (vars a m ++ vars b m)
vars (a :> b)     m = nub (vars a m ++ vars b m)
vars (a :< b)     m = nub (vars a m ++ vars b m)
vars (a :<= b)    m = nub (vars a m ++ vars b m)
vars (a :>= b)    m = nub (vars a m ++ vars b m)
vars (UnaryOp u)  m = vars (unpack u) m
vars (Grouping e) m = vars e m
vars (BinaryOp b) m = nub (concat $ map (\x -> vars x m) (binop b))
vars (a :=>  b)   m = nub (vars a m ++ vars b m)
vars (a :<=> b)   m = nub (vars a m ++ vars b m)
vars (IsIn  a _)  m = nub (concat $ map (\x -> vars x m) a)
vars (NotIn a _)  m = nub (concat $ map (\x -> vars x m) a)
vars (State a b)  m = nub ((concat $ map (\x -> vars (quant x) m) a) ++ vars b m)
vars (Matrix a)   m = nub (concat $ map (\x -> concat $ map (\y -> vars y m) x) a)
vars (Index a i)  m = nub (vars a m ++ vars i m)

-- | Get a list of CodeChunks from an equation
codevars :: (HasSymbolTable s) => Expr -> s -> [CodeChunk]
codevars (a :/ b)     sm = nub (codevars a sm ++ codevars b sm)
codevars (a :* b)     sm = nub (codevars a sm ++ codevars b sm)
codevars (a :+ b)     sm = nub (codevars a sm ++ codevars b sm)
codevars (a :^ b)     sm = nub (codevars a sm ++ codevars b sm)
codevars (a :- b)     sm = nub (codevars a sm ++ codevars b sm)
codevars (a :. b)     sm = nub (codevars a sm ++ codevars b sm)
codevars (a :&& b)    sm = nub (codevars a sm ++ codevars b sm)
codevars (a :|| b)    sm = nub (codevars a sm ++ codevars b sm)
codevars (Deriv _ a b) sm = nub (codevars a sm ++ codevars b sm)
codevars (Not e)      sm = codevars e sm
codevars (Neg e)      sm = codevars e sm
codevars (C c)        sm = [codevar $ makeVC (c ^. id) (pn "") (symbol (symbLookup c (sm ^. symbolTable)))]
codevars (Int _)      _ = []
codevars (Dbl _)      _ = []
codevars (Bln _)      _ = []
codevars (V _)        _ = []
codevars (FCall f x)  sm = nub (codevars f sm ++ (concat $ map (\y -> codevars y sm) x))
codevars (Case ls)    sm = nub (concat $ map (\x -> codevars (fst x) sm) ls ++ map (\x -> codevars (snd x) sm) ls)
codevars (a := b)     sm = nub (codevars a sm ++ codevars b sm)
codevars (a :!= b)    sm = nub (codevars a sm ++ codevars b sm)
codevars (a :> b)     sm = nub (codevars a sm ++ codevars b sm)
codevars (a :< b)     sm = nub (codevars a sm ++ codevars b sm)
codevars (a :<= b)    sm = nub (codevars a sm ++ codevars b sm)
codevars (a :>= b)    sm = nub (codevars a sm ++ codevars b sm)
codevars (UnaryOp u)  sm = codevars (unpack u) sm
codevars (Grouping e) sm = codevars e sm
codevars (BinaryOp b) sm = nub (concat $ map (\x -> codevars x sm) (binop b))
codevars (a :=>  b)   sm = nub (codevars a sm ++ codevars b sm)
codevars (a :<=> b)   sm = nub (codevars a sm ++ codevars b sm)
codevars (IsIn  a _)  sm = nub (concat $ map (\x -> codevars x sm) a)
codevars (NotIn a _)  sm = nub (concat $ map (\x -> codevars x sm) a)
codevars (State a b)  sm = nub ((concat $ map (\x -> codevars (quant x) sm) a) ++ codevars b sm)
codevars (Matrix a)   sm = nub (concat $ map (concat . map (\x -> codevars x sm)) a)
codevars (Index a i)  sm = nub (codevars a sm ++ codevars i sm)
codevars (Len a)      sm = nub (codevars a sm)
codevars (Append a b) sm = nub (codevars a sm ++ codevars b sm) 


-- | Get a list of CodeChunks from an equation (no functions)
codevars' :: (HasSymbolTable s) => Expr -> s -> [CodeChunk]
codevars' (a :/ b)     sm = nub (codevars' a sm ++ codevars' b sm)
codevars' (a :* b)     sm = nub (codevars' a sm ++ codevars' b sm)
codevars' (a :+ b)     sm = nub (codevars' a sm ++ codevars' b sm)
codevars' (a :^ b)     sm = nub (codevars' a sm ++ codevars' b sm)
codevars' (a :- b)     sm = nub (codevars' a sm ++ codevars' b sm)
codevars' (a :. b)     sm = nub (codevars' a sm ++ codevars' b sm)
codevars' (a :&& b)    sm = nub (codevars' a sm ++ codevars' b sm)
codevars' (a :|| b)    sm = nub (codevars' a sm ++ codevars' b sm)
codevars' (Deriv _ a b) sm = nub (codevars' a sm ++ codevars' b sm)
codevars' (Not e)      sm = codevars' e sm 
codevars' (Neg e)      sm = codevars' e sm 
codevars' (C c)        sm = [codevar $ makeVC (c ^. id) (pn "") (symbol $ symbLookup c (sm ^. symbolTable))]
codevars' (Int _)       _ = []
codevars' (Dbl _)       _ = []
codevars' (Bln _)       _ = []
codevars' (V _)         _ = []
codevars' (FCall _ x)  sm = nub (concat $ map (\y -> codevars' y sm) x)
codevars' (Case ls)    sm = nub (concat $ map (\x -> codevars' (fst x) sm) ls ++
                              map (\y -> codevars' (snd y) sm) ls)
codevars' (a := b)     sm = nub (codevars' a sm ++ codevars' b sm)
codevars' (a :!= b)    sm = nub (codevars' a sm ++ codevars' b sm)
codevars' (a :> b)     sm = nub (codevars' a sm ++ codevars' b sm)
codevars' (a :< b)     sm = nub (codevars' a sm ++ codevars' b sm)
codevars' (a :<= b)    sm = nub (codevars' a sm ++ codevars' b sm)
codevars' (a :>= b)    sm = nub (codevars' a sm ++ codevars' b sm)
codevars' (UnaryOp u)  sm = codevars' (unpack u) sm
codevars' (Grouping e) sm = codevars' e sm
codevars' (BinaryOp b) sm = nub (concat $ map (\x -> codevars' x sm) (binop b))
codevars' (a :=>  b)   sm = nub (codevars' a sm ++ codevars' b sm)
codevars' (a :<=> b)   sm = nub (codevars' a sm ++ codevars' b sm)
codevars' (IsIn  a _)  sm = nub (concat $ map (flip codevars' sm) a)
codevars' (NotIn a _)  sm = nub (concat $ map (flip codevars' sm) a)
codevars' (State a b)  sm = nub ((concat $ map (\x -> codevars' (quant x) sm) a) ++
                              codevars' b sm)
codevars' (Matrix a)   sm = nub (concat $ map (concat . map (\x -> codevars' x sm)) a)
codevars' (Index a i)  sm = nub (codevars' a sm ++ codevars' i sm)
codevars' (Len a)      sm = nub (codevars' a sm)
codevars' (Append a b) sm = nub (codevars' a sm ++ codevars' b sm) 


-- | Helper function for vars and dep, gets the Expr portion of a UFunc
unpack :: UFunc -> Expr
unpack (Log e) = e
unpack (Summation _ e) = e
unpack (Abs e) = e
unpack (Norm e) = e
unpack (Integral _ e _) = e
unpack (Sin e) = e
unpack (Cos e) = e
unpack (Tan e) = e
unpack (Sec e) = e
unpack (Csc e) = e
unpack (Cot e) = e
unpack (Product _ e) = e
unpack (Exp e) = e
unpack (Sqrt e) = e

-- | Helper function for vars and dep, gets Exprs from binary operations.
binop :: BiFunc -> [Expr]
binop (Cross e f) = [e,f]

-- | Helper function for vars and dep, gets Exprs from Quantifier
quant :: Quantifier -> Expr
quant (Forall e) = e
quant (Exists e) = e

-- Steven edit:  need this to have a type for code generation
--   setting to all to rational
-- | Convert any chunk to a VarChunk as long as it is an instance of SymbolForm.
-- Again, used for printing equations/descriptions mostly.
toVC :: (Chunk c, HasSymbolTable s) => c -> s -> VarChunk
toVC c m = vc' (lookupC) (symbol lookupC) (Rational)
  where lookupC = symbLookup c (m ^. symbolTable)
