# n=5 model=out iset=I1 prefix14_class=779
cmp P1, P3
cmovl S1, P3
mov S2, P0
cmovle P3, P1
cmovl P1, S1
cmp P0, P2
cmovg S2, P2
mov S0, S2
cmovl P0, P2
cmp P0, P1
cmovg S1, P0
cmovle S1, P1
cmovle P1, P0
cmp S0, P3
