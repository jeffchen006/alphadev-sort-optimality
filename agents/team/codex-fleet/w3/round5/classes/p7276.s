# n=5 model=out iset=I1 prefix14_class=7276
cmp P2, P3
mov S0, P3
mov S1, P1
cmovg S0, P2
cmovle P3, P2
cmp P0, S1
cmovle P1, P0
cmovle P0, S1
cmp P1, P3
cmovge P2, P1
cmovg P1, P3
cmovge P3, P2
cmp P0, S0
cmovge P1, S0
