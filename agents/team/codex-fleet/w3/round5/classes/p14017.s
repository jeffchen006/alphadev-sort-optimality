# n=5 model=out iset=I1 prefix14_class=14017
cmp P2, P1
mov S1, P2
cmovg P2, P1
cmovge P1, S1
mov S0, P1
cmp P0, P3
cmovle S1, P0
cmovl P0, P3
cmovl P3, S1
cmp S0, P0
mov S2, P3
cmovl S0, P0
cmovg P1, P0
cmp S2, P2
