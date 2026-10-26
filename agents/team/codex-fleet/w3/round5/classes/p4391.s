# n=5 model=out iset=I1 prefix14_class=4391
mov S2, P1
cmp P3, P1
cmovge P1, P3
cmovg P3, S2
mov S0, P2
cmp P0, P2
cmovle P2, P0
mov S1, P1
cmovge S0, P0
cmp S0, S1
cmovge S1, S0
cmovg S0, P1
mov P1, P2
cmp P1, P3
