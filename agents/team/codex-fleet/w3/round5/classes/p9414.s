# n=5 model=out iset=I1 prefix14_class=9414
mov S0, P0
cmp P3, S0
cmovge P0, P3
mov S2, P2
cmovg P3, S0
cmp P1, P2
cmovl S2, P1
cmovl P1, P2
cmp S2, P3
cmovge S1, S2
cmovg S2, P3
cmovg P3, S1
cmp P0, P1
cmovle S0, P1
