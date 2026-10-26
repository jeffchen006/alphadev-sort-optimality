# n=5 model=out iset=I1 prefix14_class=8341
cmp P2, P1
cmovle S1, P2
cmovg S1, P1
cmovle P2, P1
cmp P0, P3
cmovg S2, P3
mov P1, S1
cmovg P3, P0
cmovg P0, S2
cmp S1, P0
cmovge P1, P0
mov P1, P2
cmovl S1, P0
cmp P1, P3
