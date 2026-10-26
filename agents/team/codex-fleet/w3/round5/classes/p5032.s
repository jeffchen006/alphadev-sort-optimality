# n=5 model=out iset=I1 prefix14_class=5032
cmp P0, P1
cmovl S0, P1
mov S1, P2
cmovge S0, P0
cmovle P1, P0
cmp S1, P3
cmovle P2, P3
cmovg S1, P3
cmp S1, P1
mov P0, S1
cmovle P0, P1
cmovg S1, P1
mov S1, P2
cmovg P1, P0
