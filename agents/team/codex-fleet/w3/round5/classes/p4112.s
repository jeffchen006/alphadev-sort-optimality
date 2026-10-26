# n=5 model=out iset=I1 prefix14_class=4112
mov S1, P2
mov S2, P0
cmp P3, S1
cmovg S1, P3
cmovle P2, P3
cmp P1, P0
cmovg S2, P1
cmovl P0, P1
mov P1, P2
cmp P0, P2
cmovge P2, P0
cmovge P0, P1
cmp S2, S1
cmovge P1, S1
