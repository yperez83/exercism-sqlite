WITH minified AS (
    -- Standardize the JSON strings (removes all arbitrary spaces)
    SELECT 
        rowid AS id,
        json(list_one) AS j1,
        json(list_two) AS j2
    FROM sublist
),
padded AS (
    -- Strip the brackets (starts at index 2, length - 2) and wrap in commas
    SELECT 
        id,
        j1,
        j2,
        ',' || SUBSTR(j1, 2, LENGTH(j1) - 2) || ',' AS s1,
        ',' || SUBSTR(j2, 2, LENGTH(j2) - 2) || ',' AS s2
    FROM minified
)
-- Evaluate the states from most specific to least specific
UPDATE sublist
SET result = CASE
    WHEN j1 = j2 THEN 'equal'
    WHEN j1 = '[]' THEN 'sublist'
    WHEN j2 = '[]' THEN 'superlist'
    WHEN INSTR(s1, s2) > 0 THEN 'superlist'
    WHEN INSTR(s2, s1) > 0 THEN 'sublist'
    ELSE 'unequal'
END
FROM padded
WHERE sublist.rowid = padded.id;