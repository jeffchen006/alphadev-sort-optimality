# n=5 model=out iset=I1 prefix14_class=3984
mov S1, P0
cmp S1, P2
cmovl S1, P2
cmovg P0, P2
cmp P3, P1
mov P2, P0
cmovle S2, P3
cmovg S2, P1
cmovg P1, P3
cmp S2, P0
cmovge P0, S2
cmovg S2, P2
cmp P1, S1
cmovge P2, P1
