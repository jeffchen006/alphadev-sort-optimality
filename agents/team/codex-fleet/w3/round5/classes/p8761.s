# n=5 model=out iset=I1 prefix14_class=8761
cmp P3, P1
mov S2, P1
cmovle S2, P3
cmovle P3, P1
cmp P2, P0
cmovle P1, P0
cmovge P1, P2
cmovl P0, P2
cmp P3, P1
cmovg S1, P3
cmovg P3, P1
cmovg P1, S1
cmp S2, P0
cmovge S1, S2
