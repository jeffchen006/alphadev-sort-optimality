# n=5 model=out iset=I1 prefix14_class=13182
mov S2, P2
cmp P0, P3
mov S1, P0
cmovle S1, P3
cmovl P3, P0
cmp P1, S2
cmovge P2, P1
cmovge P1, S2
cmp P1, P3
cmovl S2, P1
cmovle P1, P3
cmovl P3, S2
cmp S1, P2
cmovle P3, S1
