# n=5 model=out iset=I1 prefix14_class=6148
cmp P0, P2
mov S2, P2
cmovge S2, P0
mov S0, P1
cmovl P2, P0
cmp P3, S0
cmovge P1, P3
cmovge P3, S0
cmp S2, P1
cmovl S1, S2
cmovge S1, P1
cmovle S2, P1
mov S0, P3
mov S2, S1
