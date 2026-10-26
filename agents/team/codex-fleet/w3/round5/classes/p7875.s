# n=5 model=out iset=I1 prefix14_class=7875
cmp P0, P3
mov S2, P3
mov S0, P1
cmovge S2, P0
cmovle P3, P0
cmp S0, P2
cmovl P1, P2
cmovge S0, P2
cmp S0, P3
cmovg S1, S0
cmovge S0, P3
mov P2, P1
cmovg P3, S1
cmp S2, P2
