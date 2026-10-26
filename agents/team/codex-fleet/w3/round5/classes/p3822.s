# n=5 model=out iset=I1 prefix14_class=3822
mov S2, P1
cmp S2, P2
cmovg S2, P2
cmovg P2, P1
cmp P0, P3
mov P1, P3
cmovl P3, P0
cmovge P1, P0
cmp P3, S2
cmovl P0, S2
cmovge P0, P3
cmovle S2, P3
cmp P1, P2
cmovle P3, P2
