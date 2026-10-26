# n=5 model=out iset=I1 prefix14_class=5545
mov S2, P2
cmp S2, P0
cmovg P2, P0
cmovle S2, P0
cmp P3, P1
mov S1, P3
cmovle P3, P1
cmovle P1, S1
mov S1, P2
cmp P1, P2
cmovg S1, P1
cmovl P2, P1
cmp S2, P3
cmovl P1, S2
