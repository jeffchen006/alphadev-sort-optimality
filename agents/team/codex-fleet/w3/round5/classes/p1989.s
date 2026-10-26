# n=5 model=out iset=I1 prefix14_class=1989
mov S2, P0
cmp P3, P1
mov S1, P3
cmovge P3, P1
cmovl S1, P1
cmp P2, P0
cmovg P0, P2
cmovl S2, P2
cmovl P2, P0
cmp P0, S1
cmovle P2, S1
cmovle S1, P0
cmp S2, P3
cmovle P1, S2
