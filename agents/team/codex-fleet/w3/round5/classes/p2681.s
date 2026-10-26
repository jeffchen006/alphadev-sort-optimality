# n=5 model=out iset=I1 prefix14_class=2681
mov S1, P1
mov S2, P3
cmp P2, S1
cmovg P1, P2
cmovl S1, P2
cmp P0, P3
cmovg S2, P0
cmovg P0, P3
cmovge P3, S2
cmp P1, P3
cmovle S2, P1
cmovle P1, P3
mov P1, S1
cmp S1, P0
