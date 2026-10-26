# n=5 model=out iset=I1 prefix14_class=14499
cmp P2, P1
cmovg S1, P2
cmovg P2, P1
mov S0, P2
cmovg P1, S1
mov S2, P0
cmp P3, P0
cmovle P0, P3
cmovle P3, S2
cmp P2, P0
cmovle P2, P0
cmovle P0, S0
mov P0, P3
cmp P0, P1
