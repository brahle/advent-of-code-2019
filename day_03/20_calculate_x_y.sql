DROP TABLE IF EXISTS calculated_xy;

CREATE TABLE calculated_xy AS
    SELECT
        steps_x + steps_y AS steps_after,
        steps_x + steps_y - ABS(dx) - ABS(dy) AS steps_before,
        *
    FROM (
        SELECT
            test_case,
            line,
            element,
            nr,
            dx,
            dy,
            SUM(dx) OVER w - dx AS start_x,
            SUM(dx) OVER w AS end_x,
            SUM(ABS(dx)) OVER w AS steps_x,
            SUM(dy) OVER w - dy AS start_y,
            SUM(dy) OVER w AS end_y,
            SUM(ABS(dy)) OVER w AS steps_y
        FROM
            exploded_input
        WINDOW
            w AS (
                PARTITION BY test_case, line
                ORDER BY nr
                RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
            )
    ) AS _
;
