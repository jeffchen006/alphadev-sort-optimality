# n=5 model=out iset=I1 prefix14_class=3985
mov S1, P0
cmp S1, P3
cmovl S1, P3
cmovl P3, P0
cmovge P0, P3
cmp P2, P1
cmovg S2, P1
cmovle S2, P2
cmovg P1, P2
cmp S2, P3
cmovge P0, S2
cmovg S2, P3
cmp P1, S1
cmovl S0, S1
