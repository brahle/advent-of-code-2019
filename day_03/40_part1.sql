SELECT
    test_case,
    MIN(result)
FROM (
    SELECT
        ABS(x) + ABS(y) AS result,
        *
    FROM
        intersections
    WHERE
        x <> 0 OR y <> 0
) candidates
GROUP BY test_case
;
