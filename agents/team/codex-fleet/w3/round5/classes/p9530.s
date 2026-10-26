# n=5 model=out iset=I1 prefix14_class=9530
cmp P3, P0
cmovl S1, P0
cmovl P0, P3
cmovl P3, S1
cmp P1, P2
cmovge S0, P1
cmovg P1, P2
cmovle S0, P2
cmp P0, P1
mov P2, S0
mov S2, P0
cmovl P0, P1
cmovg S2, P1
cmovge P1, P0
