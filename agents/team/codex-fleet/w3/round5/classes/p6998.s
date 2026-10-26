# n=5 model=out iset=I1 prefix14_class=6998
mov S0, P0
cmp P1, S0
mov S2, P2
cmovl P0, P1
mov S1, P0
cmovg S0, P1
cmp S2, P3
cmovle S2, P3
cmovl P3, P2
cmp S1, P3
cmovl S1, P3
cmovle P3, P0
cmp S2, S0
cmovge P0, S1
