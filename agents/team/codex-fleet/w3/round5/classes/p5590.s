# n=5 model=out iset=I1 prefix14_class=5590
mov S2, P3
cmp P1, P3
cmovge P3, P1
cmovge P1, S2
cmp P2, P0
cmovge S0, P0
cmovge P0, P2
cmovle S0, P2
mov S1, S0
cmp S0, P1
mov P2, P0
cmovl S0, P1
cmovl P1, S1
mov P1, S0
