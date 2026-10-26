# n=5 model=out iset=I1 prefix14_class=6570
mov S1, P1
cmp P2, P1
cmovg S1, P2
mov S2, P0
cmovge P2, P1
cmp P0, P3
cmovl S2, P3
cmovl P3, P0
cmp S2, S1
cmovle P1, S1
cmovl S1, S2
mov S0, S1
cmovle S2, P1
cmp P2, P3
