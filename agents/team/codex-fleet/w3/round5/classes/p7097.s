# n=5 model=out iset=I1 prefix14_class=7097
cmp P0, P1
cmovg S0, P1
cmovg P1, P0
cmovg P0, S0
cmp P2, P3
mov S1, P2
cmovg P2, P3
cmovge P3, S1
cmp P2, P0
mov S2, P2
cmovl S2, P0
cmovl P0, P2
cmp P1, P3
cmovl P0, P3
