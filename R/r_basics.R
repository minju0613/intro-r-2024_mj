#### R Basics ####
# "A foolish consistency is the hobgoblin of 
#   little minds"   -Ralph Waldo Emerson 

# Literals ----
"this is a string literal" # double quotes preferred in R but not required
42
T
F
TRUE
FALSE

# Operators ----
# Arithmetic
2 + 3 # note the spacing
2+3 # hard to read
2 - 3
2 * 3 # multiplication
2 ** 3 # but be careful: this is an exponent
2 / 3
2 ^ 3 # that's better. squared. 

# Comparison
2 == 2 # tests for equality
"Minju" == "minju" #case-sensitive
"Minju" == "Minju"
2 == 1 + 1 # OK
2 == (1 + 1) # better

2 != 1 # tests inequality

2 < 3 
2 > 3
2 <= 3
2 >= 3

# Somewhat of a cruel joke
TRUE == 1 # TRUE is value as 1
FALSE == 0 # FALSE is value as 0
isTRUE(TRUE) # function testing if the argument is literally TRUE
isTRUE(1) # False
? # queries built-in help
?isTRUE

2 < 3 & 2 > 3 # both have to pass to return TRUE (AND)
2 < 3 | 2 > 3 # either one TRUE, all TRUE (OR)
2 < 3 & (2 == 1 | 2 == 2) # grouping statements for ordering

# type matters (sometimes)
"Minju" # string or character type
typeof("Minju")
42 # numeric type (double precision, floating paint)
typeof(42)
TRUE # logical or Boolean type
typeof(TRUE)

42 == "42" # equality can cross types
identical(42, "42") # type matters for identity

# variables ----
x <- "this is string" # in R, read as assigning the string to variable x
x
typeof(x)
x <- 10
x 
x ^ 2 # always refers to the assigned value

x <- 'pizza'
pizza <- 'x' # variable names can be most anything
pizza
#my var <- 42 # not everything though
my_var <- 42 # that's better
#my_var = 42 # works, but not standard in R
x <- my_var # helps reader follow assignment direction 
x

# data structures ----
# vectors have a single dimension, like a column or row of data

# data frames - the key structure for data science, multi-dimensional
#   collections of vectors


# Special type: factors, and putting it all together ----
# factors are categorical variables with a fixed set of
#   potential values


