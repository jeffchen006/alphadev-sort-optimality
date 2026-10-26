# n=5 model=out iset=I1 prefix14_class=10907
cmp P2, P0
cmovle S2, P2
cmovle P2, P0
cmovl P0, S2
cmp P3, P1
cmovle S1, P1
cmovg S1, P3
cmovle P1, P3
cmp S1, P2
mov P3, S1
cmovle S1, P2
cmovle P2, P3
cmp P0, P1
cmovle P3, P1
