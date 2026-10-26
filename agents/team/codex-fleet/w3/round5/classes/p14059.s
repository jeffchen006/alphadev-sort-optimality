# n=5 model=out iset=I1 prefix14_class=14059
cmp P2, P3
mov S1, P3
cmovg S1, P2
cmovle P3, P2
cmp P1, P0
cmovl P2, P0
mov S2, S1
cmovle P0, P1
cmovl P1, P2
cmp S1, P1
mov S0, P3
cmovg S2, P1
cmovle S1, P1
cmp P0, P3
