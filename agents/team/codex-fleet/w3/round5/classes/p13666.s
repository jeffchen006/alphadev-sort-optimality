# n=5 model=out iset=I1 prefix14_class=13666
mov S2, P1
cmp P3, P1
cmovl S2, P3
cmovle P3, P1
cmp P0, P2
cmovle P1, P0
cmovle P0, P2
cmovle P2, P1
mov S1, P3
cmp S1, P0
cmovg P3, P0
mov S0, S2
cmovge P0, S1
cmp P2, S0
