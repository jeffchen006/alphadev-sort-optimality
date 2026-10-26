# n=5 model=out iset=I1 prefix14_class=4525
mov S2, P0
cmp P0, P1
mov S1, P3
cmovg S2, P1
cmovl P0, P1
cmp S1, P2
cmovg S1, P2
cmovle P3, P2
mov S0, P3
cmp P3, P0
cmovge P3, P0
cmovg P0, S0
cmp S2, S1
cmovle P2, S2
