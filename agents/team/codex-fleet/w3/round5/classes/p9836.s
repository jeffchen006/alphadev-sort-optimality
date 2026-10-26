# n=5 model=out iset=I1 prefix14_class=9836
cmp P1, P2
cmovg S1, P2
cmovg P2, P1
mov S0, P2
cmovle S1, P1
cmp P3, P0
cmovge P1, P0
cmovg P0, P3
cmovg P3, P1
cmp P2, P0
cmovl S0, P0
cmovl P0, P2
cmp S1, P3
cmovge S0, S1
