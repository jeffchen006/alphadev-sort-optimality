# n=5 model=out iset=I1 prefix14_class=7495
mov S0, P2
cmp S0, P0
cmovle S0, P0
cmovge P2, P0
mov S2, P1
cmp S2, P3
cmovg P1, P3
mov P0, P1
cmovl S2, P3
cmp P2, P1
cmovl P0, P2
cmovg P1, P2
cmp S2, S0
cmovle S1, S2
