# n=5 model=out iset=I1 prefix14_class=1762
mov S0, P2
cmp P3, S0
cmovge P2, P3
cmovg P3, S0
cmp P0, P1
cmovge S0, P1
cmovl S0, P0
cmovl P0, P1
mov S1, P2
cmp P2, P0
cmovl P2, P0
cmovg S1, P0
mov S2, S0
mov P2, S1
