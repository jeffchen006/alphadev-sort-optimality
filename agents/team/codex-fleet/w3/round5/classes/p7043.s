# n=5 model=out iset=I1 prefix14_class=7043
cmp P2, P0
cmovg S0, P0
mov S2, P3
cmovge P0, P2
cmovg P2, S0
cmp S2, P1
cmovg S2, P1
cmovle P3, P1
cmp S2, P2
cmovle S1, P2
cmovl P2, S2
cmovl S2, S1
cmp P3, P0
cmovg S1, P3
