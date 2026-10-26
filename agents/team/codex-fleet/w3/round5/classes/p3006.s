# n=5 model=out iset=I1 prefix14_class=3006
cmp P3, P0
cmovl S2, P3
cmovl P3, P0
mov S0, P2
cmovl P0, S2
cmp P2, P1
mov S1, P3
cmovge P2, P1
cmovg P1, S0
cmp S1, P1
cmovg S1, P1
cmovg P1, P3
cmp P0, P2
cmovle S0, P0
