# n=5 model=out iset=I1 prefix14_class=5097
mov S0, P1
cmp S0, P3
cmovge P1, P3
cmovl S0, P3
cmp P0, P2
cmovle S2, P2
cmovg S2, P0
cmovge P0, P2
cmp P1, P0
cmovle S1, P1
cmovle P1, P0
cmovl P0, S1
mov P3, P1
cmp S2, S0
