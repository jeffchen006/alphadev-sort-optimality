# n=5 model=out iset=I1 prefix14_class=11070
mov S0, P1
cmp S0, P2
cmovl S0, P2
cmovl P2, P1
mov S2, P3
cmp S2, P0
cmovl S2, P0
cmovl P0, P3
cmp S2, S0
cmovl P3, S0
cmovle S0, S2
cmovl S2, P3
cmp P0, P2
cmovge P1, P0
