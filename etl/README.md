# ETL (Extract, Transform, Load)

Change the data format of letters and their point values in the game Lexiconia to support multiple languages.

---

## Instructions

Currently, letters are stored in groups based on their score, in a one-to-many mapping:

*   **1 point:** "A", "E", "I", "O", "U", "L", "N", "R", "S", "T"
*   **2 points:** "D", "G"
*   **3 points:** "B", "C", "M", "P"
*   **...etc.**

This needs to be extracted, transformed, and loaded into a one-to-one mapping where each individual letter is stored with its score. As part of this change, the letters must be transformed from upper-case to lower-case, and the keys in the result object must be sorted alphabetically.

### Examples

**Input:**
```json
{
  "1": ["A", "E"],
  "2": ["D", "G"]
}
