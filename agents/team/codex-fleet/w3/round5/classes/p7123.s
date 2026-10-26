# n=5 model=out iset=I1 prefix14_class=7123
mov S1, P1
mov S0, P3
cmp P2, P3
cmovle S0, P2
cmovl P2, P3
cmp P1, P0
cmovl S1, P0
cmovge P1, P0
mov P0, P1
cmp S0, P1
cmovg P0, S0
cmovle P1, S0
cmp P2, S1
cmovg S2, P2
