# n=5 model=out iset=I1 prefix14_class=9698
cmp P0, P2
mov S0, P3
cmovge S1, P0
cmovle S1, P2
cmovg P0, P2
cmp P1, S0
cmovg P3, P1
cmovg P1, S0
cmp P3, S1
cmovle S2, S1
cmovle S1, P3
mov P2, P1
cmovle P3, S2
cmp P1, P0
