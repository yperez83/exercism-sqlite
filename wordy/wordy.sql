WITH RECURSIVE 
-- 1. Create the Word Bank dictionary
word_bank(synonym, standard_op) AS (
    VALUES 
        ('plus', 'add'),
        ('add', 'add'),
        ('minus', 'subtract'),
        ('subtracted', 'subtract'),
        ('multiplied', 'multiply'),
        ('times', 'multiply'),
        ('divided', 'divide'),
        ('over', 'divide')
),
parser AS (
    -- Base case
    SELECT 
        rowid,
        CASE 
            WHEN question = 'What is?' THEN 'syntax error'
            WHEN question NOT LIKE 'What is %?' THEN 'unknown operation'
            ELSE NULL 
        END as err,
        CASE 
            WHEN question LIKE 'What is %?' AND question != 'What is?' THEN 
                -- Note: Multi-word phrases still need to be collapsed into single words
                -- here so the space-splitting recursion works properly.
                REPLACE(REPLACE(SUBSTR(question, 9, LENGTH(question) - 9), 'multiplied by', 'multiplied'), 'divided by', 'divided') || ' '
            ELSE '' 
        END as remain,
        0 as val,
        'add' as current_op, -- Initialize with the standard operation 'add'
        'num' as expected
    FROM wordy

    UNION ALL

    -- Recursive step
    SELECT 
        rowid,
        -- Error Handling
        CASE 
            WHEN expected = 'num' AND (SUBSTR(remain, 1, INSTR(remain, ' ') - 1) = '' OR CAST(SUBSTR(remain, 1, INSTR(remain, ' ') - 1) AS INTEGER) || '' != SUBSTR(remain, 1, INSTR(remain, ' ') - 1)) THEN 'syntax error'
            WHEN expected = 'op' AND CAST(SUBSTR(remain, 1, INSTR(remain, ' ') - 1) AS INTEGER) || '' = SUBSTR(remain, 1, INSTR(remain, ' ') - 1) THEN 'syntax error'
            -- Use the Word Bank to validate the operation!
            WHEN expected = 'op' AND SUBSTR(remain, 1, INSTR(remain, ' ') - 1) NOT IN (SELECT synonym FROM word_bank) THEN 'unknown operation'
            ELSE NULL
        END as err,
        SUBSTR(remain, INSTR(remain, ' ') + 1) as remain,
        
        -- Next calculated value
        CASE 
            WHEN expected = 'num' AND (CAST(SUBSTR(remain, 1, INSTR(remain, ' ') - 1) AS INTEGER) || '' = SUBSTR(remain, 1, INSTR(remain, ' ') - 1)) THEN
                CASE current_op
                    -- Now we evaluate based on standardized operation names, not user input
                    WHEN 'add' THEN val + CAST(SUBSTR(remain, 1, INSTR(remain, ' ') - 1) AS INTEGER)
                    WHEN 'subtract' THEN val - CAST(SUBSTR(remain, 1, INSTR(remain, ' ') - 1) AS INTEGER)
                    WHEN 'multiply' THEN val * CAST(SUBSTR(remain, 1, INSTR(remain, ' ') - 1) AS INTEGER)
                    WHEN 'divide' THEN val / CAST(SUBSTR(remain, 1, INSTR(remain, ' ') - 1) AS INTEGER)
                END
            ELSE val
        END as val,
        
        -- Next operation to apply: Look up the synonym in the Word Bank and return the standard op
        CASE 
            WHEN expected = 'op' THEN (SELECT standard_op FROM word_bank WHERE synonym = SUBSTR(remain, 1, INSTR(remain, ' ') - 1)) 
            ELSE current_op 
        END as current_op,
        
        -- Toggle expected token state (num -> op -> num -> op)
        CASE WHEN expected = 'num' THEN 'op' ELSE 'num' END as expected
    FROM parser
    WHERE remain != '' AND err IS NULL
),
terminal AS (
    SELECT 
        rowid,
        CASE 
            WHEN err IS NULL AND expected = 'num' THEN 'syntax error'
            ELSE err
        END as final_err,
        val as final_val
    FROM parser
    WHERE remain = '' OR err IS NOT NULL
)

-- Finally, update the table
UPDATE wordy 
SET result = (SELECT final_val FROM terminal WHERE terminal.rowid = wordy.rowid AND final_err IS NULL),
    error = (SELECT final_err FROM terminal WHERE terminal.rowid = wordy.rowid AND final_err IS NOT NULL);