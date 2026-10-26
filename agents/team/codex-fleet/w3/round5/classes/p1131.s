# n=5 model=out iset=I1 prefix14_class=1131
mov S2, P1
cmp P2, P1
cmovle P1, P2
cmovge S2, P2
mov S1, P0
cmp P3, S1
cmovg S1, P3
cmovg P3, P0
mov P2, S1
cmp S2, S1
cmovl S1, S2
cmovg P2, S2
mov P2, P3
cmp P1, P3
