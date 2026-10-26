# n=5 model=out iset=I1 prefix14_class=5044
mov S2, P1
cmp P0, S2
mov S0, P3
cmovg P1, P0
cmovge P0, S2
cmovl S2, P0
cmp P2, P3
cmovle S0, P2
cmovge P3, P2
cmp S0, S2
cmovl P0, S0
cmovge S2, S0
mov P0, S2
cmp P1, P3
