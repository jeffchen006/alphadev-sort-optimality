# n=5 model=out iset=I1 prefix14_class=9061
cmp P2, P0
cmovge S2, P2
cmovg P2, P0
mov S1, P3
cmovg P0, S2
cmp P1, P3
cmovl S1, P1
mov S0, P0
cmovge P3, P1
cmp P3, P0
cmovg P0, P3
cmovle S0, P3
cmp P2, S1
cmovg S2, S1
