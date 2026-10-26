# n=5 model=out iset=I1 prefix14_class=2452
cmp P2, P0
mov S1, P3
mov S2, P2
cmovg S2, P0
cmovle P2, P0
cmp P1, P3
cmovge P3, P1
cmovg P1, S1
cmp P3, P2
cmovle S1, P3
cmovle P3, P2
cmovle P2, S1
cmp S2, P1
cmovl P3, P1
