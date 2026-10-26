# n=5 model=out iset=I1 prefix14_class=10845
mov S2, P3
cmp S2, P1
cmovge P3, P1
cmovge P1, S2
cmp P0, P2
cmovle S2, P0
cmovg S2, P2
cmovg P2, P0
cmp P1, P2
cmovl P0, P2
cmovle P2, P1
cmovl P1, P0
cmp S2, P3
cmovge S1, S2
