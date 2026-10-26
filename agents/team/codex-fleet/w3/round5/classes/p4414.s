# n=5 model=out iset=I1 prefix14_class=4414
mov S1, P3
mov S2, P2
cmp S1, P0
cmovle P3, P0
cmovg S1, P0
cmp S2, P1
cmovge S2, P1
mov S0, S1
cmovge P1, P2
cmp P3, P1
cmovle P0, P3
cmovl P3, P1
cmovle P1, P0
mov P3, P1
