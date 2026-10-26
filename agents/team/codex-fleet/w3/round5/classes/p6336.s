# n=5 model=out iset=I1 prefix14_class=6336
mov S2, P3
cmp S2, P2
cmovg S2, P2
cmovg P2, P3
cmp P1, P0
mov S0, P1
cmovl P1, P0
cmovl P0, S0
mov S0, P2
cmp P2, P1
cmovg S0, P1
cmovle P2, P1
cmp S2, P0
cmovge P1, P0
