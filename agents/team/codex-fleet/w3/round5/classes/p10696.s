# n=5 model=out iset=I1 prefix14_class=10696
cmp P0, P1
mov S1, P2
mov S2, P0
cmovg P0, P1
cmovle S2, P1
cmp P3, S1
cmovl P2, P3
cmovg S1, P3
cmp S1, S2
cmovle P1, S2
cmovle S2, S1
cmovle S1, P1
cmp P2, P0
cmovle S1, P2
