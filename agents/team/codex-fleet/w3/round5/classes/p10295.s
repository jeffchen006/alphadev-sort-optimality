# n=5 model=out iset=I1 prefix14_class=10295
cmp P1, P3
mov S2, P1
cmovl P1, P3
cmovge S2, P3
cmp P2, P0
cmovge P3, P0
mov S1, P1
cmovge P0, P2
cmovg P2, P3
cmp P0, P1
cmovle P1, P0
cmovg S1, P0
cmp P2, S2
cmovle S1, S2
