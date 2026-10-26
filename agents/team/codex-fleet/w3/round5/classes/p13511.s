# n=5 model=out iset=I1 prefix14_class=13511
cmp P3, P0
cmovg S0, P0
cmovle S0, P3
mov S1, P1
cmovl P3, P0
cmp P2, S1
cmovge P1, P2
cmovle S1, P2
cmp S0, S1
cmovl P0, S0
cmovl S0, S1
cmovl S1, P0
mov S2, P3
cmp P1, S2
