# n=5 model=out iset=I1 prefix14_class=147
mov S1, P1
cmp S1, P3
cmovg P1, P3
cmovl S1, P3
cmp P0, P2
cmovge S0, P0
cmovle S0, P2
cmovl P2, P0
mov S2, P2
cmp P2, P1
cmovge P2, P1
cmovle S2, P1
mov P0, S0
cmp S1, P0
