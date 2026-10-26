# n=5 model=out iset=I1 prefix14_class=5780
mov S2, P1
cmp S2, P0
cmovle S2, P0
cmovg P1, P0
cmp P3, P2
mov S1, P2
cmovg P2, P3
cmovl S1, P3
mov S0, P1
cmp S1, S0
cmovl P1, S1
cmovge S0, S1
cmp S2, P2
cmovge P1, S2
