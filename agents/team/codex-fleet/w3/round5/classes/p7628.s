# n=5 model=out iset=I1 prefix14_class=7628
cmp P1, P0
mov S1, P0
cmovg P0, P1
cmovle S1, P1
cmp P3, P2
cmovg P1, P2
cmovle P1, P3
cmovg P2, P3
cmp S1, P1
cmovle P3, S1
cmovg P3, P1
cmovl S1, P1
cmovg P1, S1
mov P3, P0
