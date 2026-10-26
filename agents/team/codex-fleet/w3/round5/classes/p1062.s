# n=5 model=out iset=I1 prefix14_class=1062
mov S1, P0
cmp P0, P1
cmovl S1, P1
cmovle P1, P0
mov S0, P2
cmp S0, P3
cmovg S0, P3
cmovg P3, P2
cmp P3, S1
cmovge P0, P3
cmovge P3, S1
cmovg S1, P0
mov P0, P1
cmp S0, P1
