# n=5 model=out iset=I1 prefix14_class=2934
cmp P1, P0
cmovg S2, P0
cmovle S2, P1
cmovge P0, P1
mov S1, P2
cmp P3, S1
cmovg P2, P3
cmovg P3, S1
cmp P0, P2
cmovl S0, P2
cmovl P2, P0
cmovl P0, S0
cmp P3, S2
mov S0, S2
