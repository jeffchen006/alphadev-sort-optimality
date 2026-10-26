# n=5 model=out iset=I1 prefix14_class=2067
mov S2, P0
cmp P1, P0
cmovg S2, P1
cmovle P0, P1
cmp P2, P3
cmovg S0, P2
cmovg P2, P3
mov S1, P2
cmovg P3, S0
mov P1, P3
cmp P1, S2
cmovg P1, S2
cmovle P3, S2
mov S2, P1
