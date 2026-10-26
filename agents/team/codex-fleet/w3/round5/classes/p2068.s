# n=5 model=out iset=I1 prefix14_class=2068
mov S2, P0
cmp P1, P0
cmovg S2, P1
cmovle P0, P1
cmp P3, P2
cmovg S0, P3
cmovge P3, P2
mov S1, P3
cmovg P2, S0
mov P1, P2
cmp P1, S2
cmovg P1, S2
cmovle P2, S2
mov S2, P1
