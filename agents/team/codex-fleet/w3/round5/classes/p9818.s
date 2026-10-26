# n=5 model=out iset=I1 prefix14_class=9818
cmp P3, P0
cmovge S0, P3
cmovl S0, P0
cmovge P3, P0
cmp P1, P2
cmovle S2, P2
mov P0, S0
cmovl P2, P1
cmovl P1, S2
cmp P1, P0
cmovg S0, P1
cmovg P1, P0
cmp P2, P3
cmovge S2, P2
