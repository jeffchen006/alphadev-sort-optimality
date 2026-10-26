# n=5 model=out iset=I1 prefix14_class=9625
cmp P0, P1
mov S1, P0
cmovl P0, P1
cmovg S1, P1
cmp P2, P3
mov S0, P3
cmovl S0, P2
cmovl P2, P3
cmp P2, P0
cmovle S2, P0
cmovl P0, P2
cmovge S2, P2
cmp S0, S1
cmovg P2, P0
