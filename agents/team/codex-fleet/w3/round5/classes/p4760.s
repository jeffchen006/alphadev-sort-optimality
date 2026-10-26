# n=5 model=out iset=I1 prefix14_class=4760
mov S0, P3
mov S2, P2
cmp S0, P0
cmovle P3, P0
cmovl P0, S0
mov S1, P0
cmp S2, P1
cmovg S2, P1
cmovle P2, P1
cmp S2, P0
cmovge P0, S2
cmovg S2, S1
cmp P3, P2
cmovg S0, P2
