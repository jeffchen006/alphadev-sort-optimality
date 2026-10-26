# n=5 model=out iset=I1 prefix14_class=8245
cmp P1, P2
cmovle S0, P2
cmovle P2, P1
cmovle P1, S0
mov S1, P2
cmp P3, P0
mov S2, P0
cmovge P0, P3
cmovg P3, S2
cmp P2, P3
cmovl P2, P3
cmovge S1, P3
cmp P1, P0
cmovg S1, P1
