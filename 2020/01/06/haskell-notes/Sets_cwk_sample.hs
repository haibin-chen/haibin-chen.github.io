module Coursework where

{-
  Your task is to design a datatype that represents the mathematical concept of a (finite) set of elements (of the same type).
  We have provided you with an interface (do not change this!) but you will need to design the datatype and also 
  support the required functions over sets.
  Any functions you write should maintain the following invariant: no duplication of set elements.

  There are lots of different ways to implement a set. The easiest is to use a list
  (as in the example below). Alternatively, one could use an algebraic data type,
  wrap a binary search tree, or even use a self-balancing binary search tree.
  Extra marks will be awarded for efficient implementations (a self-balancing tree will be
  more efficient than a linked list for example).

  You are NOT allowed to import anything from the standard library or other libraries.
  Your edit of this file should be completely self-contained.

  DO NOT change the type signatures of the functions below: if you do,
  we will not be able to test them and you will get 0% for that part. While sets are unordered collections,
  we have included the Ord constraint on most signatures: this is to make testing easier.

  You may write as many auxiliary functions as you need. Please include everything in this file.
-}

{-
   PART 1.
   You need to define a Set datatype. Below is an example which uses lists internally.
   It is here as a guide, but also to stop ghci complaining when you load the file.
   Free free to change it.
-}

-- you may change this to your own data type
{- newtype Set a = Set { unSet :: [a] } -}


data Set a = Empty | Set (a, Set a) deriving (Eq, Ord, Read, Show)

{- simple definition : have not dealt with repeated values -}
fromList :: [a] -> Set a
fromList []     = Empty
fromList (x:xs) = Set (x, fromList xs)

{- so you can write a unique function 'unique' and merge two function together such as 'where' keyword -}
unique :: Eq a => [a] -> [a]
unique [] = []
unique (x:xs)   | x `elem` xs   = unique xs
                | otherwise     = x : unique xs

{- simple definition : have not sorted -}
toList :: Set a -> [a]
toList Empty = []
toList (Set(first, restofset)) = first:toList(restofset)

{- so you can write a quicksort function and merge two function together such as 'where' keyword -}

{- some set's function implementation -}
empty :: (Eq a) => Set a -> Bool
empty s = s == Empty

{- if-then-else or guard from -}
inSet :: (Eq a) => a -> Set a -> Bool
inSet a Empty = False
inSet a (Set (value, set)) = if (value == a)
                        then True
                        else (inSet a set)

insert :: (Eq a) => a -> Set a -> Set a
insert a (Set (value, set)) = if (inSet a (Set (value, set)) == False)
                               then Set(a, Set (value, set))
                               else (Set (value, set))
                               
{- of course if you define set by a list you can write like this
insert x (Set xs) | x `elem` xs = Set xs
                  | otherwise   = Set (x:xs)
-}

{-
   PART 2.
   If you do nothing else, at least get the following two functions working. They
   are required for testing purposes.
-}

-- toList {2,1,4,3} => [1,2,3,4]
-- the output must be sorted.

{-

toList :: Set a -> [a]
toList a = undefined

-- fromList [2,1,1,4,5] => {2,1,4,5}
fromList :: Ord a => [a] -> Set a
fromList = undefined


{-
   PART 3.
   Your Set should contain the following functions.
   DO NOT CHANGE THE TYPE SIGNATURES.
-}

-- test if two sets have the same elements.
instance (Ord a) => Eq (Set a) where
  s1 == s2 = undefined


-- the empty set
empty :: Set a
empty = undefined


-- Set with one element
singleton :: a -> Set a
singleton = undefined


-- insert an element of type a into a Set
-- make sure there are no duplicates!
insert :: (Ord a) => a -> Set a -> Set a
insert = undefined


-- join two Sets together
-- be careful not to introduce duplicates.
union :: (Ord a) => Set a -> Set a -> Set a
union = undefined


-- return the common elements between two Sets
intersection :: (Ord a) => Set a -> Set a -> Set a
intersection = undefined


-- all the elements in Set A *not* in Set B,
-- {1,2,3,4} `difference` {3,4} => {1,2}
-- {} `difference` {0} => {}
difference :: (Ord a) => Set a -> Set a -> Set a
difference = undefined


-- is element *a* in the Set?
member :: (Ord a) => a -> Set a -> Bool
member = undefined


-- how many elements are there in the Set?
cardinality :: Set a -> Int
cardinality = undefined


setmap :: (Ord b) => (a -> b) -> Set a -> Set b
setmap = undefined


setfoldr :: (a -> b -> b) -> Set a -> b -> b
setfoldr = undefined


-- powerset of a set
-- powerset {1,2} => { {}, {1}, {2}, {1,2} }
powerSet :: Set a -> Set (Set a)
powerSet = undefined


-- cartesian product of two sets
cartesian :: Set a -> Set b -> Set (a, b)
cartesian = undefined


-- partition the set into two sets, with
-- all elements that satisfy the predicate on the left,
-- and the rest on the right
partition :: (a -> Bool) -> Set a -> (Set a, Set a)
partition = undefined

-}

{-
   On Marking:
   Be careful! This coursework will be marked using QuickCheck, against Haskell's own
   Data.Set implementation. Each function will be tested for multiple properties.
   Even one failing test means 0 marks for that function.

   Marks will be lost for too much similarity to the Data.Set implementation.

   Pass: creating the Set type and implementing toList and fromList is enough for a
   passing mark of 40%.

   The maximum mark for those who use lists, as in the example above, is 70%. To achieve
   a higher grade than is, one must write a more efficient implementation.
   100% is reserved for those brave few who write their own self-balancing binary tree.
-}
