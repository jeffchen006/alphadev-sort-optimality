# n=5 model=out iset=I1 prefix14_class=9900
mov S2, P1
cmp P3, P2
cmovge S0, P3
cmovg P3, P2
cmovge P2, S0
cmp P1, P0
mov S1, P2
cmovle S2, P0
cmovl P0, P1
cmp S2, P2
cmovl S1, S2
cmovl S2, P2
mov S2, S1
mov P1, P3
