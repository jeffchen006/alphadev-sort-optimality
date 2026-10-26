# n=5 model=out iset=I1 prefix14_class=2765
cmp P0, P2
cmovg S2, P0
cmovle S2, P2
cmovg P0, P2
mov P2, P3
cmp P3, P1
cmovge P2, P1
cmovl P3, P1
cmp S2, P3
cmovle P1, P3
cmovle P3, S2
cmovl S2, P1
mov S2, P0
cmp S2, P2
