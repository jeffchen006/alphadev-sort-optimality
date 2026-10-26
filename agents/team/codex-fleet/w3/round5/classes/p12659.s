# n=5 model=out iset=I1 prefix14_class=12659
cmp P2, P0
cmovg S0, P0
mov S1, P3
cmovle S0, P2
cmovl P2, P0
cmp P3, P1
cmovl S1, P1
cmovg P3, P1
cmp S0, P3
cmovge P0, P3
cmovg P3, S0
cmovg S0, P0
mov S2, S1
cmp S1, P2
