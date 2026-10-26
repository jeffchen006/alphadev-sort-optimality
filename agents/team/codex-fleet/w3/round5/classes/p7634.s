# n=5 model=out iset=I1 prefix14_class=7634
cmp P3, P2
mov S1, P3
mov S2, P0
cmovl P3, P2
cmovl P2, S1
cmp P1, S2
cmovle S2, P1
cmovge P0, P1
cmp S2, P2
cmovle P1, S2
cmovl S2, P2
cmovle P2, P1
cmp P3, P0
mov S1, S2
