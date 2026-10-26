# n=5 model=out iset=I1 prefix14_class=2748
cmp P3, P1
mov S2, P3
cmovge P3, P1
cmovl S2, P1
mov S1, P0
cmp S1, P2
cmovg S1, P2
mov S0, S2
cmovl P0, P2
cmp P0, S2
cmovle S0, P0
cmovle P0, S2
cmp S1, P3
cmovl P1, S1
