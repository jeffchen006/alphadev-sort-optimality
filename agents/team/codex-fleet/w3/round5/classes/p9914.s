# n=5 model=out iset=I1 prefix14_class=9914
cmp P1, P3
mov S1, P2
cmovge S0, P1
cmovge P1, P3
cmovge P3, S0
mov S2, P3
cmp P2, P0
cmovg S1, P0
cmovle P2, P0
cmp P2, P3
cmovl P3, P2
cmovge S2, P2
cmp S1, P1
mov P2, S1
