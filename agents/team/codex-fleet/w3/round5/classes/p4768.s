# n=5 model=out iset=I1 prefix14_class=4768
cmp P1, P3
mov S0, P1
cmovl P1, P3
cmovl P3, S0
mov S1, P2
cmp S1, P0
cmovg S1, P0
cmovle P2, P0
cmp S1, P3
mov S2, P3
cmovge P3, S1
cmovg S1, S2
cmp P1, P2
cmovle P0, P1
