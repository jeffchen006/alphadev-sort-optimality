# Fixed Ford-Johnson prefix: a=P0 <= b=P1 <= d=P3 and c=P2 <= d.
cmp P0, P1
mov S0, P0
cmovg P0, P1
cmovg P1, S0
cmp P2, P3
mov S1, P2
cmovg P2, P3
cmovg P3, S1
cmp P1, P3
mov S2, P1
mov S3, P0
cmovg P1, P3
cmovg P3, S2
cmovg P0, P2
cmovg P2, S3
