# n=5 model=out iset=I1 prefix14_class=8643
mov S0, P2
cmp P2, P3
cmovg S0, P3
mov S1, P1
cmovle P2, P3
cmp P0, S1
cmovl P1, P0
cmovge S1, P0
cmp P2, S1
cmovl S2, S1
cmovle S1, P2
cmovge S2, P2
cmp S0, P1
cmovge P2, P1
