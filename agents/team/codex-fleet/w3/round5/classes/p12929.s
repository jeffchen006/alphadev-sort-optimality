# n=5 model=out iset=I1 prefix14_class=12929
cmp P2, P1
mov S1, P0
cmovg S0, P1
cmovg P1, P2
cmovg P2, S0
cmp P3, S1
cmovg S1, P3
cmovle P0, P3
cmp P0, P2
mov S2, P2
cmovg S2, P0
cmovle P2, P0
mov P2, S1
cmp P1, S1
