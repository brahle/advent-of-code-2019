DROP TABLE IF EXISTS exploded_input;

CREATE TABLE exploded_input AS
    SELECT
        i.test_case,
        i.line,
        a.element,
        a.nr,
        CASE
            WHEN a.element LIKE 'R%' THEN CAST (substring(a.element FROM 2) AS INT)
            WHEN a.element LIKE 'L%' THEN - CAST (substring(a.element FROM 2) AS INT)
            ELSE 0
        END AS dx,
        CASE
            WHEN a.element LIKE 'U%' THEN CAST (substring(a.element FROM 2) AS INT)
            WHEN a.element LIKE 'D%' THEN - CAST (substring(a.element FROM 2) AS INT)
            ELSE 0
        END AS dy,
        0 as x,
        0 as y
    FROM
        input AS i
    LEFT JOIN
        LATERAL
            unnest(string_to_array(i.wire, ','))
            WITH ORDINALITY AS a(element, nr) ON TRUE;

