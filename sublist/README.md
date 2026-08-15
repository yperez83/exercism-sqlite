# Sublist

Given any two lists, `A` and `B`, determine their relational status.

---

## Instructions

Your task is to determine if:
*   **Equal:** List `A` is equal to list `B` (both lists have the same values in the same order).
*   **Superlist:** List `A` contains list `B` (A contains a contiguous sub-sequence of values equal to B).
*   **Sublist:** List `A` is contained by list `B` (B contains a contiguous sub-sequence of values equal to A).
*   **Unequal:** None of the above are true.

### Inputs
The `list_one` and `list_two` columns contain JSON-encoded lists of integers (e.g., `[1, 2, 3]`).

### Examples

| List A (`list_one`) | List B (`list_two`) | Expected Result |
| :--- | :--- | :--- |
| `[]` | `[]` | **Equal** |
| `[1, 2, 3]` | `[]` | **Superlist** |
| `[]` | `[1, 2, 3]` | **Sublist** |
| `[1, 2, 3]` | `[1, 2, 3, 4, 5]` | **Sublist** |
| `[3, 4, 5]` | `[1, 2, 3, 4, 5]` | **Sublist** |
| `[3, 4]` | `[1, 2, 3, 4, 5]` | **Sublist** |
| `[1, 2, 3]` | `[1, 2, 3]` | **Equal** |
| `[1, 2, 3, 4, 5]` | `[2, 3, 4]` | **Superlist** |
| `[1, 2, 4]` | `[1, 2, 3, 4, 5]` | **Unequal** |
| `[1, 2, 3]` | `[1, 3, 2]` | **Unequal** |

---

## Schema

```sql
CREATE TABLE sublist (
    list_one TEXT NOT NULL,     -- json array
    list_two TEXT NOT NULL,     -- json array
    result   TEXT
);
