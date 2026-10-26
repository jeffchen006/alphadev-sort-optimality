# n=5 model=out iset=I1 prefix14_class=6801
mov S2, P3
mov S0, P0
cmp P3, P2
cmovle P3, P2
cmovl P2, S2
cmp S0, P1
cmovg S0, P1
cmovle P0, P1
cmp P3, P0
mov S1, P0
cmovge P0, P3
cmovl S1, P3
cmp S0, P2
cmovle P1, S0
