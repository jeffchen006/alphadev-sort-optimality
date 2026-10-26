# n=5 model=out iset=I1 prefix14_class=1251
cmp P0, P2
cmovle S2, P2
cmovge S2, P0
cmovl P2, P0
cmp P1, P3
mov P0, P1
cmovle P0, P3
cmovle P3, P1
cmp S2, P0
mov P1, P0
cmovge P1, S2
cmovl P0, S2
cmp P3, P2
cmovg S2, P3
