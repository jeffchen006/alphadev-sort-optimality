# n=5 model=out iset=I1 prefix14_class=8532
cmp P0, P3
mov S1, P0
cmovl S1, P3
cmovl P3, P0
cmp P2, P1
mov S2, P2
cmovl S2, P1
cmovle P1, P2
cmp S1, S2
cmovge P2, S2
cmovg S2, S1
mov S0, P3
cmovg S1, P2
cmp P1, S0
