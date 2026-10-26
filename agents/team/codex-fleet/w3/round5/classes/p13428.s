# n=5 model=out iset=I1 prefix14_class=13428
cmp P2, P1
cmovge S2, P2
cmovg P2, P1
cmovge P1, S2
cmp P0, P3
cmovg S1, P3
cmovg P3, P0
cmovle S1, P0
mov P0, S1
cmp S1, P2
cmovle S1, P2
cmovl P2, P0
cmp P1, P3
cmovg P0, P1
