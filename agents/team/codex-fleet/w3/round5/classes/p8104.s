# n=5 model=out iset=I1 prefix14_class=8104
cmp P1, P2
mov S2, P1
mov S1, P3
cmovle P1, P2
cmovg S2, P2
cmp P0, S1
cmovl S1, P0
cmovle P0, P3
cmp S2, S1
cmovl P3, S1
cmovle S1, S2
cmovl S2, P3
cmp P1, P0
cmovge P3, P1
