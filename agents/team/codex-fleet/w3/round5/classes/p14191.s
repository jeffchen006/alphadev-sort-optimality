# n=5 model=out iset=I1 prefix14_class=14191
mov S0, P2
cmp P2, P1
mov S1, P3
cmovle P2, P1
cmovle P1, S0
cmp S1, P0
cmovl P3, P0
cmovg S1, P0
cmp P2, P3
cmovge P0, P3
cmovge P3, P2
cmovg P2, P0
mov S2, P1
cmp S1, S2
