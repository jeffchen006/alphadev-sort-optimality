# n=5 model=out iset=I1 prefix14_class=11727
cmp P1, P0
cmovl S1, P0
cmovge S1, P1
cmovl P0, P1
mov S2, P3
cmp S2, P2
cmovge S2, P2
cmovge P2, P3
cmp S1, P2
mov P3, S2
cmovle S0, S1
cmovle S1, P2
cmovl P2, S0
mov P1, P2
