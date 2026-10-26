# n=5 model=out iset=I1 prefix14_class=13404
cmp P1, P2
mov S2, P0
cmovge S0, P1
cmovge P1, P2
cmovge P2, S0
cmp P3, P0
cmovg P0, P3
cmovg P3, S2
cmovl S2, P3
cmp P1, S2
cmovl S2, P1
cmovl P1, P3
cmp P0, P2
cmovle S2, P0
