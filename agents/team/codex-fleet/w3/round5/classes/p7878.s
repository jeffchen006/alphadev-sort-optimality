# n=5 model=out iset=I1 prefix14_class=7878
cmp P3, P0
cmovle S1, P0
mov S2, P1
cmovl P0, P3
cmovg S1, P3
cmp S2, P2
mov P3, P0
cmovle P1, P2
cmovge S2, P2
cmp P3, S2
cmovge P0, S2
cmovge S2, P3
cmp S1, P1
cmovg P2, P1
