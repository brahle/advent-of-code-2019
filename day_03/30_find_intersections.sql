DROP TABLE IF EXISTS intersections;

CREATE TABLE intersections AS
    SELECT
        lsteps_before + ABS(lx0 - x) + ABS(ly0 - y) AS lsteps,
        rsteps_before + ABS(rx0 - x) + ABS(ry0 - y) AS rsteps,
        *
    FROM (
        SELECT
            CASE
                WHEN ldx = 0 THEN lx0
                ELSE rx0
            END AS x,
            CASE
                WHEN ldy = 0 THEN ly0
                ELSE ry0
            END AS y,
            *
        FROM (
            SELECT
                l.test_case,
                l.nr as lnr,
                l.element as lel,
                l.dx AS ldx,
                l.dy AS ldy,
                l.start_x AS lx0,
                l.start_y AS ly0,
                l.end_x AS lx1,
                l.end_y AS ly1,
                l.steps_before AS lsteps_before,
                r.nr as rnr,
                r.element as rel,
                r.dx AS rdx,
                r.dy AS rdy,
                r.start_x AS rx0,
                r.start_y AS ry0,
                r.end_x AS rx1,
                r.end_y AS ry1,
                r.steps_before AS rsteps_before,
                CASE
                    WHEN l.dx <> 0 AND r.dy <> 0 THEN
                        (((l.start_x <= r.start_x) AND (r.start_x <= l.end_x)) OR ((l.end_x <= r.start_x) AND (r.start_x <= l.start_x))) AND
                        (((r.start_y <= l.start_y) AND (l.start_y <= r.end_y)) OR ((r.end_y <= l.start_y) AND (l.start_y <= r.start_y)))
                    WHEN l.dy <> 0 AND r.dx <> 0 THEN
                        (((l.start_y <= r.start_y) AND (r.start_y <= l.end_y)) OR ((l.end_y <= r.start_y) AND (r.start_y <= l.start_y))) AND
                        (((r.start_x <= l.start_x) AND (l.start_x <= r.end_x)) OR ((r.end_x <= l.start_x) AND (l.start_x <= r.start_x)))
                    ELSE FALSE
                END AS intersects
            FROM
                calculated_xy AS l
            JOIN
                calculated_xy AS r
                ON
                    r.test_case = l.test_case AND
                    r.line <> l.line
        ) AS _
        WHERE intersects
    ) inter
;
