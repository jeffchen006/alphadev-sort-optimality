# n=5 model=out iset=I1 prefix14_class=12071
cmp P1, P3
cmovle S0, P1
cmovg S0, P3
cmovl P1, P3
cmp P0, P2
mov S1, P0
cmovge S1, P2
mov P3, S1
cmovl P0, P2
cmp S0, P3
cmovl P3, S0
cmovge S1, S0
cmp P0, P1
cmovge S2, P1
