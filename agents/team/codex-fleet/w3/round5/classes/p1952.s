# n=5 model=out iset=I1 prefix14_class=1952
cmp P2, P3
mov S0, P3
cmovl S0, P2
mov S1, P1
cmovl P2, P3
cmp P0, S1
cmovl P1, P0
cmovge S1, P0
mov S2, P2
cmp S1, S2
cmovge P2, S1
cmovle S2, S1
cmp P1, S0
cmovge P0, S0
