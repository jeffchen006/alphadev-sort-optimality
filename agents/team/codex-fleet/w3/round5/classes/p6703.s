# n=5 model=out iset=I1 prefix14_class=6703
cmp P3, P1
mov S0, P3
mov S1, P2
cmovg P3, P1
cmovl S0, P1
cmp P0, S1
cmovle P2, P0
cmovg S1, P0
mov P0, S0
cmp S1, P0
cmovge P0, S1
cmovl S0, S1
cmp P3, P2
cmovle P1, P2
