# n=5 model=out iset=I1 prefix14_class=10004
mov S1, P2
mov S0, P3
cmp S0, P1
cmovl S0, P1
cmovg P3, P1
cmp P0, P2
cmovl S1, P0
cmovl P0, P2
cmp S0, P0
cmovge P2, P0
cmovg P0, S0
cmovg S0, P2
cmp P3, S1
cmovle S2, P3
