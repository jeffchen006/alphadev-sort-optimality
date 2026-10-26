# n=5 model=out iset=I1 prefix14_class=11026
cmp P0, P2
mov S2, P0
cmovg S2, P2
cmovle P0, P2
mov S1, P0
cmp P1, P3
cmovle P2, P1
cmovle P1, P3
cmovle P3, P2
cmp P1, P0
cmovg S1, P1
cmovle P0, P1
cmp S2, P3
cmovl P1, P3
