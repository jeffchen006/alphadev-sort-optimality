# n=5 model=out iset=I1 prefix14_class=7329
cmp P0, P3
mov S2, P3
cmovle S2, P0
cmovg P3, P0
mov S0, S2
cmp P2, P1
cmovle S1, P2
cmovg S1, P1
cmovl P2, P1
cmp S1, S0
cmovl S2, S1
cmovg S0, S1
cmp P2, P3
cmovge S2, P2
