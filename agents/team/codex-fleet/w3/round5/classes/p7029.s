# n=5 model=out iset=I1 prefix14_class=7029
mov S2, P1
cmp P2, P1
mov S1, P0
cmovg S2, P2
cmovge P2, P1
cmp S1, P3
mov S0, P2
cmovge P0, P3
cmovle S1, P3
cmp P0, P2
cmovl S0, P0
cmovle P0, P2
cmp S1, S2
cmovl P1, S2
