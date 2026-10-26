# n=5 model=out iset=I1 prefix14_class=14083
mov S1, P2
cmp P2, P0
cmovle P2, P0
cmovl P0, S1
cmp P3, P1
mov S2, P1
cmovl P1, P3
cmovg S2, P3
cmp S2, P2
cmovle P3, P2
mov S1, P0
cmovle P2, S2
cmovle S2, P3
cmp P1, S1
