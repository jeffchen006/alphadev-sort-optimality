# n=5 model=out iset=I1 prefix14_class=8667
mov S2, P2
cmp P0, P2
cmovge S2, P0
cmovg P0, P2
cmp P1, P3
cmovl S1, P3
cmovle P3, P1
cmovl P1, S1
cmp P1, S2
mov S0, S2
cmovge S0, P1
cmovge P1, S2
cmp P3, P0
cmovg P2, P0
