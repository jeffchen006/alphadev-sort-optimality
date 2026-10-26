# n=5 model=out iset=I1 prefix14_class=3699
mov S1, P2
mov S2, P0
cmp S1, P3
cmovge P2, P3
cmovle S1, P3
cmovl P3, P2
cmp S2, P1
cmovle S2, P1
cmovle P1, P0
cmp P2, P1
cmovl P3, P1
cmovl P1, P2
cmp S2, S1
cmovg P2, S2
