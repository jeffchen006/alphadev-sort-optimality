# n=5 model=out iset=I1 prefix14_class=5515
cmp P3, P2
cmovg S0, P2
mov S2, P1
cmovle S0, P3
cmovl P3, P2
cmp P1, P0
cmovge S2, P0
cmovl P1, P0
mov P2, S2
cmp S2, S0
cmovl P2, S0
cmovge S2, S0
cmp P1, P3
mov S2, P2
