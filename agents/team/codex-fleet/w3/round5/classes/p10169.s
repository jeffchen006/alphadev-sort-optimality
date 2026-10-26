# n=5 model=out iset=I1 prefix14_class=10169
cmp P3, P0
cmovl S1, P3
cmovl P3, P0
mov S2, P1
cmovl P0, S1
cmp S2, P2
cmovg P1, P2
cmovge P2, S2
cmp P3, P2
cmovle S0, P2
mov S2, P0
cmovl P2, P3
cmovl P3, S0
mov P3, P2
