# n=5 model=out iset=I1 prefix14_class=2982
cmp P2, P0
cmovle S0, P0
cmovl P0, P2
mov S1, P3
cmovge S0, P2
cmp P3, P1
cmovg P3, P1
cmovge P1, S1
cmp S0, P1
mov S1, P1
cmovl S1, S0
cmovg P1, S0
cmp P0, P3
mov P1, S1
