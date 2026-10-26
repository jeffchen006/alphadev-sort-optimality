# n=5 model=out iset=I1 prefix14_class=6231
mov S2, P0
mov S0, P1
cmp P0, P2
cmovg S2, P2
cmovle P0, P2
cmp P3, P1
cmovg P1, P3
cmovg P3, S0
cmp P0, P1
cmovg S0, P1
cmovg P1, P0
mov P1, S2
cmovg P0, S0
mov P2, P0
