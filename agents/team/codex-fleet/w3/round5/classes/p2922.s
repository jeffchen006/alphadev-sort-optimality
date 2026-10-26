# n=5 model=out iset=I1 prefix14_class=2922
mov S1, P1
cmp P0, S1
mov S0, P2
cmovl S1, P0
cmovge P1, P0
cmp P3, S0
cmovge S0, P3
mov P0, S0
cmovg P3, P2
cmp P1, P0
cmovle S0, P1
cmovl P1, P0
mov S2, S0
cmp S1, P3
