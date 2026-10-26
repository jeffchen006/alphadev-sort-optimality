# n=5 model=out iset=I1 prefix14_class=4780
cmp P1, P2
cmovle S0, P1
cmovl P1, P2
cmovl P2, S0
mov S2, P3
cmp S2, P0
cmovl P3, P0
cmovge S2, P0
cmp S2, P2
cmovg S1, P2
cmovg P2, S2
cmovg S2, S1
mov S0, P3
mov S2, P2
