# n=5 model=out iset=I1 prefix14_class=8340
cmp P2, P1
cmovle S1, P2
cmovg S1, P1
cmovle P2, P1
cmp P3, P0
cmovg S2, P0
mov P1, S1
cmovg P0, P3
cmovg P3, S2
cmp S1, P3
cmovge P1, P3
mov P1, P2
cmovl S1, P3
cmp P1, P0
