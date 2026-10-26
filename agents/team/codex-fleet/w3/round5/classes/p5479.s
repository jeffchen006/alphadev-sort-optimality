# n=5 model=out iset=I1 prefix14_class=5479
cmp P3, P0
mov S1, P0
cmovle P0, P3
cmovl P3, S1
mov S0, P1
cmp P1, P2
mov S2, P0
cmovg S0, P2
cmovl P1, P2
cmp S2, S0
cmovl S2, S0
cmovle S0, P0
cmp P1, P3
cmovge P2, P1
