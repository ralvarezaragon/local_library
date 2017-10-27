SELECT ~0 as max_bigint_unsigned
,      ~0 >> 32 as max_int_unsigned
,      ~0 >> 40 as max_mediumint_unsigned
,      ~0 >> 48 as max_smallint_unsigned
,      ~0 >> 56 as max_tinyint_unsigned
,      ~0 >> 1  as max_bigint_signed
,      ~0 >> 33 as max_int_signed
,      ~0 >> 41 as max_mediumint_signed
,      ~0 >> 49 as max_smallint_signed
,      ~0 >> 57 as max_tinyint_signed
\G