# n=5 model=out iset=I1 prefix14_class=7724
cmp P2, P1
mov S2, P2
cmovge P2, P1
cmovle S2, P1
cmp P0, P3
mov S0, P0
cmovle S0, P3
cmovg P0, P3
cmp P2, P0
cmovl S1, P0
cmovle P0, P2
cmovl P2, S1
cmp S0, S2
cmovg S1, S2
