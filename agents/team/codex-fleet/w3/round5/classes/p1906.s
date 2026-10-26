# n=5 model=out iset=I1 prefix14_class=1906
cmp P1, P2
cmovle S2, P2
cmovle P2, P1
cmovle P1, S2
cmp P0, P3
mov S2, P3
cmovge S2, P0
cmovl P3, P0
cmp S2, P1
cmovg P0, P1
cmovge P1, S2
cmovg S2, P0
mov S1, P3
cmp P3, P2
