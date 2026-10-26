# n=5 model=out iset=I1 prefix14_class=13973
mov S0, P3
mov S1, P0
cmp P2, S1
cmovge S1, P2
cmovg P2, P0
cmp P1, S0
cmovge P3, P1
cmovg P1, S0
cmp P3, S1
cmovle S2, S1
cmovl S1, P3
cmovl P3, S2
mov P3, P1
cmp P1, P2
