# n=5 model=out iset=I1 prefix14_class=3919
cmp P0, P1
mov S0, P0
cmovge P0, P1
mov S2, P2
cmovg P1, S0
cmp P2, P3
cmovle P2, P3
cmovle P3, S2
cmp P0, P3
mov S1, P3
cmovle P3, P0
cmovg S1, P0
mov P0, P2
cmp P1, P2
