# n=5 model=out iset=I1 prefix14_class=13163
cmp P1, P2
mov S2, P0
cmovge S1, P1
cmovg P1, P2
cmovge P2, S1
cmp P3, P0
mov S0, P1
cmovg S2, P3
cmovg P3, P0
cmp P3, P1
cmovg S0, P3
cmovle P1, P3
mov P3, S0
mov P1, S2
