# n=5 model=out iset=I1 prefix14_class=3740
mov S0, P0
cmp P2, S0
cmovg P0, P2
cmovle S0, P2
cmovl P2, P0
cmp P1, P3
cmovge S1, P3
cmovg P3, P1
mov S2, S0
cmovg P1, S1
cmp P1, S0
cmovl S2, P1
cmovg S0, P1
cmp P2, P3
