# n=5 model=out iset=I1 prefix14_class=1012
mov S1, P1
cmp S1, P0
cmovl S1, P0
cmovle P0, P1
cmp P3, P2
mov P1, S1
mov S0, P3
cmovg S0, P2
cmovg P2, P3
cmp P2, P1
cmovg S1, P2
cmovge P2, P1
cmp S0, P0
cmovle P3, P0
