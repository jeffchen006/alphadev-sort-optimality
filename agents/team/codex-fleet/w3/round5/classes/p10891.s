# n=5 model=out iset=I1 prefix14_class=10891
cmp P3, P2
cmovge S2, P2
cmovge P2, P3
cmovl S2, P3
cmp P1, P0
cmovg P3, P0
cmovg P0, P1
mov S1, P0
cmovg P1, P3
cmp S1, P2
cmovle P0, P2
cmovle P2, S1
cmp S2, P1
cmovle S1, P1
