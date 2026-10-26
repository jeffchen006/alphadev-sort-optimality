# n=5 model=out iset=I1 prefix14_class=6406
cmp P1, P3
cmovg S0, P1
cmovg P1, P3
cmovg P3, S0
mov S1, P0
cmp P2, S1
cmovle P0, P2
cmovg S1, P2
cmovle P2, S1
cmp P3, S1
cmovg P2, P3
cmovle S1, P3
cmp P0, P1
cmovge S0, P1
