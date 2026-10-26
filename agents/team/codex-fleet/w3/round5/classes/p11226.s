# n=5 model=out iset=I1 prefix14_class=11226
mov S1, P0
cmp S1, P3
mov S0, P2
cmovl S1, P3
cmovge P0, P3
cmp P2, P1
cmovge P2, P1
cmovg P1, S0
cmp P1, S1
cmovle P3, S1
cmovl S1, P1
mov S0, S1
cmovle P1, P3
cmp P2, P0
