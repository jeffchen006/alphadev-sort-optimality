# n=5 model=out iset=I1 prefix14_class=5998
cmp P3, P2
mov S2, P3
cmovl P3, P2
cmovg S2, P2
mov S1, P0
cmp P1, P0
cmovle P0, P1
cmovge S1, P1
cmp S1, P3
cmovg S0, P3
cmovge P3, S1
mov P2, S2
cmovg S1, S0
cmp P0, P2
