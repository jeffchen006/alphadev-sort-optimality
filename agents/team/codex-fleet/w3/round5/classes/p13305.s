# n=5 model=out iset=I1 prefix14_class=13305
mov S2, P3
cmp P1, P3
cmovg S2, P1
cmovle P3, P1
cmp P0, P2
cmovle S1, P2
cmovle P2, P0
cmovl P0, S1
cmp P3, P2
mov P1, P0
cmovge S1, P3
cmovg P3, P2
cmovge P2, S1
cmp P1, S2
