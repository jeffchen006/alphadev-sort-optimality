# n=5 model=out iset=I1 prefix14_class=7200
mov S1, P1
cmp P1, P2
cmovge S1, P2
cmovle P1, P2
cmp P3, P0
cmovg S0, P3
cmovge P3, P0
cmovg P0, S0
cmp P3, S1
mov S2, P3
mov P2, P1
cmovle P3, S1
cmovg S2, S1
cmovg S1, P3
