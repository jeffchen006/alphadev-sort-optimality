# n=5 model=out iset=I1 prefix14_class=13386
mov S1, P2
cmp S1, P3
cmovg P2, P3
mov S2, P1
cmovg P3, S1
cmp P0, P1
cmovg P1, P0
cmovl S2, P0
cmp S2, P2
cmovle P0, P2
cmovle P2, S2
cmovle S2, P0
cmp P1, P3
mov P2, S2
