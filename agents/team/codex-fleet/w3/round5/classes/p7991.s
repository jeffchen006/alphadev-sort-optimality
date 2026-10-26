# n=5 model=out iset=I1 prefix14_class=7991
cmp P1, P2
mov S0, P0
cmovg S2, P2
cmovle S2, P1
cmovg P2, P1
cmp P0, P3
cmovge S0, P3
cmovl P0, P3
cmovl P3, S0
cmp S0, S2
cmovge P3, S2
cmovl S0, S2
mov P3, S0
cmp P2, P0
