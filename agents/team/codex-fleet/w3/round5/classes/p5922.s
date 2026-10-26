# n=5 model=out iset=I1 prefix14_class=5922
mov S2, P3
cmp P3, P0
mov S1, P1
cmovle S2, P0
cmovge P3, P0
cmp P2, P1
cmovg P1, P2
cmovge P2, S1
cmp P1, S2
cmovl S0, P1
cmovl P1, S2
cmovl S2, S0
cmp P2, P3
cmovg P1, P3
