# n=5 model=out iset=I1 prefix14_class=13997
cmp P2, P0
mov S2, P3
cmovle S0, P0
cmovl P0, P2
cmovl P2, S0
cmp P3, P1
cmovge S2, P1
cmovge P1, P3
cmp P1, P2
cmovle P3, P2
cmovge P3, P1
cmovg P1, P2
cmp P0, S2
cmovg S1, P0
