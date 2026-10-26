# n=5 model=out iset=I1 prefix14_class=7766
mov S2, P0
cmp S2, P1
cmovg S2, P1
mov S0, P2
cmovl P0, P1
cmp S0, P3
cmovg S0, P3
cmovle P2, P3
cmp S2, S0
cmovg S1, S0
cmovge S0, S2
cmovg S2, S1
cmp P2, P0
mov P3, P0
