# n=5 model=out iset=I1 prefix14_class=11365
mov S2, P3
cmp P0, P2
mov S0, P2
cmovle P2, P0
cmovle P0, S0
cmp P3, P1
cmovg S2, P1
cmovle P3, P1
cmp P3, P0
cmovg S1, P0
cmovg P0, P3
cmovg P3, S1
mov P1, S2
mov S0, P3
