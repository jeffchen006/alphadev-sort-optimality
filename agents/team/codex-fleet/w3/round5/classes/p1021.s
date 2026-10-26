# n=5 model=out iset=I1 prefix14_class=1021
mov S1, P2
cmp S1, P1
cmovl S1, P1
mov S0, P0
cmovle P1, P2
cmp P0, P3
mov P2, S1
cmovg P0, P3
cmovg P3, S0
cmp P3, S1
cmovg P2, P3
cmovge P3, S1
cmp P0, P1
cmovg P2, P0
