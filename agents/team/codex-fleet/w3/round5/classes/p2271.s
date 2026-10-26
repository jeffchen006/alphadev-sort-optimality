# n=5 model=out iset=I1 prefix14_class=2271
cmp P0, P1
mov S1, P0
cmovg P0, P1
cmovl S1, P1
mov S0, P2
cmp S0, P3
cmovle P2, P3
cmovg S0, P3
mov P1, P2
cmp P2, S1
cmovle P2, S1
cmovl S1, P1
cmp P0, S0
cmovge P1, P0
