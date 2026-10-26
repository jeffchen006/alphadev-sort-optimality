# n=5 model=out iset=I1 prefix14_class=13018
mov S0, P1
cmp P2, P1
cmovle S0, P2
mov S1, P0
cmovg P1, P2
cmp P0, P3
cmovge P0, P3
cmovl S1, P3
cmp S0, P0
mov S2, S0
cmovle S0, P0
cmovl P0, S2
cmp P1, S1
cmovge P2, P1
