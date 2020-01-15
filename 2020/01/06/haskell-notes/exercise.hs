{-
  对于一个秃头的程序员来说 代码the more is better(逃
  以下给出更多的例子供参考与模仿 V0.1
-}







-- Haskell_5_Higher_Order_Function.pdf



-- curried function!
-- Add parentheses to the following function definitions
-- to express the curried nature of the functions used,
-- but preserve the functions' behavior.
abc = ((take) 3) "abcdefg"
triples = (((zip3) "abc") [1,2,3]) [10.0, 12.0, 14.0]
ten = ((*) 5) 2
ten' = (5 *) 2

-- partial application!
-- The makeRecord function below makes triples based on the name, age, and
-- weight information about an individual. Implement the convenience functions
-- below to make specific kinds of records. Use partial application to mention
-- as few variables as possible.

makeRecord :: String -> Int -> Float -> (String, Int, Float)
makeRecord name age weight = (name, age, weight)

namedBob = makeRecord "Bob"
bobAt30Years = namedBob 30
aliceAt30Years = makeRecord "Alice" 30
aged40 = (`makeRecord` 40)
weighs170pt5 x y = makeRecord x y 170.5

-- map!
-- Find all the perfect squares less than 10,000
squares = takeWhile (< 10000) (map (^2) [1..])

-- filter!
-- Find all the proper divisors of 8128. These are the positive
-- integers that divide it evenly and are less than it.
divisors = filter dividesEvenly [1..8127]
  where dividesEvenly n = (8128 `mod` n) == 0

-- lambda function!
-- Write a function to pick out all the numbers in a list greater
-- than a given number
findAllGreaterThan :: Ord a => a -> [a] -> [a]
findAllGreaterThan n = filter (\x -> x > n)

-- fold!
-- Define a function that determines to total area of a list of rectangles
totalArea :: (Num a) => [(a,a)] -> a
totalArea rects = foldl (+) 0 (map area rects)
  where area (l,w) = l*w

-- Define a function that determines if any rectangle in
-- a given list is big. A rectangle is big if its area is greater than 100.
anyBig :: (Num a, Ord a) => [(a,a)] -> Bool
anyBig rects = foldr (||) False (map isBig rects)
  where isBig (l,w) = l * w > 100

-- function composition! use point style!
-- Define a function to find the square of the least multiple
-- of 3 in a list
squareLeastMultiple = (^2) . minimum . filter mult3
  where mult3 x = x `mod` 3 == 0

-- $!
-- Use $ to cut down on the parentheses in
-- the following definitions

first10Squares = take 10 (map (^2) [1..])
someMultiplesOfThree = take 5 (filter (>100) (map (*3) [1..]))
largestBuzzUnder100 = maximum (filter (multipleOf 5) (filter (multipleOf 3) [1..99]))
  where multipleOf n x = x `mod` n == 0

-- answer:
first10Squares = take 10 $ map (^2) [1..]
someMultiplesOfThree = take 5 $ filter (>100) $ map (*3) [1..]
largestBuzzUnder100 = maximum $ filter (multipleOf 5) $ filter (multipleOf 3) [1..99]
  where multipleOf n x = x `mod` n == 0










-- Haskell_6_UserTypes.pdf






-- Define a data type that represents a Complex number:
--   http://en.wikipedia.org/wiki/Complex_number
--   Use Floats simplicity
--

data Complex = Complex Float Float deriving (Show)

-- Define add, sub, mult, and divide for Complex numbers

add :: Complex -> Complex -> Complex
add (Complex a b) (Complex c d) = Complex (a + c) (b + d)

sub :: Complex -> Complex -> Complex
sub (Complex a b) (Complex c d) = Complex (a - c) (b - d)

mult :: Complex -> Complex -> Complex
mult (Complex a b) (Complex c d) = Complex (a*c - b*d) (b*c + a*d)

divide :: Complex -> Complex -> Complex
divide (Complex a b) (Complex c d) = Complex real imaginary
  where real = (a*c + b*d) / denom
        imaginary = (b*c - a*d) / denom
        denom = c*c + d*d


-- Define a set of data types allowing sandwiches to be constructed.
-- A sandwich include a choice of bread (bun or roll), patty (beef,
-- chicke, or veggie) and any numbers of toppings (ketchup, mustard,
-- cheese, lettuce, and tomato).
--
-- When you're done, you should be able to construct a sandwich like this:
--   plain Roll Veggie `with` Cheese `with` Tomato `with` Ketchup
--

data Topping = Ketchup | Mustard | Cheese | Lettuce | Tomato deriving (Show)
data Patty = Beef | Chicken | Veggie deriving (Show)
data Bread = Bun | Roll deriving (Show)
data Sandwich = Sandwich Bread Patty [Topping] deriving (Show)

plain :: Bread -> Patty -> Sandwich
plain b p = Sandwich b p []

with :: Sandwich -> Topping -> Sandwich
with (Sandwich b p ts) t = Sandwich b p (t:ts)


-- Define a function to calculate the damage done (as an int)
-- by a fighter in a fight, at a certain range to their target.
--
--   * A fighter has some amount of strength and is armed in some way.
--   * A sword has a damage value.
--   * A bow has a range value and a damage value.
--   * A fighter armed only fists deals their strength in damage.
--   * A fighter armed with a sword deals their strength + the
--     the damage value for the sword.
--   * A fighter armed with a bow deals the bow's damage value.
--   * A fighter armed with fists or a sword does no damage beyond range 0.
--   * A fighter armed with a bow deals no damage beyond the bow's range.
--

data Weapon = Fists | Sword Int | Bow Range Int
data Strength = Strength Int
data Range = Range Int
data Fighter = Fighter Strength Weapon

damage :: Fighter -> Range -> Int
damage (Fighter (Strength s) Fists) (Range 0) = s
damage (Fighter (Strength s) (Sword w)) (Range 0) = w + s
damage (Fighter _ (Bow (Range r) d)) (Range t) | r >= t = d
damage _ _ = 0

