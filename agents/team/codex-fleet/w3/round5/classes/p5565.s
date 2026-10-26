# n=5 model=out iset=I1 prefix14_class=5565
cmp P1, P2
cmovg S2, P1
cmovle S2, P2
cmovge P1, P2
cmp P0, P3
cmovle P2, P0
cmovl P0, P3
cmovl P3, P2
cmp P1, P3
mov S1, P3
cmovl P3, P1
cmovg S1, P1
cmp S2, P0
mov P3, S2
