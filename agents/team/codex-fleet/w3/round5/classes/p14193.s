# n=5 model=out iset=I1 prefix14_class=14193
mov S2, P3
cmp P0, P2
cmovl S0, P2
cmovl P2, P0
cmovl P0, S0
cmp P1, P3
cmovle S2, P1
mov S1, S2
cmovg P3, P1
cmp P3, P0
cmovge P1, P0
cmovg P0, P3
cmovg P3, P1
cmp P2, S1
