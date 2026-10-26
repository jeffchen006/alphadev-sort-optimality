# n=5 model=out iset=I1 prefix14_class=10960
mov S0, P2
cmp P2, P0
cmovle P2, P0
cmovl P0, S0
cmp P1, P3
cmovge S1, P1
cmovge P1, P3
cmovg P3, S1
cmp P3, P2
cmovle S2, P3
cmovg S2, P2
cmovg P2, P3
cmp P0, P1
cmovle P3, P1
