WITH unpacked AS (
    -- Extract: flatten the nested JSON into rows of (rowid, score, letter)
    SELECT 
        etl.rowid AS id,
        CAST(scores.key AS INTEGER) AS score,
        lower(letters.value) AS letter
    FROM etl, 
         json_each(etl.input) AS scores, 
         json_each(scores.value) AS letters
),
sorted AS (
    -- Transform: ensure the letters are sorted alphabetically as requested
    SELECT id, letter, score 
    FROM unpacked
    ORDER BY id, letter
),
repacked AS (
    -- Load: pack the sorted rows back into a single JSON object per rowid
    SELECT id, json_group_object(letter, score) AS result_json
    FROM sorted
    GROUP BY id
)

-- Update the original table
UPDATE etl
SET result = (
    SELECT result_json 
    FROM repacked 
    WHERE repacked.id = etl.rowid
);